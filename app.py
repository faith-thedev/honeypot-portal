"""
=============================================================================
Design Principle (Glastopf):
  "Reply-to-all" — The system NEVER rejects any input, including malicious
  SQLi/XSS/traversal payloads. Every interaction is accepted and logged,
  keeping the attacker engaged long enough to extract full TTPs.
=============================================================================
"""

import os
import re
import uuid
import logging
from datetime import datetime
from functools import wraps

import mysql.connector
from mysql.connector import Error as MySQLError
from flask import (
    Flask, render_template, request,
    redirect, url_for, session, jsonify
)

# ─────────────────────────────────────────────────────────────────────────────
# APP INITIALISATION
# ─────────────────────────────────────────────────────────────────────────────
app = Flask(__name__)
app.secret_key = os.environ.get("HONEYPOT_SECRET", "bells_honeypot_key_2024")

# ─────────────────────────────────────────────────────────────────────────────
# DATABASE CONFIGURATION  (Manual / Local MySQL — no Docker required)
# Change DB_PASSWORD to match your local MySQL root password.
# ─────────────────────────────────────────────────────────────────────────────
DB_CONFIG = {
    "host":     os.environ.get("DB_HOST",     "mysql-2331aef0-faithshubshoneypot.b.aivencloud.com"),
    "port":     int(os.environ.get("DB_PORT", 24564)),
    "user":     os.environ.get("DB_USER",     "avnadmin"),
    "password": os.environ.get("DB_PASSWORD", "AVNS_RYEalRtT-er10pNjkwS"),
    "database": os.environ.get("DB_NAME",     "defaultdb"),
    "charset":  "utf8mb4",
    "ssl_ca":   os.environ.get("DB_SSL_CA",   "ca.pem"),
    "ssl_verify_cert": True,
    "ssl_verify_identity": False,
}

# ─────────────────────────────────────────────────────────────────────────────
# LOGGING SETUP  (file + console — helps verify the engine is working)
# ─────────────────────────────────────────────────────────────────────────────
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[
        logging.FileHandler("honeypot.log"),
        logging.StreamHandler(),
    ],
)
logger = logging.getLogger(__name__)


# ─────────────────────────────────────────────────────────────────────────────
# DATABASE HELPERS
# ─────────────────────────────────────────────────────────────────────────────
def get_db_connection():
    """Return a new MySQL connection.  Returns None on failure."""
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        return conn
    except MySQLError as exc:
        logger.error("DB connection failed: %s", exc)
        return None


# ─────────────────────────────────────────────────────────────────────────────
# TTP CLASSIFICATION ENGINE
# Implements the "Feature Engineering" described in Section 3.5.2.
# Classifies each payload into a threat category using regex pattern matching.
# ─────────────────────────────────────────────────────────────────────────────

# Ordered pattern sets — first match wins.
TTP_PATTERNS = [
    # ── SQL Injection (SQLi) ─────────────────────────────────────────────────
    ("SQL_INJECTION", [
        r"'\s*(or|and)\s*'?\d",         # ' OR '1'='1
        r"--\s*$",                       # comment terminator
        r"\bunion\b.*\bselect\b",        # UNION SELECT
        r"\bselect\b.*\bfrom\b",         # generic SELECT FROM
        r"\bdrop\b.*\btable\b",          # DROP TABLE
        r"\binsert\b.*\binto\b",         # INSERT INTO
        r"\bdelete\b.*\bfrom\b",         # DELETE FROM
        r"\bexec\b\s*\(",                # EXEC()
        r"1\s*=\s*1",                    # 1=1 tautology
        r"'\s*;\s*--",                   # '; --
        r"0x[0-9a-f]+",                  # hex encoding
        r"\bsleep\s*\(\d+\)",           # time-based blind
        r"\bbenchmark\s*\(",             # MySQL BENCHMARK()
        r"\bchar\s*\(\d+",              # CHAR() encoding
        r"\bconcat\s*\(",                # CONCAT() exfiltration
        r"information_schema",           # schema enumeration
        r"'\s*or\s*\d+\s*=\s*\d+",     # ' or 1=1
    ]),

    # ── Cross-Site Scripting (XSS) ───────────────────────────────────────────
    ("XSS", [
        r"<\s*script",                   # <script ...>
        r"javascript\s*:",               # javascript: URI
        r"on\w+\s*=\s*[\"']",           # onerror=, onload=, etc.
        r"<\s*img[^>]*src\s*=",         # <img src=...>
        r"alert\s*\(",                   # alert()
        r"document\.cookie",             # cookie theft
        r"document\.write\s*\(",         # DOM write
        r"eval\s*\(",                    # eval()
        r"<\s*iframe",                   # iframe injection
        r"expression\s*\(",              # CSS expression()
        r"vbscript\s*:",                 # VBScript URI
        r"&#\d+;",                       # HTML entity encoding
        r"%3cscript",                    # URL-encoded <script
    ]),

    # ── Path / Directory Traversal ───────────────────────────────────────────
    ("PATH_TRAVERSAL", [
        r"\.\./",                        # ../
        r"\.\.\\",                       # ..\
        r"/etc/passwd",
        r"/etc/shadow",
        r"proc/self/environ",
        r"boot\.ini",
        r"win\.ini",
        r"system32",
        r"%2e%2e%2f",                    # URL-encoded ../
        r"\.\.%2f",
    ]),

    # ── Brute-Force / Credential Stuffing ────────────────────────────────────
    ("BRUTE_FORCE", [
        r"^(admin|root|administrator|user|test|guest|support)$",
        r"^(password|pass|12345678?|qwerty|letmein|welcome|login)$",
        r"^(abc123|iloveyou|monkey|master|dragon)$",
    ]),

    # ── Payment Manipulation ─────────────────────────────────────────────────
    ("PAYMENT_MANIPULATION", [
        r"amount\s*=\s*0",
        r"price\s*=\s*[0-1]",
        r"total\s*=\s*-",
        r"tuition.*=.*0",
        r"fee.*manipulat",
    ]),
]


