# Russo's Trattoria — Restaurant Analytics Dashboard

![Live Dashboard](https://img.shields.io/badge/Live%20Dashboard-Tableau%20Public-1a73e8?style=flat-square&labelColor=2c2c2c)
![Tool](https://img.shields.io/badge/Tool-Snowflake%20%7C%20Python%20%7C%20SQL%20%7C%20Tableau-4a90d9?style=flat-square&labelColor=2c2c2c)
![Data](https://img.shields.io/badge/Data-Simulated%20Restaurant%20Data-3d9970?style=flat-square&labelColor=2c2c2c)

---

## 1. Project Overview

| | |
|---|---|
| **Client** | Sofia Russo, Owner — Russo's Trattoria |
| **Location** | Garden City, Long Island, NY |
| **Industry** | Food & Beverage / Independent Restaurant |
| **Data Period** | January 2022 – April 2026 (4+ years including 2026 YTD) |
| **Engagement Type** | Initial analytics audit |
| **Stack** | Python · Snowflake · SQL · Tableau Public |

Russo's Trattoria is a mid-range Italian trattoria in Garden City, Long Island — 65 covers, open 6 days a week, running lunch and dinner service. Sofia Russo is a second-generation Italian-American owner who modernized her family's red-sauce concept into a polished neighborhood trattoria. Four years in, the business feels stable and growing — but Sofia is making key decisions (staffing, menu, potential second location) without knowing her actual numbers.

---

## 2. The Problem

Sofia came to DataMade with a straightforward ask:

> *"I track sales on my POS, payroll on a spreadsheet, and I reorder inventory on gut feel. Before I even think about a second location, I need to understand my real margins, which products are worth keeping, when my busiest hours are, and whether I'm paying for the right staff at the right times."*

**Core pain points:**
- No visibility into food vs alcohol revenue split or how it trends over time
- No understanding of which menu items are profitable vs just popular
- Staffing decisions made by feel, not by peak hour data
- Guest loyalty data collected but never analyzed
- No baseline to evaluate whether 2026 is on track vs prior years

---

## 3. The Solution

### Data Architecture

Raw operational data was modeled into a two-layer structure in Snowflake:

**RAW schema** — source tables loaded from CSV exports:

| Table | Rows | Description |
|---|---|---|
| `sales_transactions` | 449,279 | Every line item sold, Jan 2022 – Apr 2026 |
| `reservations` | 38,528 | Table seatings — walk-in vs reservation, party size, server |
| `labor_hours` | 14,538 | Daily shifts with hours worked and pay rate |
| `inventory_purchases` | 3,150 | Weekly COGS restocking by ingredient and supplier |
| `guest_profiles` | 850 | Loyalty member profiles — segment, town, lifetime value |
| `menu_dim` | 33 | Product reference — price, COGS %, margin by category |
| `staff_dim` | 14 | Employee reference — role, hire date, base hourly rate |

**Aggregated mart tables** — built via SQL, optimized for Tableau:

| Mart Table | Rows | Purpose |
|---|---|---|
| `agg_daily_summary` | 2,251 | Daily KPIs — revenue, covers, food vs alcohol split |
| `agg_category_monthly` | 416 | Monthly revenue by menu category |
| `agg_item_performance` | 165 | Annual revenue and volume per menu item |
| `agg_hourly_heatmap` | 46 | Revenue by hour and day of week |
| `agg_server_performance` | 30 | Revenue and alcohol upsell rate by server per year |

### Dashboard Architecture

A single scrollable Tableau Public dashboard with 7 views:

| View | Chart Type | Data Source |
|---|---|---|
| Revenue Trend | Line | `agg_daily_summary` |
| Revenue by Category | Horizontal bar | `agg_category_monthly` |
| Monthly P&L | Multi-line | `agg_daily_summary` |
| Top Items by Revenue | Horizontal bar | `agg_item_performance` |
| Revenue by Day & Hour | Stacked bar | `agg_hourly_heatmap` |
| Server Performance | Horizontal bar | `agg_server_performance` |
| Revenue by Town | Horizontal bar | `guest_profiles` |

---

## 4. Key Findings

- **Revenue grew ~22% from 2022 to 2024** and has sustained that trajectory into 2025 and 2026 YTD — the business is genuinely growing, not just inflating prices
- **Secondi (mains) dominate revenue** — Bistecca Tagliata ($42) and Osso Buco ($38) are the top 2 items by a significant margin; high-ticket items are being ordered
- **Dinner service (5–9pm) generates roughly 2× lunch revenue** — Friday and Saturday evenings are the single highest-value windows of the week
- **Alcohol represents ~25% of total revenue** — Wine and Bar are meaningful contributors; this is a lever Sofia is not actively managing
- **VIP guests (~19% of the loyalty base) drive disproportionate lifetime value** — the top segment outspends Occasional guests by 4× per head
- **New Hyde Park and Floral Park are the top guest towns** — Garden City locals rank 4th despite proximity, suggesting untapped local marketing opportunity
- **Sofia Abbate leads server revenue** — the team is relatively consistent on alcohol upsell rates, with minor variation worth monitoring

---

## 5. Recommendations

1. **Double down on Friday and Saturday dinner staffing** — peak hours (6–9pm Fri/Sat) show the highest revenue concentration; under-staffing these windows directly costs revenue
2. **Launch a targeted wine upsell program** — alcohol is 25% of revenue with high margins; training servers on wine pairing for Secondi could meaningfully lift average check
3. **Protect and grow the VIP guest segment** — consider a simple loyalty recognition program (priority reservations, seasonal preview dinners) for the top 19% who drive outsized value
4. **Activate local Garden City marketing** — the restaurant's home town ranks 4th in guest revenue; targeted local outreach (neighborhood mailers, local business partnerships) has clear upside
5. **Evaluate the Contorni and Beverage categories** — lowest revenue contribution; consider consolidating or refreshing these items rather than maintaining full menus in low-performing sections
6. **Use 2026 YTD as a performance baseline** — Jan–Apr 2026 data is now available; compare monthly against Jan–Apr 2025 to flag any early-year softness before it becomes a trend

---

## 6. Tools & Stack

| Layer | Tool | Purpose |
|---|---|---|
| Data Generation | Python (pandas) | Synthetic data modeling — 4+ years of realistic restaurant operations |
| Data Warehouse | Snowflake | RAW schema storage, SQL transformations, mart table builds |
| SQL | Snowflake SQL | DDL, data load (COPY INTO), aggregation queries |
| Visualization | Tableau Public | 7-chart interactive dashboard |
| Version Control | GitHub | Project documentation and file storage |

---

## 7. Dashboard

**[View Live on Tableau Public →](https://public.tableau.com/app/profile/mahfuz.kabir.pulak/viz/RussosTrattoriaAnalytics/Dashboard)**

---

## 8. Project Deliverables

- [x] Synthetic dataset — 449K+ sales transactions across 7 normalized tables (Jan 2022 – Apr 2026)
- [x] Snowflake data warehouse — RAW schema + 5 aggregated mart tables
- [x] SQL scripts — infrastructure setup and full analysis query library (7 sections, 22 queries)
- [x] Tableau Public dashboard — 7 interactive views in a single scrollable layout
- [x] Key findings and actionable recommendations

---

## 9. Repo Structure

```
datamade-analytics-portfolio/
└── project-02-russos-trattoria/
    │
    ├── README.md
    │
    ├── russos_setup.sql              ← Snowflake DDL: warehouse, schemas, tables, stage
    ├── russos_sql_analysis.sql       ← Full analysis query library (22 queries, 7 sections)
    │
    ├── russos_menu_dim.csv           ← 33 menu items with price and margin data
    ├── russos_staff_dim.csv          ← 14 staff records with roles and rates
    ├── russos_guest_profiles.csv     ← 850 loyalty member profiles
    ├── russos_inventory_purchases.csv← 3,150 weekly COGS restocking records
    ├── russos_labor_hours.csv        ← 14,538 daily shift records
    ├── russos_reservations.csv       ← 38,528 table seatings
    │
    ├── daily_summary.csv             ← Aggregated daily KPIs (Tableau primary source)
    ├── category_monthly.csv          ← Monthly revenue by menu category
    ├── item_performance.csv          ← Annual revenue per menu item
    ├── hourly_heatmap.csv            ← Revenue by hour and day of week
    └── server_performance.csv        ← Server revenue and upsell metrics
```
---

## About DataMade

DataMade is a freelance data analytics practice building dashboards, automated reports, and analytics solutions for small businesses and independent operators. This is Project 1 of an ongoing portfolio series.

[View full DataMade Analytics Portfolio](https://github.com/pkabir22/datamade-analytics-portfolio)

---

*Built by [DataMade](https://datamade.co) · BI & Analytics Consulting · New York, NY*
