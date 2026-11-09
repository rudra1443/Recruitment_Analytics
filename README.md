# 📊 Recruitment Analytics

**Ravvion Compass AI — HR Analytics Project 20**

**Project Path:** `C:\Users\kushw\Desktop\Daily_Project\Recruitment_Analytics`  
**Primary Tools:** Python + MariaDB + Power BI  
**Dataset:** Free Recruiting Pipeline Dataset v4  
**License:** CC0-1.0 (Public Domain)

---

## 1. Project Overview

This project analyzes a synthetic recruiting pipeline dataset to build professional dashboards and SQL analyses. The dataset contains 5 linked tables simulating a real-world recruitment process — from candidate application to offer decision.

**Scope:**
- Audit raw datasets and document schema
- Build data quality reports
- Create SQL analysis queries
- Develop Power BI dashboard
- Document limitations and recommendations

---

## 2. Business Context

A staffing firm needs visibility into:
- Where the recruitment funnel leaks (application → interview → offer → joined)
- Recruiter productivity and conversion rates
- Seasonal hiring patterns
- Source effectiveness (limited — no source field)

---

## 3. Project Structure

```
Recruitment_Analytics/
├── data/
│   ├── raw/                 # Original data (5 CSV files)
│   │   ├── candidates.csv
│   │   ├── job_openings.csv
│   │   ├── applications.csv
│   │   ├── interviews.csv
│   │   ├── offers.csv
│   │   └── SHA-256_SUMMARY.txt
│   └── cleaned/             # Processed data
├── data_dictionary.md       # Schema & column documentation
├── data_quality_report.md   # Audit findings
├── notebooks/               # Jupyter notebooks
├── sql/                     # SQL scripts (MariaDB)
├── powerbi/                 # Power BI dashboard
├── report/                  # Screenshots & outputs
└── scripts/                 # Helper scripts
```

---

## 4. Dataset

| Attribute | Value |
|---|---|
| **Source** | https://databasesample.com/datasets/recruiting-pipeline |
| **License** | CC0-1.0 (Public Domain) |
| **Version** | v4 |
| **Date Published** | 2026-09-07 |
| **Date Modified** | 2026-09-11 |

### Tables

| Table | Rows | PK | FK |
|---|---|---|---|
| `candidates` | 200 | `id` | — |
| `job_openings` | 100 | `id` | — |
| `applications` | 506 | `id` | candidate_id, job_opening_id |
| `interviews` | 822 | `id` | application_id |
| `offers` | 155 | `id` | application_id |

### Column Count

| Table | Columns |
|---|---|
| `candidates` | 4 |
| `job_openings` | 5 |
| `applications` | 8 |
| `interviews` | 5 |
| `offers` | 5 |
| **Total** | **27** |

### Row Count

| Table | Expected | Actual | Match |
|---|---|---|---|
| `candidates` | 200 | 200 | ✅ |
| `job_openings` | 100 | 100 | ✅ |
| `applications` | 506 | 506 | ✅ |
| `interviews` | 822 | 822 | ✅ |
| `offers` | 155 | 155 | ✅ |

**Total:** 1,783 rows, 27 columns, 5 linked tables

---

## 5. Verified Data Quality

| Table | Completeness | FK Integrity | Overall |
|---|---|---|---|
| `candidates` | ✅ 100% | ✅ 0 orphans | ✅ Pass |
| `job_openings` | ✅ 98% (title 19 nulls) | ✅ 0 orphans | ✅ Pass |
| `applications` | ✅ 90% (rating 49/506 nulls) | ✅ 0 orphans | ✅ Pass |
| `interviews` | ✅ 91% (interviewer 8.4% nulls) | ✅ 0 orphans | ✅ Pass |
| `offers` | ✅ 89% (offered_at 40/155 nulls) | ✅ 0 orphans | ✅ Pass |

**Overall Quality Score:** 94.4%  
**Verdict:** ✅ Ready for analysis

---

## 6. Key Findings (From Audit)

| Finding | Detail |
|---|---|
| No recruitment source field | Cannot do source-to-hire analysis |
| No joining date | Cannot compute actual time-to-hire |
| applied_at ≠ application_date | All 506 apps have >1 min difference |
| Nulls: 84 total across tables | 2.5% of all cells — realistic for transactional data |
| No duplicate rows or PK violations | ✅ Clean data |

---

## 7. Limitations (Documented)

| Limitation | Mitigation |
|---|---|
| No source field | Document limitation; use department as proxy |
| No joining date | Use offer date + application date for time-to-offer |
| Small synthetic sample | Validate with larger datasets later |
| Synthetic data | Not for production; for portfolio/learning |

---

## 8. Next Steps (Phase 3+)

| Phase | Deliverable | Status |
|---|---|---|
| Phase 3: SQL Analysis | MariaDB queries for funnel metrics | ⏳ Pending |
| Phase 4: Dashboard | Power BI / Streamlit dashboard | ⏳ Pending |
| Phase 5: Documentation | README updates, LinkedIn post | ⏳ Pending |

---

## 9. References

- Publisher: Database Sample (https://databasesample.com)
- Dataset Page: https://databasesample.com/datasets/recruiting-pipeline
- License: https://creativecommons.org/publicdomain/zero/1.0/

---

## 10. Contact

**Owner:** Rudra Thakur (Rudra's Sir)  
**Assistant:** ZYRON — Ravvion Compass AI Assistant  
**Field:** R&D Engineer / Data Analyst

---

**Project Status:** ✅ Phase 1 (Dataset Verification + Download + Audit) Complete  
**Phase 2 (SQL Analysis) Start:** Await approval
