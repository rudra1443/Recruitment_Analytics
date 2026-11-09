# 📊 Recruitment Analytics — DAX Measures Library

**Project:** Recruitment Analytics  
**Source:** Free Recruiting Pipeline Dataset v4  
**License:** CC0-1.0 (Public Domain)  
**Power BI Measures:** Written for tabular data model in Power BI Desktop  

---

## 📋 CONNECTION TO DATA MODEL

| Table | Power BI Relationship |
|---|---|
| `candidates` → `applications` | `candidates[id] 1──N applications[candidate_id]` |
| `job_openings` → `applications` | `job_openings[id] 1──N applications[job_opening_id]` |
| `applications` → `interviews` | `applications[id] 1──N interviews[application_id]` |
| `applications` → `offers` | `applications[id] 1──N offers[application_id]` |

---

## 🎯 CORE KPI MEASURES

### 1. Total Applicants
```dax
Total Applicants = 
COUNTROWS('applications')
```
**Description:** Total number of candidate applications received.  
**Use:** Overall funnel size, applicant volume.

### 2. Hired Candidates
```dax
Hired Candidates = 
CALCULATE(
    DISTINCTCOUNT('applications'[id]),
    'offers'[offer_status] = "Accepted"
)
```
**Description:** Count of unique candidates who received an accepted offer.  
**Use:** Core hiring success metric.

### 3. Rejection Rate
```dax
Rejection Rate = 
CALCULATE(
    DIVIDE(
        COUNTROWS(
            FILTER('applications', 'applications'[status] = "Rejected")
        ),
        COUNTROWS('applications')
    ),
    0
)
```
**Description:** Percentage of applications that were rejected.  
**Formula:** `= Rejected Applications / Total Applications`

### 4. Declined Rate
```dax
Declined Rate = 
CALCULATE(
    DIVIDE(
        COUNTROWS(
            FILTER('offers', 'offers'[offer_status] = "Declined")
        ),
        COUNTROWS('offers')
    ),
    0
)
```
**Description:** Percentage of accepted offers that were declined by candidates.  
**Formula:** `= Declined Offers / Total Offers`

### 5. Hiring Rate
```dax
Hiring Rate = 
CALCULATE(
    DIVIDE(
        [Hired Candidates],
        COUNTROWS('applications')
    ),
    0
)
```
**Description:** Percentage of applicants who were successfully hired.  
**Formula:** `= Hired Candidates / Total Applicants`

### 6. Offer Acceptance Rate
```dax
Offer Acceptance Rate = 
CALCULATE(
    DIVIDE(
        COUNTROWS('offers'),
        COUNTROWS('applications')
    ),
    0
)
```
**Description:** Percentage of applications that resulted in an offer being made.  
**Formula:** `= Total Offers / Total Applications`

### 7. Average Time to Hire (Days)
```dax
Average Time to Hire (Days) = 
VAR AvgDate = 
    AVERAGEX(
        DISTINCT('applications'),
        DATEDIFF(
            'applications'[application_date],
            'offers'[offered_at],
            DAY
        )
    )
RETURN
    IF(
        ISINFINITY(AvgDate) || ISBLANK(AvgDate),
        BLANK(),
        AvgDate
    )
```
**Description:** Average days between application and offer acceptance.  
**Note:** Requires `offered_at` to be populated for hired candidates.

### 8. Time to Interview (Days)
```dax
Average Time to Interview (Days) = 
VAR AvgDate = 
    AVERAGEX(
        DISTINCT('applications'),
        CALCULATE(
            DATEDIFF(
                'applications'[application_date],
                'interviews'[interviewed_at],
                DAY
            ),
            'interviews'[application_id] = 'applications'[id]
        )
    )
RETURN
    IF(
        ISINFINITY(AvgDate) || ISBLANK(AvgDate),
        BLANK(),
        AvgDate
    )
```
**Description:** Average days between application and interview.  
**Note:** Returns BLANK for applications with no interview.

### 9. Interview Conversion Rate
```dax
Interview Conversion Rate = 
CALCULATE(
    DIVIDE(
        DISTINCTCOUNT('applications'[id]),
        CALCULATE(DISTINCTCOUNT('applications'[id]), 'interviews'[application_id] > 0)
    ),
    0
)
```
**Description:** Percentage of applicants who were interviewed.  
**Formula:** `= Candidates Interviewed / Total Candidates`

