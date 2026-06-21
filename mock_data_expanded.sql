-- =============================================================================
-- EXPANDED MOCK DATA — Bells University of Technology Honeypot
-- 25 synthetic students across real Bells departments
-- ALL matric numbers are fictional — no real student data
-- Run this AFTER init.sql has already created the tables
-- Command: mysql -u root -p honeypot_db < mock_data_expanded.sql
-- =============================================================================

USE honeypot_db;

-- Clear existing seed data first
DELETE FROM mock_results;
DELETE FROM mock_students;

-- Reset auto-increment
ALTER TABLE mock_students AUTO_INCREMENT = 1;
ALTER TABLE mock_results  AUTO_INCREMENT = 1;

-- =============================================================================
-- DEPARTMENT REFERENCE (real Bells University departments)
-- 5-year (500L): CSCIT, INFOTECH, COMPENG, MECHENG, CIVENG, BIOMEDENG, ARCH
-- 4-year (400L): BUSADM, ACCT, ESTMGT, QS, URBPLAN, FOODSCI
-- =============================================================================

INSERT INTO mock_students
    (matric_no, full_name, mock_result, department, department_code,
     program, level, state_of_origin, phone_number, session, current_semester)
VALUES

-- ── COLLEGE OF INFORMATION & COMMUNICATIONS TECHNOLOGY ────────────────────────

-- Computer Science (500L program) — 5 students
('2019/06423', 'OGUNLEYE TAIWO SAMUEL',       '3.92',
 'COMPUTER SCIENCE AND INFORMATION TECHNOLOGY', 'CSCIT',
 'COMPUTER SCIENCE', 500, 'OGUN',    '08031112233', '2024/2025', 'Extension'),

('2020/07841', 'NWOSU CHIDINMA GRACE',         '4.15',
 'COMPUTER SCIENCE AND INFORMATION TECHNOLOGY', 'CSCIT',
 'COMPUTER SCIENCE', 400, 'ANAMBRA', '07045556677', '2024/2025', 'Extension'),

('2021/08932', 'HASSAN ABDULLAHI MUSA',        '3.68',
 'COMPUTER SCIENCE AND INFORMATION TECHNOLOGY', 'CSCIT',
 'COMPUTER SCIENCE', 300, 'KANO',    '09011223344', '2024/2025', 'Second'),

('2022/09174', 'ADEWALE FUNMILAYO ESTHER',     '4.03',
 'COMPUTER SCIENCE AND INFORMATION TECHNOLOGY', 'CSCIT',
 'COMPUTER SCIENCE', 200, 'LAGOS',   '08155667788', '2024/2025', 'Second'),

('2023/10281', 'IBRAHIM YUSUF GARBA',          '3.55',
 'COMPUTER SCIENCE AND INFORMATION TECHNOLOGY', 'CSCIT',
 'COMPUTER SCIENCE', 100, 'SOKOTO',  '07099887766', '2024/2025', 'Second'),

-- Information Technology (500L program) — 3 students
('2019/06587', 'OLAWALE BLESSING OMOWUNMI',   '3.78',
 'COMPUTER SCIENCE AND INFORMATION TECHNOLOGY', 'CSCIT',
 'INFORMATION TECHNOLOGY', 500, 'ONDO',    '08022334455', '2024/2025', 'Extension'),

('2020/07653', 'AMADI CHUKWUEBUKA FELIX',      '4.22',
 'COMPUTER SCIENCE AND INFORMATION TECHNOLOGY', 'CSCIT',
 'INFORMATION TECHNOLOGY', 400, 'IMO',     '09066778899', '2024/2025', 'Extension'),

('2021/08745', 'SULEIMAN FATIMA ZAHRA',        '3.91',
 'COMPUTER SCIENCE AND INFORMATION TECHNOLOGY', 'CSCIT',
 'INFORMATION TECHNOLOGY', 300, 'KADUNA',  '07033445566', '2024/2025', 'Second'),

-- ── COLLEGE OF ENGINEERING ────────────────────────────────────────────────────

-- Mechatronics Engineering (500L) — 3 students
('2019/06312', 'ADEOLA OLUMIDE VICTOR',        '3.61',
 'MECHATRONICS ENGINEERING', 'MECHENG',
 'MECHATRONICS ENGINEERING', 500, 'EKITI',  '08077889900', '2024/2025', 'Extension'),

('2020/07129', 'OKEKE KENECHUKWU DANIEL',      '3.87',
 'MECHATRONICS ENGINEERING', 'MECHENG',
 'MECHATRONICS ENGINEERING', 400, 'ENUGU',  '09055443322', '2024/2025', 'Extension'),