def classify_threat(matric: str, password: str, path: str) -> str:
    """
    Classify attacker interaction into a threat category.

    Strategy:
      1. Check matric + password + path combined for most threat types.
      2. Check password field alone for BRUTE_FORCE (needs word-boundary anchors).
      3. Fall back to RECON (no input) or CREDENTIAL_PROBE (normal login attempt).
    """
    combined = f"{matric} {password} {path}".strip()

    for threat_label, patterns in TTP_PATTERNS:
        for pattern in patterns:
            # BRUTE_FORCE patterns use ^ / $ anchors — test each field individually
            if threat_label == "BRUTE_FORCE":
                for field in (matric, password):
                    if re.search(pattern, field.strip(), re.IGNORECASE):
                        logger.info("TTP detected: %-25s | field='%s'", threat_label, field[:40])
                        return threat_label
            else:
                if re.search(pattern, combined, re.IGNORECASE):
                    logger.info("TTP detected: %-25s | pattern='%s'", threat_label, pattern)
                    return threat_label

    if not matric and not password:
        return "RECON"

    return "CREDENTIAL_PROBE"


# ─────────────────────────────────────────────────────────────────────────────
# LOGGING ENGINE  —  Section 3.3 / Data Dictionary
# Writes every attacker interaction to the attack_logs MySQL table.
# ─────────────────────────────────────────────────────────────────────────────
def log_attack(
    ip_address: str,
    user_agent: str,
    payload: str,
    threat_type: str,
    request_path: str = "/",
    http_method: str = "GET",
    referrer: str = "",
    session_token: str = "",
):
    """
    Core logging function.  Maps directly to the attack_logs schema:
        log_id | ip_address | timestamp | user_agent | payload | threat_type
    Extended columns (request_path, http_method, referrer, session_token)
    provide the deep metadata referenced in Section 3.5.1.
    """
    conn = get_db_connection()
    if conn is None:
        # Fallback: write to flat log file so no data is lost
        logger.warning(
            "DB unavailable — FLAT LOG | ip=%s | path=%s | type=%s | payload=%s",
            ip_address, request_path, threat_type, payload[:200],
        )
        return

    try:
        cursor = conn.cursor()
        sql = """
            INSERT INTO attack_logs
                (ip_address, user_agent, payload, threat_type,
                 request_path, http_method, referrer, session_token, timestamp)
            VALUES
                (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        cursor.execute(sql, (
            ip_address[:45],
            (user_agent or "")[:500],
            (payload or "")[:4000],       # Truncate to TEXT-safe length
            threat_type[:50],
            (request_path or "/")[:255],
            (http_method or "GET")[:10],
            (referrer or "")[:500],
            (session_token or "")[:64],
            datetime.utcnow(),
        ))
        conn.commit()
        logger.info(
            "LOGGED | ip=%-18s | type=%-25s | path=%s",
            ip_address, threat_type, request_path,
        )
    except MySQLError as exc:
        logger.error("Insert failed: %s", exc)
    finally:
        cursor.close()
        conn.close()


# ─────────────────────────────────────────────────────────────────────────────
# DECEPTION ENGINE  —  Section 3.1 / 3.6
# Queries mock_students and mock_results to return convincing fake data.
# ─────────────────────────────────────────────────────────────────────────────
def get_mock_student(matric_no: str) -> dict:
    """
    Queries mock_students table.
    If matric_no not found, returns a generic plausible record so the attacker
    always sees a 'successful login' (Glastopf reply-to-all principle).
    """
    conn = get_db_connection()
    if conn:
        try:
            cursor = conn.cursor(dictionary=True)
            cursor.execute(
                "SELECT * FROM mock_students WHERE matric_no = %s LIMIT 1",
                (matric_no,)
            )
            student = cursor.fetchone()
            cursor.close()
            conn.close()
            if student:
                return student
        except MySQLError as exc:
            logger.error("mock_students query failed: %s", exc)

    # Fallback synthetic record — never breaks the deception
    return {
        "student_id":    1,
        "matric_no":     matric_no or "2019/06423",
        "full_name":     "OGUNLEYE TAIWO SAMUEL",
        "department":    "COMPUTER SCIENCE AND INFORMATION TECHNOLOGY",
        "department_code": "CSCIT",
        "program":       "COMPUTER SCIENCE",
        "level":         500,
        "state_of_origin": "OGUN",
        "phone_number":  "08031112233",
        "session":       "2024/2025",
        "current_semester": "Extension",
    }


def get_mock_results(matric_no: str) -> list:
    """
    Returns all result rows for a given matric number from mock_results.
    Falls back to hard-coded rows matching the screenshot exactly.
    """
    conn = get_db_connection()
    if conn:
        try:
            cursor = conn.cursor(dictionary=True)
            cursor.execute(
                """SELECT * FROM mock_results
                   WHERE matric_no = %s
                   ORDER BY level ASC, semester ASC""",
                (matric_no,)
            )
            rows = cursor.fetchall()
            cursor.close()
            conn.close()
            if rows:
                return rows
        except MySQLError as exc:
            logger.error("mock_results query failed: %s", exc)

    # Fallback result rows (matches portal screenshot exactly)
    return [
        {"sn": 1, "department": "CSCIT", "session": "2021/2022", "semester": "First",  "level": 100},
        {"sn": 2, "department": "CSCIT", "session": "2021/2022", "semester": "Second", "level": 100},
        {"sn": 3, "department": "CSCIT", "session": "2022/2023", "semester": "First",  "level": 200},
        {"sn": 4, "department": "CSCIT", "session": "2022/2023", "semester": "Second", "level": 200},
        {"sn": 5, "department": "CSCIT", "session": "2023/2024", "semester": "First",  "level": 300},
    ]


# ─────────────────────────────────────────────────────────────────────────────
# HELPER: extract real IP from proxies / load balancers
# ─────────────────────────────────────────────────────────────────────────────
def get_real_ip() -> str:
    """Prefer X-Forwarded-For header (common behind Nginx reverse proxy)."""
    xff = request.headers.get("X-Forwarded-For", "")
    if xff:
        return xff.split(",")[0].strip()
    return request.remote_addr or "0.0.0.0"


def get_session_token() -> str:
    """Return or create a per-session tracking token for TTP correlation."""
    if "tracker" not in session:
        session["tracker"] = uuid.uuid4().hex
    return session["tracker"]


# ─────────────────────────────────────────────────────────────────────────────
# ROUTES
# ─────────────────────────────────────────────────────────────────────────────

# ── LOGIN PAGE ────────────────────────────────────────────────────────────────
@app.route("/", methods=["GET"])
@app.route("/login", methods=["GET"])
def login_get():
    ip = get_real_ip()
    ua = request.headers.get("User-Agent", "")
    log_attack(ip, ua, "", "RECON", request.path, "GET",
               request.referrer or "", get_session_token())
    return render_template("login.html")


@app.route("/login", methods=["POST"])
def login_post():
    """
    Glastopf 'reply-to-all':
    Accept ANY matric/password combination, including SQLi/XSS payloads.
    Log the full credential pair, classify the threat, then redirect to portal.
    """
    ip     = get_real_ip()
    ua     = request.headers.get("User-Agent", "")
    matric = request.form.get("matric_no",  "").strip()
    passwd = request.form.get("password",   "").strip()

    payload      = f"matric_no={matric}&password={passwd}"
    threat_type  = classify_threat(matric, passwd, "/login")

    log_attack(ip, ua, payload, threat_type, "/login", "POST",
               request.referrer or "", get_session_token())

    # Always grant access — clear old session first, then store new matric
    session.clear()
    session["matric_no"]  = matric if matric else "2019/06423"
    session["logged_in"]  = True

    logger.info("LOGIN ACCEPTED | ip=%s | matric=%s | type=%s", ip, matric, threat_type)
    return redirect("/portalhome.php")


# ── PORTAL HOME ───────────────────────────────────────────────────────────────
@app.route("/portalhome.php", methods=["GET"])
def portal_home():
    ip = get_real_ip()
    ua = request.headers.get("User-Agent", "")
    log_attack(ip, ua, request.query_string.decode(), "RECON",
               "/portalhome.php", "GET", request.referrer or "", get_session_token())

    matric  = session.get("matric_no", "2019/06423")
    student = get_mock_student(matric)
    return render_template("portalhome.html", student=student)


# ── RESULT PAGE ───────────────────────────────────────────────────────────────
@app.route("/printresult.php", methods=["GET"])
def print_result():
    ip = get_real_ip()
    ua = request.headers.get("User-Agent", "")
    log_attack(ip, ua, "", "RECON", "/printresult.php", "GET",
               request.referrer or "", get_session_token())

    matric  = session.get("matric_no", "2019/06423")
    student = get_mock_student(matric)
    results = get_mock_results(matric)
    return render_template("result.html", student=student, results=results)


# ── PAYMENT DETAILS ───────────────────────────────────────────────────────────
@app.route("/payment-details.php", methods=["GET", "POST"])
def payment_details():
    ip = get_real_ip()
    ua = request.headers.get("User-Agent", "")

    if request.method == "POST":
        # Capture any attempted parameter tampering (amount=0, etc.)
        payload     = request.get_data(as_text=True)
        threat_type = classify_threat(payload, "", "/payment-details.php")
        log_attack(ip, ua, payload, threat_type, "/payment-details.php",
                   "POST", request.referrer or "", get_session_token())
    else:
        log_attack(ip, ua, request.query_string.decode(), "RECON",
                   "/payment-details.php", "GET", request.referrer or "",
                   get_session_token())

    matric  = session.get("matric_no", "2019/06423")
    student = get_mock_student(matric)
    # Generate a plausible-looking transaction reference
    txn_ref = "7529" + uuid.uuid4().hex[:12].upper()
    return render_template("payment.html", student=student, txn_ref=txn_ref)


# ── FAKE PAY NOW (Deceptive Response Engine) ─────────────────────────────────
@app.route("/pay-now", methods=["POST"])
def pay_now():
    ip = get_real_ip()
    ua = request.headers.get("User-Agent", "")

    # Log full POST body to catch parameter tampering / amount manipulation
    payload     = request.get_data(as_text=True)
    threat_type = classify_threat(payload, "", "/pay-now")
    log_attack(ip, ua, payload, threat_type, "/pay-now", "POST",
               request.referrer or "", get_session_token())

    logger.warning(
        "PAYMENT ATTEMPT | ip=%s | type=%s | payload=%s",
        ip, threat_type, payload[:200],
    )
    # Glastopf: redirect back with a plausible "pending" state — never error out
    return redirect("/portalhome.php?payment=pending")


# ── CATCH-ALL  (Glastopf 'reply-to-all') ─────────────────────────────────────
@app.route("/<path:path>", methods=["GET", "POST", "PUT", "DELETE", "PATCH"])
def catch_all(path: str):
    """
    Intercepts ALL other requests — directory traversal probes, scanner paths,
    /admin, /wp-login.php, /api/* etc.
    Always returns HTTP 200 with the login page to maximise engagement.
    Every hit is fully logged.
    """
    ip = get_real_ip()
    ua = request.headers.get("User-Agent", "")

    # Capture body or query string as payload
    if request.method in ("POST", "PUT", "PATCH"):
        raw_payload = request.get_data(as_text=True)
    else:
        raw_payload = request.query_string.decode("utf-8", errors="replace")

    # Include path itself in classification (catches traversal in the URL)
    full_signal  = f"{path}?{raw_payload}"
    threat_type  = classify_threat(path, raw_payload, f"/{path}")

    log_attack(ip, ua, full_signal[:4000], threat_type, f"/{path}",
               request.method, request.referrer or "", get_session_token())

    # Return login page with HTTP 200 (not 404) — keeps probes engaged
    return render_template("login.html"), 200


# ─────────────────────────────────────────────────────────────────────────────
# ENTRY POINT
# ─────────────────────────────────────────────────────────────────────────────
if __name__ == "__main__":
    # debug=False is CRITICAL in a honeypot — never expose the debugger
    app.run(host="0.0.0.0", port=5000, debug=False)