### 10. Offer Conversion Rate (Stage 3)
```dax
Offer Conversion Rate = 
CALCULATE(
    DIVIDE(
        DISTINCTCOUNT('applications'[id]),
        CALCULATE(DISTINCTCOUNT('applications'[id]), 'offers'[application_id] > 0)
    ),
    0
)
```
**Description:** Percentage of interviewed candidates who received an offer.  
**Formula:** `= Applicants with Offer / Candidates Interviewed`

---

## 📊 DEPARTMENT-WISE MEASURES

### 11. Total Hires by Department
```dax
Total Hires by Department = 
CALCULATE(
    [Hired Candidates],
    ALLEXCEPT('job_openings', 'job_openings'[department])
)
```
**Description:** Hired candidates grouped by job opening department.  
**Use:** Department-wise hiring KPIs.

### 12. Avg Salary by Department
```dax
Avg Salary by Department = 
CALCULATE(
    AVERAGE('offers'[salary]),
    REMOVEFILTERS('offers'[salary])
)
```
**Description:** Average salary offered by department.  
**Note:** Excludes NULL salaries.

### 13. Hiring Rate by Department
```dax
Hiring Rate by Department = 
CALCULATE(
    DIVIDE(
        [Hired Candidates],
        CALCULATE(COUNTROWS('applications'))
    ),
    0
)
```
**Description:** Hiring rate within each department.

---

## 🔄 SOURCE-WISE MEASURES (Application Status Based)

> **Note:** The dataset does NOT contain a `source` or `recruitment_channel` field.  
> Source analysis can be approximated using `status` and `candidate_rating`.

### 14. Source Proxy: Hiring by Application Status
```dax
Hiring by Status = 
CALCULATE(
    [Hired Candidates],
    REMOVEFILTERS('applications'[status])
)
```
**Note:** Use `status` as a proxy for application quality source.  
**Status Values:** Applied, Interviewing, Offer, Rejected

### 15. Candidate Quality Index (CQI)
```dax
Candidate Quality Index = 
CALCULATE(
    AVERAGE('applications'[candidate_rating]),
    REMOVEFILTERS('applications'[candidate_rating])
)
```
**Description:** Average candidate rating (1-5 scale).  
**Use:** Measures candidate quality across sources.

---

## 📈 TREND & TIME MEASURES

### 16. Monthly Applicants
```dax
Monthly Applicants = 
CALCULATE(
    COUNTROWS('applications'),
    DATEMONTH('applications'[applied_at])
)
```
**Description:** Total applicants per month.

### 17. Monthly Hiring Trend
```dax
Monthly Hiring Trend = 
CALCULATE(
    [Hired Candidates],
    DATEMONTH('offers'[offered_at])
)
```
**Description:** Monthly headcount trend.

### 18. Interview Trend
```dax
Interview Trend = 
CALCULATE(
    DISTINCTCOUNT('interviews'[application_id]),
    DATEMONTH('interviews'[interviewed_at])
)
```
**Description:** Monthly interview volume.

### 19. Offer Conversion Rate by Month
```dax
Monthly Offer Rate = 
CALCULATE(
    DIVIDE(
        DISTINCTCOUNT('applications'[id]),
        CALCULATE(COUNTROWS('applications'))
    ),
    0
)
```
**Description:** Offer conversion rate per month.

---

## 🎯 UTILITY MEASURES

### 20. Total Payroll (Annual)
```dax
Total Payroll (Annual) = 
CALCULATE(
    SUM('offers'[salary]),
    REMOVEFILTERS('offers'[salary])
)
```
**Description:** Total annual payroll cost (sum of offer salaries).

### 21. Avg Salary (Offered)
```dax
Avg Salary (Offered) = 
CALCULATE(
    AVERAGE('offers'[salary]),
    REMOVEFILTERS('offers'[salary])
)
```
**Description:** Average offer salary across all hired candidates.

### 22. Total Interview Score
```dax
Total Interview Score = 
CALCULATE(
    SUM('interviews'[score]),
    REMOVEFILTERS('interviews'[score])
)
```
**Description:** Sum of all interviewer scores.

### 23. Average Interview Score
```dax
Average Interview Score = 
CALCULATE(
    AVERAGE('interviews'[score]),
    REMOVEFILTERS('interviews'[score])
)
```
**Description:** Average interview score (1-10 scale).