('2021/08463', 'BELLO HAUWA AISHA',            '4.08',
 'MECHATRONICS ENGINEERING', 'MECHENG',
 'MECHATRONICS ENGINEERING', 300, 'BAUCHI', '07088776655', '2024/2025', 'Second'),

-- Civil & Environmental Engineering (500L) — 3 students
('2019/06891', 'OKAFOR EMEKA RIGHTEOUS',       '3.74',
 'CIVIL AND ENVIRONMENTAL ENGINEERING', 'CIVENG',
 'CIVIL AND ENVIRONMENTAL ENGINEERING', 500, 'IMO',    '08044556677', '2024/2025', 'Extension'),

('2020/07334', 'ABUBAKAR ZAINAB HADIZA',       '3.95',
 'CIVIL AND ENVIRONMENTAL ENGINEERING', 'CIVENG',
 'CIVIL AND ENVIRONMENTAL ENGINEERING', 400, 'KATSINA','09077665544', '2024/2025', 'Extension'),

('2022/09562', 'ADEYEMI ROTIMI BLESSING',      '3.42',
 'CIVIL AND ENVIRONMENTAL ENGINEERING', 'CIVENG',
 'CIVIL AND ENVIRONMENTAL ENGINEERING', 200, 'OGUN',   '07011223344', '2024/2025', 'Second'),

-- Biomedical Engineering (500L) — 2 students
('2020/07012', 'UCHENNA ADAEZE MIRIAM',        '4.31',
 'BIOMEDICAL ENGINEERING', 'BIOENG',
 'BIOMEDICAL ENGINEERING', 400, 'DELTA',   '08099001122', '2024/2025', 'Extension'),

('2021/08291', 'MUSA ALIYU ABDULKARIM',        '3.66',
 'BIOMEDICAL ENGINEERING', 'BIOENG',
 'BIOMEDICAL ENGINEERING', 300, 'NIGER',   '09033221100', '2024/2025', 'Second'),

-- ── COLLEGE OF ENVIRONMENTAL SCIENCES ────────────────────────────────────────

-- Architecture (500L) — 2 students
('2019/06734', 'FOLARIN ADUNOLA PATRICIA',     '3.83',
 'ARCHITECTURE', 'ARCH',
 'ARCHITECTURE', 500, 'LAGOS',   '08066554433', '2024/2025', 'Extension'),

('2021/08614', 'OLUMIDE SEGUN GABRIEL',        '3.59',
 'ARCHITECTURE', 'ARCH',
 'ARCHITECTURE', 300, 'OSUN',    '07044332211', '2024/2025', 'Second'),

-- Estate Management (400L) — 2 students
('2020/07892', 'NKECHI ADAORA JOSEPHINE',      '3.77',
 'ESTATE MANAGEMENT', 'ESTMGT',
 'ESTATE MANAGEMENT', 400, 'RIVERS',  '08011334455', '2024/2025', 'Extension'),

('2022/09038', 'YUSUF MARYAM HAUWA',           '3.48',
 'ESTATE MANAGEMENT', 'ESTMGT',
 'ESTATE MANAGEMENT', 200, 'JIGAWA', '09099887755', '2024/2025', 'Second'),

-- Quantity Surveying (400L) — 1 student
('2021/08123', 'TAIWO OLUWASEUN JOHN',         '3.91',
 'QUANTITY SURVEYING', 'QS',
 'QUANTITY SURVEYING', 300, 'KWARA',  '07022113344', '2024/2025', 'Second'),

-- ── COLLEGE OF MANAGEMENT SCIENCES ───────────────────────────────────────────

-- Business Administration (400L) — 2 students
('2020/07456', 'ADELEKE TOLUWANI GRACE',       '3.64',
 'BUSINESS ADMINISTRATION', 'BUSADM',
 'BUSINESS ADMINISTRATION', 400, 'OSUN',   '08033445500', '2024/2025', 'Extension'),

('2022/09341', 'OKORO CHIZARAM PEACE',         '3.82',
 'BUSINESS ADMINISTRATION', 'BUSADM',
 'BUSINESS ADMINISTRATION', 200, 'ABIA',   '09066221133', '2024/2025', 'Second'),

-- Accounting (400L) — 2 students
('2020/07678', 'ADEKUNLE OLUWAFEMI PAUL',      '3.71',
 'ACCOUNTING', 'ACCT',
 'ACCOUNTING', 400, 'OGUN',    '07055443300', '2024/2025', 'Extension'),

