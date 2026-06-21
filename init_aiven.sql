-- =============================================================================
-- HONEYPOT DATABASE SCHEMA
-- Bells University of Technology — Information Gathering Honeypot
-- Author: AWOLEKE FAITH OLASUBOMI | 2021/10969
--
-- HOW TO INITIALISE:
--   mysql -u root -p < init.sql
-- =============================================================================

-- Create dedicated honeypot database


-- =============================================================================
-- TABLE 1: attack_logs
-- Maps directly to Data Dictionary (Section 3.6.2, Table: attack_logs)
-- This is the primary intelligence store — every actor interaction is here.
-- =============================================================================
CREATE TABLE IF NOT EXISTS attack_logs (
    -- Primary Key
    log_id          INT(11)         NOT NULL AUTO_INCREMENT,

    -- Core fields from Data Dictionary
    ip_address      VARCHAR(45)     NOT NULL COMMENT 'IPv4 or IPv6 of threat actor',
    timestamp       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
                                    COMMENT 'UTC datetime of the probe',
    user_agent      TEXT                     COMMENT 'Browser/OS fingerprint for bot detection',
    payload         TEXT                     COMMENT 'Exact string entered (SQLi code, XSS script, credentials)',
    threat_type     VARCHAR(50)     NOT NULL COMMENT 'TTP label: SQL_INJECTION, XSS, BRUTE_FORCE, etc.',

    -- Extended metadata (Section 3.5.1 — Layer 1 & 2 logging)
    request_path    VARCHAR(255)    NOT NULL DEFAULT '/'
                                    COMMENT 'URL path that was probed',
    http_method     VARCHAR(10)     NOT NULL DEFAULT 'GET'
                                    COMMENT 'HTTP verb used by the actor',
    referrer        VARCHAR(500)             COMMENT 'HTTP Referer header',
    session_token   VARCHAR(64)              COMMENT 'Per-session tracking UUID for TTP correlation',

    PRIMARY KEY (log_id),

    -- Indexes for fast analysis queries (Section 4 analysis)
    INDEX idx_ip            (ip_address),
    INDEX idx_timestamp     (timestamp),
    INDEX idx_threat_type   (threat_type),
    INDEX idx_request_path  (request_path(100))

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Primary intelligence store — all attacker interactions';


-- =============================================================================
-- TABLE 2: mock_students
-- Maps directly to Data Dictionary (Section 3.6.2, Table: mock_students)
-- 100% synthetic records — zero real PII (Section 3.7 Ethical Considerations)
-- Displayed to the attacker to extend engagement time (Deception Phase).
-- =============================================================================
CREATE TABLE IF NOT EXISTS mock_students (
    -- Core fields from Data Dictionary
    student_id      INT(11)         NOT NULL AUTO_INCREMENT
                                    COMMENT 'Unique auto-incrementing identifier',
    matric_no       VARCHAR(15)     NOT NULL
                                    COMMENT 'Simulated matriculation number for UI realism',
    full_name       VARCHAR(100)    NOT NULL
                                    COMMENT 'Synthetic student name for deception layer',
    mock_result     VARCHAR(10)              COMMENT 'Deceptive grade data (e.g. 4.21)',

    -- Extended fields to populate all portal UI panels
    department      VARCHAR(100)    NOT NULL DEFAULT 'COMPUTER SCIENCE AND INFORMATION TECHNOLOGY',
    department_code VARCHAR(10)     NOT NULL DEFAULT 'CSCIT',
    program         VARCHAR(100)    NOT NULL DEFAULT 'COMPUTER SCIENCE',
    level           INT(4)          NOT NULL DEFAULT 400,
    state_of_origin VARCHAR(50)              DEFAULT 'LAGOS',
    phone_number    VARCHAR(20)              DEFAULT '08000000000',
    session         VARCHAR(20)     NOT NULL DEFAULT '2024/2025',
    current_semester VARCHAR(20)    NOT NULL DEFAULT 'Extension',

    PRIMARY KEY (student_id),
    UNIQUE KEY uq_matric (matric_no)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='100% synthetic student records — no real PII stored';


-- =============================================================================
-- TABLE 3: mock_results
-- Synthetic academic result rows displayed on the Result Page.
-- Populates the result table in the honeypot to look like a real portal.
-- =============================================================================
CREATE TABLE IF NOT EXISTS mock_results (
    result_id       INT(11)         NOT NULL AUTO_INCREMENT,
    matric_no       VARCHAR(15)     NOT NULL,
    department      VARCHAR(10)     NOT NULL DEFAULT 'CSCIT',
    session         VARCHAR(20)     NOT NULL,
    semester        VARCHAR(10)     NOT NULL,
    level           INT(4)          NOT NULL,
    sn              INT(3)          NOT NULL COMMENT 'Display row number',

    PRIMARY KEY (result_id),
    INDEX idx_matric (matric_no)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Synthetic result rows for the deception result page';


-- =============================================================================
-- SEED DATA
-- Populate mock tables with synthetic data that mirrors the actual portal.
-- Matric 2021/10969 matches the case-study student in the screenshots.
-- =============================================================================

-- ── Synthetic student records ─────────────────────────────────────────────────
INSERT INTO mock_students
    (matric_no, full_name, mock_result, department, department_code,
     program, level, state_of_origin, phone_number, session, current_semester)
VALUES
    ('2021/10969', 'AWOLEKE FAITH OLASUBOMI', '4.21',
     'COMPUTER SCIENCE AND INFORMATION TECHNOLOGY', 'CSCIT',
     'COMPUTER SCIENCE', 400, 'LAGOS', '09072659278', '2024/2025', 'Extension'),

    ('2021/10970', 'ADEYEMI SEGUN OLAWALE', '3.87',
     'COMPUTER SCIENCE AND INFORMATION TECHNOLOGY', 'CSCIT',
     'COMPUTER SCIENCE', 400, 'OGUN', '08031234567', '2024/2025', 'Extension'),

    ('2021/10971', 'IBRAHIM FATIMA ZAHRA', '4.05',
     'COMPUTER SCIENCE AND INFORMATION TECHNOLOGY', 'CSCIT',
     'INFORMATION TECHNOLOGY', 400, 'KANO', '07087654321', '2024/2025', 'Extension'),

    ('2020/09821', 'OKAFOR CHUKWUEMEKA', '3.65',
     'COMPUTER SCIENCE AND INFORMATION TECHNOLOGY', 'CSCIT',
     'COMPUTER SCIENCE', 500, 'ANAMBRA', '09011223344', '2024/2025', 'Extension'),

    ('2022/11201', 'BELLO AMINA HAUWA', '3.91',
     'COMPUTER SCIENCE AND INFORMATION TECHNOLOGY', 'CSCIT',
     'INFORMATION TECHNOLOGY', 300, 'SOKOTO', '08155667788', '2024/2025', 'Second'),

    -- Extra synthetic records to make the honey-database look populated
    ('2021/10972', 'ONYEKA CHISOM BLESSING', '4.10',
     'COMPUTER SCIENCE AND INFORMATION TECHNOLOGY', 'CSCIT',
     'COMPUTER SCIENCE', 400, 'IMO', '08099887766', '2024/2025', 'Extension'),

    ('2021/10973', 'AFOLABI TOSIN RUTH', '3.72',
     'COMPUTER SCIENCE AND INFORMATION TECHNOLOGY', 'CSCIT',
     'COMPUTER SCIENCE', 400, 'EKITI', '07066554433', '2024/2025', 'Extension'),

    ('2020/09822', 'UMAR SADIQ ABUBAKAR', '3.55',
     'COMPUTER SCIENCE AND INFORMATION TECHNOLOGY', 'CSCIT',
     'INFORMATION TECHNOLOGY', 500, 'KADUNA', '08144332211', '2024/2025', 'Extension');


-- ── Synthetic result rows for matric 2021/10969 ──────────────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn)
VALUES
    ('2021/10969', 'CSCIT', '2021/2022', 'First',  100, 1),
    ('2021/10969', 'CSCIT', '2021/2022', 'Second', 100, 2),
    ('2021/10969', 'CSCIT', '2022/2023', 'First',  200, 3),
    ('2021/10969', 'CSCIT', '2022/2023', 'Second', 200, 4),
    ('2021/10969', 'CSCIT', '2023/2024', 'First',  300, 5);


-- ── Verification queries (run these to confirm setup) ────────────────────────
-- SELECT COUNT(*) AS students_loaded   FROM mock_students;
-- SELECT COUNT(*) AS result_rows       FROM mock_results;
-- SELECT COUNT(*) AS attack_logs_count FROM attack_logs;
-- DESCRIBE attack_logs;
