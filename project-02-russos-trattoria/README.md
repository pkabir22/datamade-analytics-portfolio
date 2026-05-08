# Russo's Trattoria — Restaurant Analytics Dashboard
**DataMade Analytics · Project 2**

An end-to-end restaurant analytics project for a mid-range Italian trattoria in Garden City, Long Island. Built for Sofia Russo, a second-generation Italian-American owner looking to understand her margins, peak hours, top-performing menu items, and guest behavior before considering expansion.

---

## Live Dashboard
**[View on Tableau Public →](https://public.tableau.com/app/profile/mahfuz.kabir.pulak/viz/RussosTrattoriaAnalytics/Dashboard)**

---

## Project Overview

| | |
|---|---|
| **Client** | Sofia Russo, Owner — Russo's Trattoria |
| **Location** | Garden City, Long Island, NY |
| **Data Period** | January 2022 – April 2026 (4+ years including YTD) |
| **Stack** | Snowflake · SQL · Tableau Public |
| **Engagement** | Initial analytics audit — revenue, costs, operations, guests |

---

## Business Questions Answered

- What are the café's actual revenue, gross profit, and operating margin by year — and how is 2026 tracking?
- Which menu categories and items drive the most revenue vs just the most volume?
- When are the peak hours and days — and is staffing aligned to demand?
- How have food vs alcohol revenue trended over 4 years?
- Which servers are driving the most revenue and alcohol upsells?
- Who are the most valuable guests, and which Long Island towns do they come from?

---

## Data Model

| Table | Rows | Description |
|---|---|---|
| `sales_transactions` | 449,279 | Every line item sold, Jan 2022 – Apr 2026 |
| `reservations` | 38,528 | Table seatings — walk-in vs reservation, party size, server |
| `labor_hours` | 14,538 | Daily shifts with hours worked and pay rate |
| `inventory_purchases` | 3,150 | Weekly COGS restocking by ingredient and supplier |
| `guest_profiles` | 850 | Loyalty member profiles — segment, town, lifetime value |
| `menu_dim` | 33 | Product reference — price, COGS %, margin classification |
| `staff_dim` | 14 | Employee reference — role, hire date, base rate |

Aggregated mart tables built on top of raw data for Tableau:

| Mart Table | Rows | Purpose |
|---|---|---|
| `agg_daily_summary` | 2,251 | Daily KPIs — revenue, covers, food vs alcohol, margins |
| `agg_category_monthly` | 416 | Monthly revenue by menu category |
| `agg_item_performance` | 165 | Annual revenue and volume by item |
| `agg_hourly_heatmap` | 46 | Revenue by hour and day of week |
| `agg_server_performance` | 30 | Revenue and alcohol upsell rate by server |

---

## Dashboard Views

**7 visualizations in a single scrollable dashboard:**

1. **Revenue Trend** — Monthly revenue Jan 2022 to Apr 2026, showing consistent YoY growth
2. **Revenue by Category** — Food vs alcohol split across all 8 menu categories
3. **Monthly P&L** — Total revenue, food revenue, and alcohol revenue on one chart
4. **Top Items by Revenue** — All 33 menu items ranked, color-coded by category
5. **Revenue by Day & Hour** — Stacked bar showing peak hours by day of week
6. **Server Performance** — Revenue per server with alcohol upsell rate as color
7. **Revenue by Town** — Guest lifetime value by Long Island town, segmented by loyalty tier

---

## Key Findings

- **Revenue grew ~22% from 2022 to 2024** and has sustained that trajectory into 2025–2026
- **Secondi (mains) dominate revenue** — Bistecca Tagliata and Osso Buco are the top 2 items by a significant margin
- **Dinner service (5–9pm) generates roughly 2× lunch revenue** — Friday and Saturday evenings are peak windows
- **Alcohol represents ~25% of total revenue** — Wine and Bar categories are meaningful contributors
- **VIP guests (~19% of the loyalty base) drive disproportionate revenue** — protecting this segment is critical
- **New Hyde Park and Floral Park are the top guest towns** — Garden City locals rank 4th despite being neighbors
- **Sofia Abbate leads server revenue** — alcohol upsell rates are consistent across the team

---

## Tools & Stack

```
Raw Data      →  Python (pandas) — synthetic data generation
Storage       →  Snowflake (RUSSOS_DB · RAW schema)
SQL           →  Snowflake SQL — DDL, data load, aggregation queries
Visualization →  Tableau Public — 7-chart analytics dashboard
```

---

## Repo Structure

```
russos-trattoria-analytics/
│
├── README.md
├── data/
│   ├── raw/
│   │   ├── russos_menu_dim.csv
│   │   ├── russos_staff_dim.csv
│   │   ├── russos_guest_profiles.csv
│   │   ├── russos_inventory_purchases.csv
│   │   ├── russos_labor_hours.csv
│   │   └── russos_reservations.csv
│   └── aggregated/
│       ├── agg_daily_summary.csv
│       ├── agg_category_monthly.csv
│       ├── agg_item_performance.csv
│       ├── agg_hourly_heatmap.csv
│       └── agg_server_performance.csv
├── sql/
│   ├── 01_setup.sql
│   └── russos_analysis.sql
└── tableau/
    └── RussosTrattoriaAnalytics.twbx
```

---

## About DataMade

DataMade is a freelance data analytics practice building SQL infrastructure, dashboards, and analytical narratives for small and mid-size businesses. This is Project 2 of an ongoing portfolio series.

[View full DataMade Analytics Portfolio](https://github.com/pkabir22/datamade-analytics-portfolio)
