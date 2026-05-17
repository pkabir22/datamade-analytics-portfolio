# Marcus Moving Co. — Workforce Attrition Analysis

**Independent Client Project · People Analytics · DataMade**

![Live Dashboard](https://img.shields.io/badge/Live%20Dashboard-Tableau%20Public-blue)
![Tool](https://img.shields.io/badge/Tool-Snowflake%20%7C%20Python%20%7C%20Tableau-9cf)
![Data](https://img.shields.io/badge/Data-Simulated%20HR%20Data-green)

---

## Project Overview

A freelance analytics engagement for Marcus, owner of a 45-person moving and storage company based in Queens, NY. Marcus had been losing drivers and movers at an alarming rate — constantly rehiring, retraining, and absorbing the hidden costs of turnover — with no visibility into why it was happening or who was next to leave.

This project delivered a full workforce attrition diagnostic: from raw HR data modeled in Snowflake, to a Python-powered EDA with forecasting, to a 6-panel Tableau Public dashboard Marcus can check every month.

---

## The Problem

> *"Just tell me who's leaving, when, and why — and flag anyone I should be worried about."*

Key business questions the client needed answered:

- Which roles and departments have the highest attrition?
- At what point in their tenure are employees most likely to leave?
- Are there seasonal patterns to when people quit?
- Is any manager driving disproportionate turnover on their team?
- Which active employees are at highest risk of leaving next?

---

## The Solution

### Data Architecture

Four structured HR datasets modeled in Snowflake across three layers:

| File | Description | Rows |
|---|---|---|
| `employees.csv` | All employees ever hired — roles, tenure, status | 185 |
| `exit_records.csv` | Departed employees with exit reasons and survey scores | 93 |
| `attendance_monthly.csv` | Monthly attendance, overtime, and absence records | 3,963 |
| `performance_reviews.csv` | Semi-annual performance scores and manager tags | 648 |

```
RAW (CSV uploads)
    ↓
STAGING (stg_)     → clean, cast, derive base fields
    ↓
MARTS (mart_)      → business logic, joins, metrics
```

**Staging views:** `stg_employees` · `stg_exit_records` · `stg_attendance_monthly` · `stg_performance_reviews`

**Mart views:**

| Mart | Purpose |
|---|---|
| `mart_employee_attrition` | One row per employee, full attrition profile |
| `mart_monthly_attrition_trend` | Monthly headcount, exits, and attrition rate |
| `mart_manager_scorecard` | Per-manager attrition rate, burnout %, OT load |
| `mart_flight_risk_signals` | Active employees scored 0–100 for flight risk |

### Dashboard Architecture

Built in Tableau Public with 6 panels:

| Visual | Business Question Answered |
|---|---|
| Attrition Rate by Role | Which roles are bleeding talent? |
| Attrition Rate by Tenure Band | When in their career are employees most at risk? |
| Exit Reasons Breakdown | Why are people leaving? |
| Manager Scorecard | Which managers are driving turnover? |
| Monthly Attrition Trend | When do exits spike across the year? |
| Flight Risk Ranking | Who among active staff should Marcus talk to now? |

---

## Key Findings

- **Overall attrition rate: 50.3%** across 185 employees since 2022
- **Drivers are the biggest problem** — 62.5% attrition rate, highest of any role
- **Burnout is the #1 exit reason** — 24 voluntary exits cited burnout directly
- **Peak risk window: 1–2 years tenure** — employees who survive past 2 years tend to stay
- **Q1 seasonal spike** — January and February consistently see the highest exit volume every year
- **Sam Garcia's team: 85.7% attrition** — the highest of any manager, with a high burnout rate among his crew
- **11 active employees flagged as medium flight risk** based on declining performance scores, high overtime, and tenure window

---

## Recommendations

- Cap driver overtime hours — burnout is the #1 voluntary exit driver
- Schedule proactive retention check-ins at the 12-month mark for all crew roles
- Review Sam Garcia's management practices — 85.7% team attrition is an outlier
- Pre-hire in December and March to get ahead of the January–February–April exit spikes
- Hold priority 1:1 conversations with the 11 flagged medium flight-risk employees now

---

## Tools & Stack

| Layer | Tool |
|---|---|
| Data Generation | Python (pandas, numpy) |
| Data Warehouse | Snowflake (RAW → STAGING → MARTS) |
| Analysis & EDA | Python (pandas, matplotlib, seaborn) |
| Forecasting | statsmodels — Holt-Winters Exponential Smoothing |
| Dashboard & Visualization | Tableau Public |
| Analysis Environment | Jupyter Notebook (Anaconda) |

---

## Dashboard

🔗 [View Live Dashboard →](https://public.tableau.com/app/profile/mahfuz.kabir.pulak/viz/MarcusMovingCo-WorkforceAttritionAnalytics/MarcusMovingCo_-WorkforceAttritionAnalysis)

---

## Project Deliverables

- ✅ 4 structured CSV data files (employees, exits, attendance, performance reviews)
- ✅ Snowflake data warehouse with 4 staging views and 4 mart views
- ✅ Python EDA notebook with 8 charts and Holt-Winters attrition forecast
- ✅ 6-panel interactive Tableau Public dashboard
- ✅ This documentation

---

## Repo Structure

```
project-3-marcus-moving-attrition/
├── README.md
├── employees.csv
├── exit_records.csv
├── attendance_monthly.csv
├── performance_reviews.csv
├── marcus_moving_final.sql
└── marcus_moving_eda.ipynb
```

---

## About DataMade

DataMade is a freelance data analytics practice building dashboards, automated reports, and analytics solutions for small businesses and independent operators. This is Project 3 of an ongoing portfolio series.

[View full DataMade Analytics Portfolio →](https://github.com/pkabir22/datamade-analytics-portfolio)

---

*Built by [DataMade](https://datamade.co) · BI & Analytics Consulting · New York, NY*