('2021/08856', 'MUHAMMED AISHA LAWAL',         '4.02',
 'ACCOUNTING', 'ACCT',
 'ACCOUNTING', 300, 'KANO',    '08077556644', '2024/2025', 'Second');


-- =============================================================================
-- MOCK RESULTS
-- Every student gets result rows matching their current level
-- Sessions follow the pattern: 100L=2021/2022 for a 2021 matric, etc.
-- =============================================================================

-- ── OGUNLEYE TAIWO SAMUEL | 2019/06423 | CS | 500L ───────────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2019/06423','CSCIT','2019/2020','First', 100,1),
('2019/06423','CSCIT','2019/2020','Second',100,2),
('2019/06423','CSCIT','2020/2021','First', 200,3),
('2019/06423','CSCIT','2020/2021','Second',200,4),
('2019/06423','CSCIT','2021/2022','First', 300,5),
('2019/06423','CSCIT','2021/2022','Second',300,6),
('2019/06423','CSCIT','2022/2023','First', 400,7),
('2019/06423','CSCIT','2022/2023','Second',400,8),
('2019/06423','CSCIT','2023/2024','First', 500,9);

-- ── NWOSU CHIDINMA GRACE | 2020/07841 | CS | 400L ────────────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2020/07841','CSCIT','2020/2021','First', 100,1),
('2020/07841','CSCIT','2020/2021','Second',100,2),
('2020/07841','CSCIT','2021/2022','First', 200,3),
('2020/07841','CSCIT','2021/2022','Second',200,4),
('2020/07841','CSCIT','2022/2023','First', 300,5),
('2020/07841','CSCIT','2022/2023','Second',300,6),
('2020/07841','CSCIT','2023/2024','First', 400,7);

-- ── HASSAN ABDULLAHI MUSA | 2021/08932 | CS | 300L ───────────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2021/08932','CSCIT','2021/2022','First', 100,1),
('2021/08932','CSCIT','2021/2022','Second',100,2),
('2021/08932','CSCIT','2022/2023','First', 200,3),
('2021/08932','CSCIT','2022/2023','Second',200,4),
('2021/08932','CSCIT','2023/2024','First', 300,5);

-- ── ADEWALE FUNMILAYO ESTHER | 2022/09174 | CS | 200L ────────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2022/09174','CSCIT','2022/2023','First', 100,1),
('2022/09174','CSCIT','2022/2023','Second',100,2),
('2022/09174','CSCIT','2023/2024','First', 200,3);

-- ── IBRAHIM YUSUF GARBA | 2023/10281 | CS | 100L ─────────────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2023/10281','CSCIT','2023/2024','First', 100,1);

-- ── OLAWALE BLESSING OMOWUNMI | 2019/06587 | IT | 500L ───────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2019/06587','CSCIT','2019/2020','First', 100,1),
('2019/06587','CSCIT','2019/2020','Second',100,2),
('2019/06587','CSCIT','2020/2021','First', 200,3),
('2019/06587','CSCIT','2020/2021','Second',200,4),
('2019/06587','CSCIT','2021/2022','First', 300,5),
('2019/06587','CSCIT','2021/2022','Second',300,6),
('2019/06587','CSCIT','2022/2023','First', 400,7),
('2019/06587','CSCIT','2022/2023','Second',400,8),
('2019/06587','CSCIT','2023/2024','First', 500,9);

-- ── AMADI CHUKWUEBUKA FELIX | 2020/07653 | IT | 400L ─────────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2020/07653','CSCIT','2020/2021','First', 100,1),
('2020/07653','CSCIT','2020/2021','Second',100,2),
('2020/07653','CSCIT','2021/2022','First', 200,3),
('2020/07653','CSCIT','2021/2022','Second',200,4),
('2020/07653','CSCIT','2022/2023','First', 300,5),
('2020/07653','CSCIT','2022/2023','Second',300,6),
('2020/07653','CSCIT','2023/2024','First', 400,7);

-- ── SULEIMAN FATIMA ZAHRA | 2021/08745 | IT | 300L ───────────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2021/08745','CSCIT','2021/2022','First', 100,1),
('2021/08745','CSCIT','2021/2022','Second',100,2),
('2021/08745','CSCIT','2022/2023','First', 200,3),
('2021/08745','CSCIT','2022/2023','Second',200,4),
('2021/08745','CSCIT','2023/2024','First', 300,5);

