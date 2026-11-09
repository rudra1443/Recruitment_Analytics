# 📊 Recruitment Analytics — Data Dictionary

**Project:** Recruitment Analytics  
**Dataset:** Free Recruiting Pipeline Dataset v4  
**Source:** https://databasesample.com/datasets/recruiting-pipeline  
**License:** CC0-1.0 (Public Domain)  
**Version:** v4  
**Date Published:** 2026-09-07  
**Date Modified:** 2026-09-11  
**File:** data/raw/*.csv

### 📊 Dashboard Assets

| Asset | Path | Description |
|-------|------|-------------|
| Dashboard Background | `data/raw/dashboard_background.png` | Power BI background template (1920×1080) |

**Design:** Professional dark navy/charcoal theme with subtle blue and purple gradients. KPI cards and chart sections have clean spacing with subtle outlines. No fake data, no text labels, no logos.

---

## Schema Overview

| Table | Rows | Primary Key | Foreign Keys |
|---|---|---|---|
| `candidates` | 200 | `id` | — |
| `job_openings` | 100 | `id` | — |
| `applications` | 506 | `id` | `candidate_id` → candidates.id, `job_opening_id` → job_openings.id |
| `interviews` | 822 | `id` | `application_id` → applications.id |
| `offers` | 155 | `id` | `application_id` → applications.id |

**Relationship Diagram:**
```
candidates 1──N applications 1──N interviews 1──N offers
job_openings 1──N applications
```

---

## Table: `candidates`

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | integer | PRIMARY KEY | Unique identifier |
| `full_name` | varchar(120) | — | Full name of candidate |
| `email` | varchar(120) | — | Email address |
| `applied_at` | timestamp | NOT NULL | Date and time when candidate applied |

**Stats:** 200 rows, 0 nulls, dates range 2022-01-04 to 2023-12-25

---

## Table: `job_openings`

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | integer | PRIMARY KEY | Unique identifier |
| `title` | varchar(120) | nullable (19/100) | Job title |
| `department` | varchar(11) | NOT NULL | Department (Engineering, Marketing, Sales, HR) |
| `created_at` | timestamp | NOT NULL | Date/time when job opening was created |
| `status` | varchar(6) | NOT NULL | Current status (Open, Closed) |

**Stats:** 100 rows, 0 nulls (except title 19/100), dates 2022-01-04 to 2023-12-25

---

## Table: `applications`

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | integer | PRIMARY KEY | Unique identifier |
| `candidate_id` | integer | FOREIGN KEY → candidates.id | Reference to candidate |
| `job_opening_id` | integer | FOREIGN KEY → job_openings.id | Reference to job opening |
| `status` | varchar(12) | NOT NULL | Application status (Applied, Interviewing, Offer, Rejected) |
| `applied_at` | timestamp | NOT NULL | Date/time of application |
| `application_date` | timestamp | NOT NULL | Date when application was submitted |
| `interview_count` | integer | NOT NULL | Number of interviews (0-3) |
| `candidate_rating` | integer | nullable (49/506) | Rating 1-5 by interviewer |

**Stats:** 506 rows, 0 nulls (except candidate_rating 49/506), dates 2022-01-01 to 2023-12-27

---

## Table: `interviews`

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | integer | PRIMARY KEY | Unique identifier |
| `application_id` | integer | FOREIGN KEY → applications.id | Reference to application |
| `interviewer` | varchar(120) | nullable (69/822) | Name of interviewer |
| `score` | integer | nullable (75/822) | Score 1-10 |
| `interviewed_at` | timestamp | NOT NULL | Date/time of interview |

**Stats:** 822 rows, 0 nulls (except interviewer 69/822, score 75/822), dates 2022-01-02 to 2023-12-31

---

## Table: `offers`

| Column | Type | Constraints | Description |
|---|---|---|---|
| `id` | integer | PRIMARY KEY | Unique identifier |
| `application_id` | integer | FOREIGN KEY → applications.id | Reference to application |
| `offer_status` | varchar(8) | NOT NULL | Status (Accepted, Declined) |
| `offered_at` | timestamp | nullable (40/155) | Date when offer was made |
| `salary` | numeric(14,2) | nullable (16/155) | Salary offered |

**Stats:** 155 rows, 40 nulls (offered_at), 16 nulls (salary), dates 2022-01-09 to 2023-12-29

---

## License

**CC0-1.0** (Creative Commons Zero - Public Domain)  
https://creativecommons.org/publicdomain/zero/1.0/  
This dataset is free for any use including commercial, educational, and portfolio purposes. No attribution required.

---

## Limitations

| Limitation | Detail |
|---|---|
| **No source field** | Recruitment channel/source not captured |
| **No joining date** | No hire/join date for candidates |
| **No salary stage** | Salary only exists in offers table (not final salary) |
| **Small sample** | 200 candidates, 506 applications — not production scale |
| **Synthetic data** | Data is generated for testing and analytics practice |

---

## Use Cases

- Test fixtures for SQL/Python/NLP training
- BI dashboard development
- Pipeline analysis and reporting
- Interview process evaluation

---

## References

- Publisher: Database Sample (https://databasesample.com)
- Version: v4
- Manifest: https://database-sample-website.s3.eu-north-1.amazonaws.com/datasets/recruiting-pipeline/v4/manifest.json
- Alternative datasets on page: job-board-applications-and-interviews-dataset, hr-sample-database, org-chart