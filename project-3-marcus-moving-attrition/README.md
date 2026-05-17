# Marcus Moving Co. — Workforce Attrition Analysis

---

## Business Context

Marcus runs a 45-person moving and storage company in Queens, NY. Over the past few years, he's been losing drivers and movers at an alarming rate — constantly rehiring, retraining, and absorbing the hidden costs of turnover. He brought in DataMade to answer one question:

> *"Just tell me who's leaving, when, and why — and flag anyone I should be worried about."*

This project delivers a full attrition diagnostic: from raw HR data to a Tableau dashboard Marcus can check every month.

---

## Key Findings

| Finding | Detail |
|---|---|
| Overall attrition rate | **50.3%** across 185 employees |
| Highest-risk role | **Drivers** at 62.5% attrition |
| #1 exit reason | **Burnout** (24 exits) |
| Peak risk tenure window | **1–2 years** |
| Seasonal spike | **January–February** every year |
| Highest-risk manager | **Sam Garcia** — 85.7% team attrition |
| Active employees at risk | **11 medium flight-risk** employees flagged |

---

## Recommendations

- Cap driver overtime — burnout is the #1 reason they leave
- Schedule retention check-ins at the 12-month mark
- Review Sam Garcia's management practices
- Pre-hire in December/March ahead of Q1 attrition spikes
- Priority 1:1 conversations with 11 flagged medium-risk employees

---

## Project Structure

```
marcus-moving-attrition/
│
├── data/
│   ├── employees.csv                  # 185 employees, hire/term dates, roles
│   ├── exit_records.csv               # 93 exits with reasons and survey scores
│   ├── attendance_monthly.csv         # 3,963 monthly attendance records
│   └── performance_reviews.csv        # 648 semi-annual review records
│
├── sql/
│   └── marcus_moving_final.sql        # Full Snowflake setup: RAW → STAGING → MARTS
│
├── notebooks/
│   └── marcus_moving_eda.ipynb        # Python EDA + Holt-Winters forecasting
│
└── README.md
```

---

## Data Architecture

```
RAW (CSV uploads)
    ↓
STAGING (stg_)     → clean, cast, derive base fields
    ↓
MARTS (mart_)      → business logic, joins, metrics
```

**Staging views:** `stg_employees` · `stg_exit_records` · `stg_attendance_monthly` · `stg_performance_reviews`

**Mart views:**
- `mart_employee_attrition` — one row per employee, full attrition profile
- `mart_monthly_attrition_trend` — monthly headcount, exits, attrition rate
- `mart_manager_scorecard` — per-manager attrition, burnout rate, OT load
- `mart_flight_risk_signals` — active employees with 0–100 flight risk score

---

## Dashboard

**Tableau Public:** [Marcus Moving Co. — Workforce Attrition Analysis](https://public.tableau.com/app/profile/mahfuz.kabir.pulak/viz/MarcusMovingCo-WorkforceAttritionAnalytics/MarcusMovingCo_-WorkforceAttritionAnalysis)

6-panel dashboard covering:
- Attrition rate by role
- Attrition rate by tenure band
- Exit reasons breakdown
- Manager scorecard (team health flag)
- Monthly attrition trend (2022–2026)
- Flight risk ranking of active employees

---

## Tools Used

| Tool | Purpose |
|---|---|
| Python (pandas, matplotlib, seaborn) | EDA and visualization |
| statsmodels (Holt-Winters) | Attrition rate forecasting |
| Snowflake | Data warehouse, staging, mart layer |
| Tableau Public | Interactive dashboard |
| Jupyter Notebook | Analysis environment |

---

*Built by DataMade.co — freelance analytics for small businesses.*