-- ── ADEOLA OLUMIDE VICTOR | 2019/06312 | MECHENG | 500L ──────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2019/06312','MECHENG','2019/2020','First', 100,1),
('2019/06312','MECHENG','2019/2020','Second',100,2),
('2019/06312','MECHENG','2020/2021','First', 200,3),
('2019/06312','MECHENG','2020/2021','Second',200,4),
('2019/06312','MECHENG','2021/2022','First', 300,5),
('2019/06312','MECHENG','2021/2022','Second',300,6),
('2019/06312','MECHENG','2022/2023','First', 400,7),
('2019/06312','MECHENG','2022/2023','Second',400,8),
('2019/06312','MECHENG','2023/2024','First', 500,9);

-- ── OKEKE KENECHUKWU DANIEL | 2020/07129 | MECHENG | 400L ────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2020/07129','MECHENG','2020/2021','First', 100,1),
('2020/07129','MECHENG','2020/2021','Second',100,2),
('2020/07129','MECHENG','2021/2022','First', 200,3),
('2020/07129','MECHENG','2021/2022','Second',200,4),
('2020/07129','MECHENG','2022/2023','First', 300,5),
('2020/07129','MECHENG','2022/2023','Second',300,6),
('2020/07129','MECHENG','2023/2024','First', 400,7);

-- ── BELLO HAUWA AISHA | 2021/08463 | MECHENG | 300L ──────────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2021/08463','MECHENG','2021/2022','First', 100,1),
('2021/08463','MECHENG','2021/2022','Second',100,2),
('2021/08463','MECHENG','2022/2023','First', 200,3),
('2021/08463','MECHENG','2022/2023','Second',200,4),
('2021/08463','MECHENG','2023/2024','First', 300,5);

-- ── OKAFOR EMEKA RIGHTEOUS | 2019/06891 | CIVENG | 500L ──────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2019/06891','CIVENG','2019/2020','First', 100,1),
('2019/06891','CIVENG','2019/2020','Second',100,2),
('2019/06891','CIVENG','2020/2021','First', 200,3),
('2019/06891','CIVENG','2020/2021','Second',200,4),
('2019/06891','CIVENG','2021/2022','First', 300,5),
('2019/06891','CIVENG','2021/2022','Second',300,6),
('2019/06891','CIVENG','2022/2023','First', 400,7),
('2019/06891','CIVENG','2022/2023','Second',400,8),
('2019/06891','CIVENG','2023/2024','First', 500,9);

-- ── ABUBAKAR ZAINAB HADIZA | 2020/07334 | CIVENG | 400L ──────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2020/07334','CIVENG','2020/2021','First', 100,1),
('2020/07334','CIVENG','2020/2021','Second',100,2),
('2020/07334','CIVENG','2021/2022','First', 200,3),
('2020/07334','CIVENG','2021/2022','Second',200,4),
('2020/07334','CIVENG','2022/2023','First', 300,5),
('2020/07334','CIVENG','2022/2023','Second',300,6),
('2020/07334','CIVENG','2023/2024','First', 400,7);

-- ── ADEYEMI ROTIMI BLESSING | 2022/09562 | CIVENG | 200L ─────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2022/09562','CIVENG','2022/2023','First', 100,1),
('2022/09562','CIVENG','2022/2023','Second',100,2),
('2022/09562','CIVENG','2023/2024','First', 200,3);

-- ── UCHENNA ADAEZE MIRIAM | 2020/07012 | BIOENG | 400L ───────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2020/07012','BIOENG','2020/2021','First', 100,1),
('2020/07012','BIOENG','2020/2021','Second',100,2),
('2020/07012','BIOENG','2021/2022','First', 200,3),
('2020/07012','BIOENG','2021/2022','Second',200,4),
('2020/07012','BIOENG','2022/2023','First', 300,5),
('2020/07012','BIOENG','2022/2023','Second',300,6),
('2020/07012','BIOENG','2023/2024','First', 400,7);

-- ── MUSA ALIYU ABDULKARIM | 2021/08291 | BIOENG | 300L ───────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2021/08291','BIOENG','2021/2022','First', 100,1),
('2021/08291','BIOENG','2021/2022','Second',100,2),
('2021/08291','BIOENG','2022/2023','First', 200,3),
('2021/08291','BIOENG','2022/2023','Second',200,4),
('2021/08291','BIOENG','2023/2024','First', 300,5);

