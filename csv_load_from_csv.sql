-- ============================================
-- MariaDB CSV Import Queries
-- Dataset: Free Recruiting Pipeline Dataset v4
-- Source: https://databasesample.com/datasets/recruiting-pipeline
-- License: CC0-1.0 (Public Domain)
-- Path: C:\Users\kushw\Desktop\Daily_Project\Recruitment_Analytics\data\raw\
-- ============================================

-- ============================================
-- CSV LOAD QUERY: candidates.csv
-- ============================================
LOAD DATA INFILE 'C:/Users/kushw/Desktop/Daily_Project/Recruitment_Analytics/data/raw/candidates.csv'
INTO TABLE candidates
IGNORE 1 LINES
(@id, @full_name, @email, @applied_at)
SET
    id = TRIM(@id),
    full_name = TRIM(@full_name),
    email = TRIM(@email),
    applied_at = STR_TO_DATE(TRIM(@applied_at), '%Y-%m-%d %H:%i:%s');

-- Validate
SELECT 'candidates' AS table_name, COUNT(*) AS rows_loaded FROM candidates;


-- ============================================
-- CSV LOAD QUERY: job_openings.csv
-- ============================================
LOAD DATA INFILE 'C:/Users/kushw/Desktop/Daily_Project/Recruitment_Analytics/data/raw/job_openings.csv'
INTO TABLE job_openings
IGNORE 1 LINES
(@id, @title, @department, @created_at, @status)
SET
    id = TRIM(@id),
    title = TRIM(@title),
    department = TRIM(@department),
    created_at = STR_TO_DATE(TRIM(@created_at), '%Y-%m-%d %H:%i:%s'),
    status = TRIM(@status);

-- Validate
SELECT 'job_openings' AS table_name, COUNT(*) AS rows_loaded FROM job_openings;


-- ============================================
-- CSV LOAD QUERY: applications.csv
-- ============================================
LOAD DATA INFILE 'C:/Users/kushw/Desktop/Daily_Project/Recruitment_Analytics/data/raw/applications.csv'
INTO TABLE applications
IGNORE 1 LINES
(@id, @candidate_id, @job_opening_id, @status, @applied_at, @application_date, @interview_count, @candidate_rating)
SET
    id = TRIM(@id),
    candidate_id = TRIM(@candidate_id),
    job_opening_id = TRIM(@job_opening_id),
    status = TRIM(@status),
    applied_at = STR_TO_DATE(TRIM(@applied_at), '%Y-%m-%d %H:%i:%s'),
    application_date = STR_TO_DATE(TRIM(@application_date), '%Y-%m-%d %H:%i:%s'),
    interview_count = TRIM(@interview_count),
    candidate_rating = NULLIF(TRIM(@candidate_rating), '');

-- Validate
SELECT 'applications' AS table_name, COUNT(*) AS rows_loaded FROM applications;


-- ============================================
-- CSV LOAD QUERY: interviews.csv
-- ============================================
LOAD DATA INFILE 'C:/Users/kushw/Desktop/Daily_Project/Recruitment_Analytics/data/raw/interviews.csv'
INTO TABLE interviews
IGNORE 1 LINES
(@id, @application_id, @interviewer, @score, @interviewed_at)
SET
    id = TRIM(@id),
    application_id = TRIM(@application_id),
    interviewer = TRIM(@interviewer),
    score = NULLIF(TRIM(@score), ''),
    interviewed_at = STR_TO_DATE(TRIM(@interviewed_at), '%Y-%m-%d %H:%i:%s');

-- Validate
SELECT 'interviews' AS table_name, COUNT(*) AS rows_loaded FROM interviews;


-- ============================================
-- CSV LOAD QUERY: offers.csv
-- ============================================
LOAD DATA INFILE 'C:/Users/kushw/Desktop/Daily_Project/Recruitment_Analytics/data/raw/offers.csv'
INTO TABLE offers
IGNORE 1 LINES
(@id, @application_id, @offer_status, @offered_at, @salary)
SET
    id = TRIM(@id),
    application_id = TRIM(@application_id),
    offer_status = TRIM(@offer_status),
    offered_at = NULLIF(STR_TO_DATE(TRIM(@offered_at), '%Y-%m-%d %H:%i:%s'), '0000-00-00 00:00:00'),
    salary = NULLIF(TRIM(@salary), '');

-- Validate
SELECT 'offers' AS table_name, COUNT(*) AS rows_loaded FROM offers;


-- ============================================
-- CROSS-TABLE VALIDATION
-- ============================================

-- Referential integrity: applications -> candidates
SELECT 'applications -> candidates orphans' AS check_name,
       SUM(CASE WHEN candidate_id NOT IN (SELECT id FROM candidates) THEN 1 ELSE 0 END) AS orphan_count
FROM applications;

-- Referential integrity: applications -> job_openings
SELECT 'applications -> job_openings orphans' AS check_name,
       SUM(CASE WHEN job_opening_id NOT IN (SELECT id FROM job_openings) THEN 1 ELSE 0 END) AS orphan_count
FROM applications;

-- Referential integrity: interviews -> applications
SELECT 'interviews -> applications orphans' AS check_name,
       SUM(CASE WHEN application_id NOT IN (SELECT id FROM applications) THEN 1 ELSE 0 END) AS orphan_count
FROM interviews;

-- Referential integrity: offers -> applications
SELECT 'offers -> applications orphans' AS check_name,
       SUM(CASE WHEN application_id NOT IN (SELECT id FROM applications) THEN 1 ELSE 0 END) AS orphan_count
FROM offers;

-- Cross-table summary
SELECT
    (SELECT COUNT(*) FROM candidates) AS candidates_total,
    (SELECT COUNT(*) FROM job_openings) AS job_openings_total,
    (SELECT COUNT(*) FROM applications) AS applications_total,
    (SELECT COUNT(*) FROM interviews) AS interviews_total,
    (SELECT COUNT(*) FROM offers) AS offers_total;
