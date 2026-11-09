-- ============================================
-- MariaDB Import Scripts for Recruitment Analytics
-- Dataset: Free Recruiting Pipeline Dataset v4
-- Source: https://databasesample.com/datasets/recruiting-pipeline
-- License: CC0-1.0 (Public Domain)
-- Processed: 2026-10-28
-- ============================================

-- 1. CREATE DATABASE
DROP DATABASE IF EXISTS recruitment_analytics;
CREATE DATABASE recruitment_analytics
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE recruitment_analytics;

-- 2. CREATE TABLES
-- Table: candidates
CREATE TABLE candidates (
    id INT PRIMARY KEY,
    full_name VARCHAR(120),
    email VARCHAR(120),
    applied_at DATETIME
);

-- Table: job_openings
CREATE TABLE job_openings (
    id INT PRIMARY KEY,
    title VARCHAR(120),
    department VARCHAR(50),
    created_at DATETIME,
    status VARCHAR(10)
);

-- Table: applications
CREATE TABLE applications (
    id INT PRIMARY KEY,
    candidate_id INT,
    job_opening_id INT,
    status VARCHAR(12),
    applied_at DATETIME,
    application_date DATETIME,
    interview_count INT,
    candidate_rating INT,
    CONSTRAINT fk_applications_candidate FOREIGN KEY (candidate_id) REFERENCES candidates(id),
    CONSTRAINT fk_applications_job_opening FOREIGN KEY (job_opening_id) REFERENCES job_openings(id)
);

-- Table: interviews
CREATE TABLE interviews (
    id INT PRIMARY KEY,
    application_id INT,
    interviewer VARCHAR(120),
    score INT,
    interviewed_at DATETIME,
    CONSTRAINT fk_interviews_application FOREIGN KEY (application_id) REFERENCES applications(id)
);

-- Table: offers
CREATE TABLE offers (
    id INT PRIMARY KEY,
    application_id INT,
    offer_status VARCHAR(8),
    offered_at DATETIME,
    salary DECIMAL(12,2),
    CONSTRAINT fk_offers_application FOREIGN KEY (application_id) REFERENCES applications(id)
);

-- 3. INDEXES FOR JOINS
CREATE INDEX idx_applications_candidate ON applications(candidate_id);
CREATE INDEX idx_applications_job ON applications(job_opening_id);
CREATE INDEX idx_interviews_application ON interviews(application_id);
CREATE INDEX idx_offers_application ON offers(application_id);

-- 4. VALIDATION QUERIES
-- Validate table row counts
SELECT 'candidates' AS table_name, COUNT(*) AS row_count FROM candidates
UNION ALL
SELECT 'job_openings', COUNT(*) FROM job_openings
UNION ALL
SELECT 'applications', COUNT(*) FROM applications
UNION ALL
SELECT 'interviews', COUNT(*) FROM interviews
UNION ALL
SELECT 'offers', COUNT(*) FROM offers;

-- Validate referential integrity
SELECT 'applications.candidate_id -> candidates.id' AS check_name,
       SUM(CASE WHEN candidate_id NOT IN (SELECT id FROM candidates) THEN 1 ELSE 0 END) AS orphan_count
FROM applications;

SELECT 'applications.job_opening_id -> job_openings.id' AS check_name,
       SUM(CASE WHEN job_opening_id NOT IN (SELECT id FROM job_openings) THEN 1 ELSE 0 END) AS orphan_count
FROM applications;

SELECT 'interviews.application_id -> applications.id' AS check_name,
       SUM(CASE WHEN application_id NOT IN (SELECT id FROM applications) THEN 1 ELSE 0 END) AS orphan_count
FROM interviews;

SELECT 'offers.application_id -> applications.id' AS check_name,
       SUM(CASE WHEN application_id NOT IN (SELECT id FROM applications) THEN 1 ELSE 0 END) AS orphan_count
FROM offers;

-- Validate table constraints
SELECT 'applications.id duplicates' AS check_name,
       COUNT(*) - COUNT(DISTINCT id) AS duplicates
FROM applications;

SELECT 'interviews.id duplicates' AS check_name,
       COUNT(*) - COUNT(DISTINCT id) AS duplicates
FROM interviews;

SELECT 'offers.id duplicates' AS check_name,
       COUNT(*) - COUNT(DISTINCT id) AS duplicates
FROM offers;

-- 5. VALIDATION: COLUMN COUNTS
SELECT 'candidates columns' AS check_name, COUNT(*) AS col_count FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'candidates'
UNION ALL
SELECT 'job_openings columns', COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_openings'
UNION ALL
SELECT 'applications columns', COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'applications'
UNION ALL
SELECT 'interviews columns', COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'interviews'
UNION ALL
SELECT 'offers columns', COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'offers';
