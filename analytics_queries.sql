USE hms;

-- =====================================
-- 1. Doctor Workload
-- =====================================
SELECT 
    s.staff_id,
    s.first_name,
    COUNT(a.appt_id) AS total_appointments
FROM staff s
JOIN appointments a ON s.staff_id = a.doctor_id
GROUP BY s.staff_id
ORDER BY total_appointments DESC;


-- =====================================
-- 2. Department Demand
-- =====================================
SELECT 
    d.dept_name,
    COUNT(a.appt_id) AS total_visits
FROM departments d
JOIN appointments a ON d.dept_id = a.dept_id
GROUP BY d.dept_id
ORDER BY total_visits DESC;


-- =====================================
-- 3. Appointment Status Distribution
-- =====================================
SELECT 
    status,
    COUNT(*) AS total_count
FROM appointments
GROUP BY status;


-- =====================================
-- 4. No-Show Rate (%)
-- =====================================
SELECT 
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN status = 'NO_SHOW' THEN 1 ELSE 0 END) AS no_show_count,
    ROUND(100 * SUM(CASE WHEN status = 'NO_SHOW' THEN 1 ELSE 0 END) / COUNT(*), 2) AS no_show_percentage
FROM appointments;


-- =====================================
-- 5. Daily Appointment Trend
-- =====================================
SELECT 
    DATE(appt_datetime) AS date,
    COUNT(*) AS appointments
FROM appointments
GROUP BY DATE(appt_datetime)
ORDER BY date;


-- =====================================
-- 6. Admissions by Department
-- =====================================
SELECT 
    d.dept_name,
    COUNT(a.admission_id) AS total_admissions
FROM admissions a
JOIN departments d ON a.dept_id = d.dept_id
GROUP BY d.dept_id
ORDER BY total_admissions DESC;


-- =====================================
-- 7. Average Length of Stay (in days)
-- =====================================
SELECT 
    ROUND(AVG(DATEDIFF(discharge_datetime, admit_datetime)), 2) AS avg_stay_days
FROM admissions
WHERE discharge_datetime IS NOT NULL;


-- =====================================
-- 8. Active Admissions (currently admitted)
-- =====================================
SELECT 
    COUNT(*) AS active_patients
FROM admissions
WHERE discharge_datetime IS NULL;


-- =====================================
-- 9. Invoice Status Breakdown
-- =====================================
SELECT 
    status,
    COUNT(*) AS total_invoices
FROM invoices
GROUP BY status;


-- =====================================
-- 10. Top 5 Most Frequent Patients (by visits)
-- =====================================
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    COUNT(a.appt_id) AS total_visits
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
GROUP BY p.patient_id
ORDER BY total_visits DESC
LIMIT 5;


-- =====================================
-- 11. Doctor-wise Admission Count
-- =====================================
SELECT 
    s.first_name,
    COUNT(a.admission_id) AS total_admissions
FROM staff s
JOIN admissions a ON s.staff_id = a.attending_doctor
GROUP BY s.staff_id
ORDER BY total_admissions DESC;


-- =====================================
-- 12. Patient Gender Distribution
-- =====================================
SELECT 
    gender,
    COUNT(*) AS count
FROM patients
GROUP BY gender;

SELECT 
    ROUND(SUM(amount),2) AS total_revenue
FROM invoices
WHERE status = 'PAID';