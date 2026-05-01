USE hms;

SET FOREIGN_KEY_CHECKS = 0;

-- =========================
-- 1. STAFF (unique emails)
-- =========================
INSERT INTO staff (first_name, last_name, email, role, dept_id)
SELECT 
    CONCAT('Doctor', n),
    CONCAT('L', n),
    CONCAT('doctor', n, '_', UUID(), '@hosp.com'),
    'DOCTOR',
    FLOOR(1 + RAND()*3)
FROM (
    SELECT @row:=@row+1 AS n 
    FROM information_schema.tables, (SELECT @row:=0) t
    LIMIT 20
) x;


-- =========================
-- 2. PATIENTS (50 rows)
-- =========================
INSERT INTO patients (first_name, last_name, dob, gender, phone, email, address)
SELECT 
    CONCAT('Patient', n),
    CONCAT('Last', n),
    DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*20000) DAY),
    ELT(FLOOR(1 + RAND()*3), 'M','F','O'),
    CONCAT('98', LPAD(FLOOR(RAND()*100000000),8,'0')),
    CONCAT('patient', n, '_', UUID(), '@mail.com'),
    ELT(FLOOR(1 + RAND()*3), 'Delhi','Mumbai','Bangalore')
FROM (
    SELECT @row2:=@row2+1 AS n 
    FROM information_schema.tables, (SELECT @row2:=0) t
    LIMIT 50
) x;


-- =========================
-- 3. APPOINTMENTS (200 rows)
-- FK-safe selection
-- =========================
INSERT INTO appointments (patient_id, doctor_id, dept_id, appt_datetime, status, reason)
SELECT
    (SELECT patient_id FROM patients ORDER BY RAND() LIMIT 1),
    (SELECT staff_id FROM staff ORDER BY RAND() LIMIT 1),
    (SELECT dept_id FROM departments ORDER BY RAND() LIMIT 1),
    DATE_ADD(NOW(), INTERVAL FLOOR(RAND()*30) DAY),
    ELT(FLOOR(1 + RAND()*4), 'COMPLETED','NO_SHOW','SCHEDULED','CANCELLED'),
    ELT(FLOOR(1 + RAND()*3), 'Fever','Checkup','Pain')
FROM information_schema.tables
LIMIT 200;


-- =========================
-- 4. ADMISSIONS (100 rows)
-- =========================
INSERT INTO admissions (patient_id, admit_datetime, discharge_datetime, attending_doctor, dept_id, diagnosis)
SELECT
    (SELECT patient_id FROM patients ORDER BY RAND() LIMIT 1),
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND()*20) DAY),
    DATE_ADD(NOW(), INTERVAL FLOOR(RAND()*10) DAY),
    (SELECT staff_id FROM staff ORDER BY RAND() LIMIT 1),
    (SELECT dept_id FROM departments ORDER BY RAND() LIMIT 1),
    ELT(FLOOR(1 + RAND()*3), 'Infection','Surgery','Observation')
FROM information_schema.tables
LIMIT 100;


-- =========================
-- 5. INVOICES (100 rows)
-- =========================
INSERT INTO invoices (patient_id, admission_id, invoice_datetime, status)
SELECT
    (SELECT patient_id FROM patients ORDER BY RAND() LIMIT 1),
    (SELECT admission_id FROM admissions ORDER BY RAND() LIMIT 1),
    NOW(),
    ELT(FLOOR(1 + RAND()*3), 'PAID','OPEN','PENDING')
FROM information_schema.tables
LIMIT 100;


SET FOREIGN_KEY_CHECKS = 1;

UPDATE appointments
SET patient_id = 1
WHERE appt_id = 4;

ALTER TABLE invoices ADD amount DECIMAL(10,2);

UPDATE invoices
SET amount = ROUND(500 + RAND()*4500, 2)
WHERE amount IS NULL
AND invoice_id BETWEEN 1 AND 103;