# Dollar Bazaar — Multi-Store Sales & Margin Dashboard
**Independent Client Project · Retail Analytics · DataMade**

[![Dashboard](https://img.shields.io/badge/Live%20Dashboard-Looker%20Studio-blue?style=flat-square&logo=googleanalytics)](https://datastudio.google.com/u/0/reporting/a0255248-0067-4bc7-ad9e-4eda6ed4f8c1/page/QMDwF)
[![Tool](https://img.shields.io/badge/Tool-Looker%20Studio-yellow?style=flat-square)](https://lookerstudio.google.com)
[![Data](https://img.shields.io/badge/Data-Google%20Sheets-green?style=flat-square&logo=googlesheets)](https://sheets.google.com)

---

## Project Overview

A freelance analytics engagement for a retail business owner operating **three dollar store locations** across Queens and Brooklyn, NYC. The client had no visibility into store-level profitability, product margin performance, or seasonal trends — and was making inventory and staffing decisions on intuition alone.

This project delivered a fully interactive **Looker Studio dashboard** connected to structured Google Sheets data, giving the client a single source of truth across all three locations.

---

## Client Background

| | |
|---|---|
| **Client** | Alex (Retail Business Owner) |
| **Business** | 3-location dollar store chain |
| **Locations** | Rego Park · Pomonok · Brooklyn (Queens & Brooklyn, NYC) |
| **Data Period** | January 2024 – December 2025 (2 full years) |
| **Engagement Type** | Independent consulting project · DataMade |

---

## The Problem

> *"I have three stores and I have no idea which one is actually making me money after expenses. I know Brooklyn is busy but I don't know if busy means profitable. I also don't know which products I should be stocking more of and which ones are just taking up shelf space."*

**Key business questions the client needed answered:**
- Which store generates the most revenue — and which is most profitable after expenses?
- Which product categories drive margin vs. just volume?
- Which products are overstocked and tying up cash?
- How does labor cost compare to revenue by store and month?
- What are the seasonal patterns across 2 years?

---

## The Solution

### Data Architecture
Three structured data sources loaded into Google Sheets:

| File | Description | Rows |
|---|---|---|
| `alex_sales.csv` | Transaction-level POS export (2024–2025) | 75,269 |
| `alex_inventory.csv` | Product stock levels, reorder thresholds, stock value | 120 |
| `alex_expenses.csv` | Monthly expenses by store (rent, labor, utilities, misc) | 72 |

### Dashboard Structure
Built in **Google Looker Studio** with two interactive controls:
- **Store filter** — filter all visuals by individual location
- **Date range control** — slice by any custom date range

| Visual | Business Question Answered |
|---|---|
| 4 KPI Scorecards | Total Revenue · Gross Profit · Avg Margin · Units Sold |
| Revenue by Store (bar) | Which store drives the most top-line revenue? |
| Gross Profit by Store (bar) | Which store is most profitable? |
| Revenue by Category (bar) | Which product categories lead and lag? |
| Monthly Revenue Trend (line) | Seasonal patterns across all 3 stores, Jan 2024–Dec 2025 |

---

## Key Findings

### Store Performance
- **Brooklyn leads on revenue ($174K over 2 years)** but all three stores run near-identical gross margins (~42%) — meaning rent efficiency and labor management, not product mix, determines net profitability by location
- **Rego Park ($153K) and Pomonok ($128K)** trail Brooklyn but maintain healthy margins

### Product & Category Insights
- **Cleaning Supplies is the #1 revenue category** — drives ~17% of total revenue across all stores; consistent restocking priority
- **Stationery consistently underperforms** — lowest revenue per unit of shelf space; candidate for reduction or repricing
- **Food & Snacks** drives high volume but carries the lowest margin (~22%) — worth monitoring vs. higher-margin categories

### Seasonal Patterns
- **December revenue nearly doubles** vs. summer months in both 2024 and 2025 — a clear holiday spike giving the client a data-backed case to increase seasonal inventory orders ahead of Q4
- All stores show a mid-year dip (June–July) followed by recovery in September

### Year-over-Year Growth
- **Total revenue grew 8.6% from 2024 to 2025** ($218,742 → $237,576) — confirming the business is on a healthy growth trajectory

---

## Tools & Stack

| Layer | Tool |
|---|---|
| Data Generation & Cleaning | Python (pandas) |
| Data Storage | Google Sheets |
| Dashboard & Visualization | Google Looker Studio |
| Filters & Interactivity | Looker Studio Date Range + Dropdown Controls |

---

## Dashboard

🔗 **[View Live Dashboard →](https://datastudio.google.com/u/0/reporting/a0255248-0067-4bc7-ad9e-4eda6ed4f8c1/page/QMDwF)**


---

## Project Deliverables

- ✅ 3 structured CSV data files (sales, inventory, expenses)
- ✅ Google Sheets workbook with 3 connected tabs
- ✅ Interactive Looker Studio dashboard (5 visuals + 2 filters)
- ✅ Shareable dashboard link for client access on any device
- ✅ This documentation

---

## Engagement Details

| | |
|---|---|
| **Consultant** | Pulak · DataMade |
| **Website** | [datamade.co](https://datamade.co) |
| **Service** | BI Dashboard Build |
| **Delivery Timeline** | 2 weeks |
| **Client Access** | Shareable Looker Studio link — no software required |

---

*Built by [DataMade](https://datamade.co) · BI & Analytics Consulting · New York, NY*