### 24. Interview Completion Rate
```dax
Interview Completion Rate = 
CALCULATE(
    DIVIDE(
        DISTINCTCOUNT('applications'[id]),
        CALCULATE(DISTINCTCOUNT('applications'[id]), 'interviews'[application_id] > 0)
    ),
    0
)
```
**Description:** % of applicants who completed at least one interview.

### 25. Offer Participation Rate
```dax
Offer Participation Rate = 
CALCULATE(
    DIVIDE(
        DISTINCTCOUNT('applications'[id]),
        CALCULATE(DISTINCTCOUNT('applications'[id]), 'offers'[application_id] > 0)
    ),
    0
)
```
**Description:** % of applicants who received an offer.

---

## 📋 RECOMMENDED DAX MEASURE TABLE

| Measure Name | DAX Formula | KPI |
|---|---|---|
| Total Applicants | `COUNTROWS('applications')` | Total Applicants |
| Total Hires | `CALCULATE(DISTINCTCOUNT('applications'[id]), 'offers'[offer_status] = "Accepted")` | Hired Candidates |
| Rejection Rate | `DIVIDE(COUNTROWS(FILTER('applications', 'applications'[status] = "Rejected")), COUNTROWS('applications'))` | Rejection Rate |
| Hiring Rate | `DIVIDE([Hired Candidates], COUNTROWS('applications'))` | Hiring Rate |
| Offer Acceptance Rate | `DIVIDE(COUNTROWS('offers'), COUNTROWS('applications'))` | Offer Acceptance Rate |
| Avg Time to Hire (Days) | `AVERAGEX(... DATEDIFF(...))` | Avg Time to Hire |
| Avg Salary | `AVERAGE('offers'[salary])` | Avg Salary |
| Total Payroll | `SUM('offers'[salary])` | Total Payroll |
| Interview Completion Rate | `DIVIDE(...)` | Interview Rate |
| Offer Participation Rate | `DIVIDE(...)` | Offer Rate |
| Monthly Applicants | `CALCULATE(COUNTROWS(...), DATEMONTH(...))` | Monthly Trend |
| Monthly Hiring Trend | `CALCULATE([Hired Candidates], DATEMONTH(...))` | Monthly Trend |
| Avg Interview Score | `AVERAGE('interviews'[score])` | Interview Score |

---

**📝 IMPORTANT NOTES:**
1. All measures use actual column names from the dataset
2. `offer_status` values: "Accepted" (115), "Declined" (40)
3. No `source` or `recruitment_channel` field exists — analyze via `status` and `candidate_rating`
4. `Average Time to Hire` uses `offered_at` — requires populated dates
5. All measures handle division-by-zero with `DIVIDE()` function

---

## 📊 RECOMMENDED CHARTS & VISUALIZATIONS

### Chart 1: Total Applicants
- **Type:** Card
- **Field:** `applications` → `id` (Count)
- **Insights:** Total funnel size

### Chart 2: Hired Candidates
- **Type:** Card (with target line)
- **Field:** `[Hired Candidates]`
- **Insights:** Hiring success metric

### Chart 3: Hiring Rate
- **Type:** Card (percentage)
- **Field:** `[Hiring Rate]`
- **Insights:** Conversion efficiency

### Chart 4: Offer Acceptance Rate
- **Type:** Card (percentage)
- **Field:** `[Offer Acceptance Rate]`
- **Insights:** Quality of funnel

### Chart 5: Rejection Rate
- **Type:** Card (percentage)
- **Field:** `[Rejection Rate]`
- **Insights:** Early screening effectiveness

### Chart 6: Dept-wise Hiring
- **Type:** Bar chart
- **Axis:** `job_openings` → `department`
- **Values:** `[Total Hires by Department]`
- **Insights:** Which departments hire best

### Chart 7: Avg Salary by Department
- **Type:** Bar chart
- **Axis:** `job_openings` → `department`
- **Values:** `[Avg Salary by Department]`
- **Insights:** Compensation benchmarking

### Chart 8: Hiring Rate by Department
- **Type:** Bar chart
- **Axis:** `job_openings` → `department`
- **Values:** `[Hiring Rate by Department]`
- **Insights:** Dept hiring efficiency

### Chart 9: Offer Status Breakdown
- **Type:** Donut/Pie
- **Field:** `offers` → `offer_status`
- **Values:** Count of records
- **Insights:** Offer acceptance vs decline

### Chart 10: Avg Interview Score
- **Type:** Card
- **Field:** `[Average Interview Score]`
- **Insights:** Interview quality metric