-- ── FOLARIN ADUNOLA PATRICIA | 2019/06734 | ARCH | 500L ──────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2019/06734','ARCH','2019/2020','First', 100,1),
('2019/06734','ARCH','2019/2020','Second',100,2),
('2019/06734','ARCH','2020/2021','First', 200,3),
('2019/06734','ARCH','2020/2021','Second',200,4),
('2019/06734','ARCH','2021/2022','First', 300,5),
('2019/06734','ARCH','2021/2022','Second',300,6),
('2019/06734','ARCH','2022/2023','First', 400,7),
('2019/06734','ARCH','2022/2023','Second',400,8),
('2019/06734','ARCH','2023/2024','First', 500,9);

-- ── OLUMIDE SEGUN GABRIEL | 2021/08614 | ARCH | 300L ─────────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2021/08614','ARCH','2021/2022','First', 100,1),
('2021/08614','ARCH','2021/2022','Second',100,2),
('2021/08614','ARCH','2022/2023','First', 200,3),
('2021/08614','ARCH','2022/2023','Second',200,4),
('2021/08614','ARCH','2023/2024','First', 300,5);

-- ── NKECHI ADAORA JOSEPHINE | 2020/07892 | ESTMGT | 400L ─────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2020/07892','ESTMGT','2020/2021','First', 100,1),
('2020/07892','ESTMGT','2020/2021','Second',100,2),
('2020/07892','ESTMGT','2021/2022','First', 200,3),
('2020/07892','ESTMGT','2021/2022','Second',200,4),
('2020/07892','ESTMGT','2022/2023','First', 300,5),
('2020/07892','ESTMGT','2022/2023','Second',300,6),
('2020/07892','ESTMGT','2023/2024','First', 400,7);

-- ── YUSUF MARYAM HAUWA | 2022/09038 | ESTMGT | 200L ─────────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2022/09038','ESTMGT','2022/2023','First', 100,1),
('2022/09038','ESTMGT','2022/2023','Second',100,2),
('2022/09038','ESTMGT','2023/2024','First', 200,3);

-- ── TAIWO OLUWASEUN JOHN | 2021/08123 | QS | 300L ────────────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2021/08123','QS','2021/2022','First', 100,1),
('2021/08123','QS','2021/2022','Second',100,2),
('2021/08123','QS','2022/2023','First', 200,3),
('2021/08123','QS','2022/2023','Second',200,4),
('2021/08123','QS','2023/2024','First', 300,5);

-- ── ADELEKE TOLUWANI GRACE | 2020/07456 | BUSADM | 400L ──────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2020/07456','BUSADM','2020/2021','First', 100,1),
('2020/07456','BUSADM','2020/2021','Second',100,2),
('2020/07456','BUSADM','2021/2022','First', 200,3),
('2020/07456','BUSADM','2021/2022','Second',200,4),
('2020/07456','BUSADM','2022/2023','First', 300,5),
('2020/07456','BUSADM','2022/2023','Second',300,6),
('2020/07456','BUSADM','2023/2024','First', 400,7);

-- ── OKORO CHIZARAM PEACE | 2022/09341 | BUSADM | 200L ────────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2022/09341','BUSADM','2022/2023','First', 100,1),
('2022/09341','BUSADM','2022/2023','Second',100,2),
('2022/09341','BUSADM','2023/2024','First', 200,3);

-- ── ADEKUNLE OLUWAFEMI PAUL | 2020/07678 | ACCT | 400L ───────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2020/07678','ACCT','2020/2021','First', 100,1),
('2020/07678','ACCT','2020/2021','Second',100,2),
('2020/07678','ACCT','2021/2022','First', 200,3),
('2020/07678','ACCT','2021/2022','Second',200,4),
('2020/07678','ACCT','2022/2023','First', 300,5),
('2020/07678','ACCT','2022/2023','Second',300,6),
('2020/07678','ACCT','2023/2024','First', 400,7);

-- ── MUHAMMED AISHA LAWAL | 2021/08856 | ACCT | 300L ──────────────────────────
INSERT INTO mock_results (matric_no, department, session, semester, level, sn) VALUES
('2021/08856','ACCT','2021/2022','First', 100,1),
('2021/08856','ACCT','2021/2022','Second',100,2),
('2021/08856','ACCT','2022/2023','First', 200,3),
('2021/08856','ACCT','2022/2023','Second',200,4),
('2021/08856','ACCT','2023/2024','First', 300,5);


-- =============================================================================
-- VERIFICATION
-- =============================================================================
SELECT COUNT(*) AS total_students FROM mock_students;   -- should be 25
SELECT COUNT(*) AS total_result_rows FROM mock_results; -- should be 152
SELECT department_code, COUNT(*) AS students
FROM mock_students GROUP BY department_code ORDER BY department_code;