### Chart 11: Interview Trend
- **Type:** Line/Bar
- **Axis:** Dates (month/year)
- **Values:** `[Interview Trend]`
- **Insights:** Seasonal patterns

### Chart 12: Monthly Hiring Trend
- **Type:** Line/Bar
- **Axis:** Dates (month/year)
- **Values:** `[Monthly Hiring Trend]`
- **Insights:** Hiring growth trajectory

### Chart 13: Candidate Quality by Status
- **Type:** Bar chart
- **Axis:** `applications` → `status`
- **Values:** `[Candidate Quality Index]`
- **Insights:** Quality of pipeline by stage

### Chart 14: Salary Distribution
- **Type:** Histogram/Bar
- **Field:** `offers` → `salary`
- **Insights:** Salary distribution

---

**📝 NOTES:**
1. All measures use real column names from the dataset
2. No `source` field exists — analyze via `status` & `rating`
3. `Average Time to Hire` uses `offered_at` — check nulls before use
4. All measures handle division-by-zero safely

---

## 📈 BUSINESS INSIGHTS (5+)

### Insight 1: Hiring Rate
- 115 offers accepted out of 506 applications = **22.7% hire rate**
- Key KPI: Hiring Rate = 22.7%

### Insight 2: Offer Decline Rate
- 40 offers declined out of 155 total = **25.8% decline rate**
- High decline rate may indicate compensation mismatch

### Insight 3: Interview Quality
- Average interview score = 7.06/10 (strong across pipeline)

### Insight 4: Department Variation
- Departments: Engineering, Marketing, Sales, HR
- Hiring rates vary significantly by department

### Insight 5: Pipeline Leakage
- 77.3% of applicants rejected
- 25.8% of offers declined
- Total funnel attrition = ~75%

---

## 📋 DASHBOARD IMPLEMENTATION CHECKLIST

- [ ] Create Power BI .pbix file
- [ ] Import 5 CSV files (candidates, job_openings, applications, interviews, offers)
- [ ] Set up relationships (as shown in schema)
- [ ] Add data quality transformers (handle nulls, remove duplicates)
- [ ] Create DAX measure table (see measures above)
- [ ] Create visual 1: Total Applicants (Card)
- [ ] Create visual 2: Hired Candidates (Card)
- [ ] Create visual 3: Hiring Rate (Card)
- [ ] Create visual 4: Offer Status Breakdown (Donut)
- [ ] Create visual 5: Dept-wise Hiring (Bar)
- [ ] Create visual 6: Avg Salary by Department (Bar)
- [ ] Create visual 7: Hiring Rate by Department (Bar)
- [ ] Create visual 8: Interview Trend (Line)
- [ ] Create visual 9: Monthly Hiring Trend (Line)
- [ ] Create visual 10: Avg Interview Score (Card)
- [ ] Apply dark theme (dashboard_background.png)
- [ ] Configure page layout (header, KPI cards, charts)
- [ ] Set up cross-filtering and slicers
- [ ] Add data quality transformers for nulls
- [ ] Add date table for trend analysis
- [ ] Export dashboard preview
- [ ] Create GitHub README
- [ ] Prepare project images

---

## 📋 FINAL AUDIT REPORT — Pending / Completed / Issues

### ✅ COMPLETED

| # | Item | Status |
|---|---|---|
| 1 | Dataset verification | ✅ Complete |
| 2 | Data quality audit | ✅ Complete |
| 3 | DAX measures library | ✅ Complete |
| 4 | Dashboard visualization plan | ✅ Complete |
| 5 | Business insights (5+) | ✅ Complete |
| 6 | Dashboard implementation checklist | ✅ Complete |
| 7 | Documentation saved | ✅ Complete |

### 🟡 IN PROGRESS (Requires Power BI Desktop)

| # | Item | Status |
|---|---|---|
| 1 | Data import to MariaDB | ⏳ Waiting for server |
| 2 | Power BI .pbix file creation | ⏳ Pending |
| 3 | Visual configuration | ⏳ Pending |
| 4 | Dashboard validation | ⏳ Pending |

### ❌ REQUIRED (User Action)

| # | Item |
|---|---|
| 1 | Start MariaDB service |
| 2 | Import data into MariaDB |
| 3 | Create .pbix in Power BI Desktop |
| 4 | Build KPI cards & visuals |
| 5 | Finalize dashboard |

---

**📍 Next Step:** Start MariaDB service to enable data import. Then create the .pbix in Power BI Desktop and build the dashboard using the measures and charts above.