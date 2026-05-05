-- ============================================================
-- PROJECT  : Russo's Trattoria — Revenue & Operations Analytics
-- Client   : Sofia Russo, Owner — Garden City, Long Island
-- Tool     : SQLite / Databricks SQL compatible
-- Author   : DataMade Analytics
-- Period   : Jan 2022 – Apr 25, 2026 (YTD)
-- ============================================================
-- TABLES:
--   sales_transactions   order_id, reservation_id, date, day_of_week, service,
--                        hour, table_num, party_size, category, item, unit_price,
--                        qty, discount_pct, line_total, is_alcohol, server_id, res_type
--   reservations         reservation_id, date, service, table_num, party_size,
--                        server_id, res_type, hour
--   inventory_purchases  purchase_id, date, ingredient_category, supplier,
--                        qty, unit, unit_cost, total_cost
--   labor_hours          shift_id, date, employee_id, employee_name, role,
--                        hours_worked, hourly_rate, labor_cost
--   guest_profiles       guest_id, first_visit_date, total_visits, avg_check,
--                        lifetime_value, segment, satisfaction, preferred_course, town
--   menu_dim             item_id, category, item, price, cogs_pct,
--                        gross_margin_pct, is_alcohol, launch_year
--   staff_dim            employee_id, name, role, base_hourly_rate, hire_date
-- ============================================================


-- ────────────────────────────────────────────────────────────
-- SECTION 0 · DATA QUALITY CHECKS  (run before any analysis)
-- ────────────────────────────────────────────────────────────

-- 0.1  Row counts & date range per table
SELECT 'sales_transactions'  AS tbl, COUNT(*) AS rows, MIN(date) AS earliest, MAX(date) AS latest FROM sales_transactions
UNION ALL
SELECT 'reservations',  COUNT(*), MIN(date), MAX(date) FROM reservations
UNION ALL
SELECT 'inventory_purchases', COUNT(*), MIN(date), MAX(date) FROM inventory_purchases
UNION ALL
SELECT 'labor_hours',   COUNT(*), MIN(date), MAX(date) FROM labor_hours;

-- 0.2  Null check on critical columns
SELECT
    SUM(CASE WHEN order_id    IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN date        IS NULL THEN 1 ELSE 0 END) AS null_date,
    SUM(CASE WHEN line_total  IS NULL THEN 1 ELSE 0 END) AS null_line_total,
    SUM(CASE WHEN category    IS NULL THEN 1 ELSE 0 END) AS null_category,
    SUM(CASE WHEN server_id   IS NULL THEN 1 ELSE 0 END) AS null_server_id,
    SUM(CASE WHEN is_alcohol  IS NULL THEN 1 ELSE 0 END) AS null_is_alcohol
FROM sales_transactions;

-- 0.3  Orphaned server IDs (sales referencing staff not in staff_dim)
SELECT DISTINCT s.server_id
FROM sales_transactions s
LEFT JOIN staff_dim sd ON s.server_id = sd.employee_id
WHERE sd.employee_id IS NULL;

-- 0.4  Price sanity check — items with unit_price outside expected band
SELECT category, item, MIN(unit_price) AS min_price, MAX(unit_price) AS max_price
FROM sales_transactions
GROUP BY 1, 2
HAVING min_price <= 0 OR max_price > 500
ORDER BY max_price DESC;

-- 0.5  Duplicate order detection
SELECT order_id, COUNT(*) AS occurrences
FROM sales_transactions
GROUP BY order_id
HAVING COUNT(*) > 50   -- flag checks with unusually many line items
ORDER BY occurrences DESC
LIMIT 20;


-- ────────────────────────────────────────────────────────────
-- SECTION 1 · REVENUE OVERVIEW
-- ────────────────────────────────────────────────────────────

-- 1.1  Annual P&L summary — Revenue, Food vs Alcohol split, YoY growth
WITH annual AS (
    SELECT
        STRFTIME('%Y', date)                              AS year,
        COUNT(DISTINCT order_id)                          AS total_checks,
        COUNT(DISTINCT reservation_id)                    AS covers,
        ROUND(SUM(line_total), 2)                         AS gross_revenue,
        ROUND(SUM(CASE WHEN is_alcohol = 'Yes'
                       THEN line_total ELSE 0 END), 2)   AS alcohol_revenue,
        ROUND(SUM(CASE WHEN is_alcohol = 'No'
                       THEN line_total ELSE 0 END), 2)   AS food_revenue,
        ROUND(SUM(line_total * discount_pct), 2)          AS discounts_given,
        ROUND(AVG(line_total), 2)                         AS avg_line_value
    FROM sales_transactions
    GROUP BY 1
)
SELECT
    *,
    ROUND(alcohol_revenue * 100.0 / NULLIF(gross_revenue, 0), 1) AS alcohol_pct,
    ROUND(food_revenue    * 100.0 / NULLIF(gross_revenue, 0), 1) AS food_pct,
    ROUND((gross_revenue - LAG(gross_revenue) OVER (ORDER BY year))
          / NULLIF(LAG(gross_revenue) OVER (ORDER BY year), 0) * 100, 1) AS yoy_growth_pct
FROM annual
ORDER BY year;


-- 1.2  Monthly revenue trend (for Tableau time-series)
SELECT
    STRFTIME('%Y-%m', date)                               AS year_month,
    STRFTIME('%Y', date)                                  AS year,
    STRFTIME('%m', date)                                  AS month,
    COUNT(DISTINCT order_id)                              AS checks,
    COUNT(DISTINCT reservation_id)                        AS covers,
    ROUND(SUM(line_total), 2)                             AS revenue,
    ROUND(SUM(CASE WHEN is_alcohol='Yes' THEN line_total ELSE 0 END), 2) AS alcohol_rev,
    ROUND(SUM(CASE WHEN is_alcohol='No'  THEN line_total ELSE 0 END), 2) AS food_rev,
    ROUND(AVG(line_total), 2)                             AS avg_line_value
FROM sales_transactions
GROUP BY 1, 2, 3
ORDER BY 1;


-- 1.3  YTD comparison — 2026 vs 2025 (Jan 1 – Apr 25)
SELECT
    year,
    COUNT(DISTINCT order_id)      AS checks,
    COUNT(DISTINCT reservation_id)AS covers,
    ROUND(SUM(line_total), 2)     AS revenue,
    ROUND(AVG(line_total), 2)     AS avg_line_value
FROM (
    SELECT *, STRFTIME('%Y', date) AS year
    FROM sales_transactions
    WHERE STRFTIME('%m-%d', date) <= '04-25'
      AND year IN ('2025', '2026')
) sub
GROUP BY 1
ORDER BY 1;


-- 1.4  Revenue by service (Lunch vs Dinner)
SELECT
    service,
    STRFTIME('%Y', date)              AS year,
    COUNT(DISTINCT order_id)          AS checks,
    ROUND(SUM(line_total), 2)         AS revenue,
    ROUND(SUM(line_total) * 100.0
        / SUM(SUM(line_total)) OVER (PARTITION BY STRFTIME('%Y', date)), 1) AS revenue_share_pct
FROM sales_transactions
GROUP BY 1, 2
ORDER BY 2, revenue DESC;


-- 1.5  Revenue by day of week
SELECT
    day_of_week,
    CASE day_of_week
        WHEN 'Monday'    THEN 1 WHEN 'Tuesday'   THEN 2
        WHEN 'Wednesday' THEN 3 WHEN 'Thursday'  THEN 4
        WHEN 'Friday'    THEN 5 WHEN 'Saturday'  THEN 6
        ELSE 7
    END AS sort_order,
    COUNT(DISTINCT order_id)      AS checks,
    ROUND(SUM(line_total), 2)     AS revenue,
    ROUND(AVG(line_total), 2)     AS avg_line_value,
    COUNT(DISTINCT date)          AS days_open
FROM sales_transactions
GROUP BY 1, 2
ORDER BY 2;


-- ────────────────────────────────────────────────────────────
-- SECTION 2 · MENU & PRODUCT PERFORMANCE
-- ────────────────────────────────────────────────────────────

-- 2.1  Revenue & margin by category
SELECT
    s.category,
    s.is_alcohol,
    COUNT(*)                              AS line_items,
    SUM(s.qty)                            AS units_sold,
    ROUND(SUM(s.line_total), 2)           AS revenue,
    ROUND(AVG(m.cogs_pct) * 100, 1)       AS avg_cogs_pct,
    ROUND(SUM(s.line_total)
          * (1 - AVG(m.cogs_pct)), 2)     AS est_gross_profit,
    ROUND(SUM(s.line_total) * 100.0
        / SUM(SUM(s.line_total)) OVER (), 1) AS revenue_share_pct
FROM sales_transactions s
LEFT JOIN menu_dim m ON s.item = m.item AND s.category = m.category
GROUP BY 1, 2
ORDER BY revenue DESC;


-- 2.2  Top 15 items by revenue with margin
SELECT
    s.category,
    s.item,
    COUNT(*)                              AS times_ordered,
    ROUND(SUM(s.line_total), 2)           AS revenue,
    ROUND(AVG(s.unit_price), 2)           AS avg_selling_price,
    ROUND(AVG(m.gross_margin_pct), 1)     AS gross_margin_pct,
    ROUND(SUM(s.line_total)
          * AVG(m.gross_margin_pct) / 100, 2) AS est_profit_contribution
FROM sales_transactions s
LEFT JOIN menu_dim m ON s.item = m.item
GROUP BY 1, 2
ORDER BY revenue DESC
LIMIT 15;


-- 2.3  Worst performers — low volume AND low margin (menu pruning candidates)
SELECT
    s.category,
    s.item,
    COUNT(*)                          AS times_ordered,
    ROUND(SUM(s.line_total), 2)       AS revenue,
    ROUND(AVG(m.gross_margin_pct), 1) AS gross_margin_pct
FROM sales_transactions s
LEFT JOIN menu_dim m ON s.item = m.item
GROUP BY 1, 2
HAVING times_ordered < (SELECT AVG(cnt) FROM (
    SELECT COUNT(*) AS cnt FROM sales_transactions GROUP BY item
))
ORDER BY gross_margin_pct ASC, revenue ASC
LIMIT 10;


-- 2.4  Food vs alcohol revenue share by year — trend
SELECT
    STRFTIME('%Y', date)                    AS year,
    ROUND(SUM(CASE WHEN is_alcohol='Yes' THEN line_total ELSE 0 END)
          * 100.0 / SUM(line_total), 1)     AS alcohol_pct,
    ROUND(SUM(CASE WHEN is_alcohol='No'  THEN line_total ELSE 0 END)
          * 100.0 / SUM(line_total), 1)     AS food_pct
FROM sales_transactions
GROUP BY 1
ORDER BY 1;


-- 2.5  Discount analysis — revenue lost and by category
SELECT
    category,
    COUNT(*) FILTER (WHERE discount_pct > 0)  AS discounted_lines,
    COUNT(*)                                   AS total_lines,
    ROUND(COUNT(*) FILTER (WHERE discount_pct > 0) * 100.0 / COUNT(*), 1) AS discount_rate_pct,
    ROUND(SUM(unit_price * qty) - SUM(line_total), 2)  AS revenue_lost
FROM sales_transactions
GROUP BY 1
ORDER BY revenue_lost DESC;


-- ────────────────────────────────────────────────────────────
-- SECTION 3 · COVERS & TABLE PERFORMANCE
-- ────────────────────────────────────────────────────────────

-- 3.1  Covers per service per day of week (capacity utilisation proxy)
-- 65-seat restaurant, assume avg 1.7 turns weekday dinner, 2.1 weekend
SELECT
    day_of_week,
    service,
    COUNT(DISTINCT date)                      AS days_in_sample,
    SUM(party_size)                           AS total_covers,
    ROUND(SUM(party_size) * 1.0
          / COUNT(DISTINCT date), 1)          AS avg_covers_per_day,
    ROUND(SUM(party_size) * 100.0
          / (COUNT(DISTINCT date) * 65), 1)  AS capacity_utilisation_pct
FROM reservations
GROUP BY 1, 2
ORDER BY
    CASE day_of_week
        WHEN 'Tuesday' THEN 2 WHEN 'Wednesday' THEN 3
        WHEN 'Thursday' THEN 4 WHEN 'Friday' THEN 5
        WHEN 'Saturday' THEN 6 WHEN 'Sunday' THEN 7
    END, service;


-- 3.2  Revenue per cover by service
SELECT
    r.service,
    r.day_of_week,
    SUM(r.party_size)                         AS total_covers,
    ROUND(SUM(s.line_total), 2)               AS total_revenue,
    ROUND(SUM(s.line_total)
          / NULLIF(SUM(r.party_size), 0), 2)  AS revenue_per_cover
FROM reservations r
JOIN sales_transactions s ON r.reservation_id = s.reservation_id
GROUP BY 1, 2
ORDER BY revenue_per_cover DESC;


-- 3.3  Walk-in vs reservation — revenue & covers comparison
SELECT
    res_type,
    COUNT(DISTINCT reservation_id)            AS seatings,
    SUM(party_size)                           AS total_covers,
    ROUND(AVG(party_size), 1)                 AS avg_party_size
FROM reservations
GROUP BY 1;


-- 3.4  Hourly revenue heatmap — best hours by service
SELECT
    service,
    hour,
    COUNT(DISTINCT order_id)             AS checks,
    ROUND(SUM(line_total), 2)            AS revenue,
    ROUND(AVG(line_total), 2)            AS avg_line_value
FROM sales_transactions
GROUP BY 1, 2
ORDER BY 1, 2;


-- ────────────────────────────────────────────────────────────
-- SECTION 4 · COST & PROFITABILITY
-- ────────────────────────────────────────────────────────────

-- 4.1  Monthly P&L — Revenue vs COGS vs Labor vs Operating Profit
WITH rev AS (
    SELECT STRFTIME('%Y-%m', date) AS ym,
           ROUND(SUM(line_total), 2) AS revenue
    FROM sales_transactions GROUP BY 1
),
cogs AS (
    SELECT STRFTIME('%Y-%m', date) AS ym,
           ROUND(SUM(total_cost), 2) AS cogs
    FROM inventory_purchases GROUP BY 1
),
labor AS (
    SELECT STRFTIME('%Y-%m', date) AS ym,
           ROUND(SUM(labor_cost), 2)   AS labor_cost,
           ROUND(SUM(hours_worked), 1) AS hours_worked
    FROM labor_hours GROUP BY 1
)
SELECT
    r.ym,
    r.revenue,
    COALESCE(c.cogs, 0)                           AS cogs,
    COALESCE(l.labor_cost, 0)                      AS labor_cost,
    ROUND(r.revenue
          - COALESCE(c.cogs, 0)
          - COALESCE(l.labor_cost, 0), 2)          AS operating_profit,
    ROUND((r.revenue - COALESCE(c.cogs,0) - COALESCE(l.labor_cost,0))
          / NULLIF(r.revenue, 0) * 100, 1)         AS operating_margin_pct,
    COALESCE(l.hours_worked, 0)                    AS labor_hours,
    ROUND(r.revenue
          / NULLIF(COALESCE(l.hours_worked, 0), 0), 2) AS revenue_per_labor_hour
FROM rev r
LEFT JOIN cogs  c ON r.ym = c.ym
LEFT JOIN labor l ON r.ym = l.ym
ORDER BY r.ym;


-- 4.2  COGS by supplier and ingredient — annual
SELECT
    ingredient_category,
    supplier,
    STRFTIME('%Y', date)         AS year,
    SUM(qty)                     AS total_qty,
    ROUND(SUM(total_cost), 2)    AS total_spend,
    ROUND(AVG(unit_cost), 2)     AS avg_unit_cost
FROM inventory_purchases
GROUP BY 1, 2, 3
ORDER BY 1, 3;


-- 4.3  Input cost inflation — unit cost trend by ingredient
SELECT
    ingredient_category,
    STRFTIME('%Y', date)          AS year,
    ROUND(AVG(unit_cost), 2)      AS avg_unit_cost,
    ROUND((AVG(unit_cost)
           - MIN(AVG(unit_cost)) OVER (PARTITION BY ingredient_category))
          / NULLIF(MIN(AVG(unit_cost)) OVER (PARTITION BY ingredient_category), 0)
          * 100, 1)               AS pct_increase_from_2022_base
FROM inventory_purchases
GROUP BY 1, 2
ORDER BY 1, 2;


-- 4.4  Labor cost by role — efficiency analysis
SELECT
    role,
    COUNT(DISTINCT employee_id)       AS headcount,
    ROUND(SUM(hours_worked), 0)       AS total_hours,
    ROUND(SUM(labor_cost), 2)         AS total_labor_cost,
    ROUND(AVG(hourly_rate), 2)        AS avg_hourly_rate,
    ROUND(SUM(labor_cost)
          / NULLIF(SUM(hours_worked), 0), 2) AS effective_hourly_rate
FROM labor_hours
GROUP BY 1
ORDER BY total_labor_cost DESC;


-- ────────────────────────────────────────────────────────────
-- SECTION 5 · SERVER PERFORMANCE
-- ────────────────────────────────────────────────────────────

-- 5.1  Revenue per server
SELECT
    s.server_id,
    sd.name                                     AS server_name,
    COUNT(DISTINCT s.order_id)                  AS checks_served,
    SUM(r.party_size)                           AS covers_served,
    ROUND(SUM(s.line_total), 2)                 AS total_revenue,
    ROUND(SUM(s.line_total)
          / NULLIF(COUNT(DISTINCT s.order_id), 0), 2) AS avg_check_value,
    ROUND(SUM(CASE WHEN s.is_alcohol='Yes'
                   THEN s.line_total ELSE 0 END)
          * 100.0 / NULLIF(SUM(s.line_total), 0), 1)  AS alcohol_upsell_pct
FROM sales_transactions s
LEFT JOIN staff_dim sd ON s.server_id = sd.employee_id
LEFT JOIN reservations r ON s.reservation_id = r.reservation_id
GROUP BY 1, 2
ORDER BY total_revenue DESC;


-- 5.2  Server upsell — dessert and alcohol attach rate
SELECT
    s.server_id,
    sd.name,
    COUNT(DISTINCT s.order_id)                         AS checks,
    COUNT(DISTINCT CASE WHEN s.category = 'Dolci'
                        THEN s.order_id END)            AS checks_with_dessert,
    ROUND(COUNT(DISTINCT CASE WHEN s.category='Dolci'
                              THEN s.order_id END)
          * 100.0 / COUNT(DISTINCT s.order_id), 1)     AS dessert_attach_pct,
    COUNT(DISTINCT CASE WHEN s.is_alcohol = 'Yes'
                        THEN s.order_id END)            AS checks_with_alcohol,
    ROUND(COUNT(DISTINCT CASE WHEN s.is_alcohol='Yes'
                              THEN s.order_id END)
          * 100.0 / COUNT(DISTINCT s.order_id), 1)     AS alcohol_attach_pct
FROM sales_transactions s
LEFT JOIN staff_dim sd ON s.server_id = sd.employee_id
WHERE sd.role = 'Server'
GROUP BY 1, 2
ORDER BY dessert_attach_pct DESC;


-- ────────────────────────────────────────────────────────────
-- SECTION 6 · GUEST ANALYTICS
-- ────────────────────────────────────────────────────────────

-- 6.1  Guest segment distribution and value
SELECT
    segment,
    COUNT(*)                            AS guests,
    ROUND(AVG(total_visits), 1)         AS avg_visits,
    ROUND(AVG(avg_check), 2)            AS avg_check,
    ROUND(SUM(lifetime_value), 2)       AS total_revenue,
    ROUND(SUM(lifetime_value) * 100.0
          / SUM(SUM(lifetime_value)) OVER (), 1) AS revenue_share_pct,
    ROUND(AVG(satisfaction), 2)         AS avg_satisfaction
FROM guest_profiles
GROUP BY 1
ORDER BY total_revenue DESC;


-- 6.2  Revenue by hometown (Long Island towns)
SELECT
    town,
    COUNT(*)                        AS guests,
    ROUND(SUM(lifetime_value), 2)   AS total_revenue,
    ROUND(AVG(avg_check), 2)        AS avg_check,
    ROUND(AVG(satisfaction), 2)     AS avg_satisfaction
FROM guest_profiles
GROUP BY 1
ORDER BY total_revenue DESC;


-- 6.3  Guest acquisition by year
SELECT
    STRFTIME('%Y', first_visit_date)  AS join_year,
    COUNT(*)                           AS new_guests,
    ROUND(AVG(avg_check), 2)           AS avg_check,
    ROUND(AVG(total_visits), 1)        AS avg_visits_to_date
FROM guest_profiles
GROUP BY 1
ORDER BY 1;


-- 6.4  80/20 revenue concentration check
WITH ranked AS (
    SELECT
        guest_id,
        lifetime_value,
        ROW_NUMBER() OVER (ORDER BY lifetime_value DESC) AS rk,
        COUNT(*) OVER ()                                  AS total_guests,
        SUM(lifetime_value) OVER ()                       AS grand_total
    FROM guest_profiles
)
SELECT
    CASE WHEN rk <= ROUND(total_guests * 0.20)
         THEN 'Top 20% of guests'
         ELSE 'Bottom 80% of guests'
    END                                                 AS segment,
    COUNT(*)                                            AS guests,
    ROUND(SUM(lifetime_value), 2)                       AS revenue,
    ROUND(SUM(lifetime_value) / MAX(grand_total) * 100, 1) AS revenue_share_pct
FROM ranked
GROUP BY 1;


-- ────────────────────────────────────────────────────────────
-- SECTION 7 · TABLEAU-READY FLAT OUTPUTS
-- ────────────────────────────────────────────────────────────

-- 7.1  Daily KPI table — primary Tableau data source
WITH daily_rev AS (
    SELECT date,
        service,
        COUNT(DISTINCT order_id)       AS checks,
        COUNT(DISTINCT reservation_id) AS covers,
        SUM(line_total)                AS revenue,
        SUM(CASE WHEN is_alcohol='Yes' THEN line_total ELSE 0 END) AS alcohol_rev,
        SUM(CASE WHEN is_alcohol='No'  THEN line_total ELSE 0 END) AS food_rev,
        SUM(party_size)                AS total_guests
    FROM sales_transactions
    GROUP BY 1, 2
),
daily_all AS (
    SELECT date,
        SUM(checks)       AS checks,
        SUM(covers)       AS covers,
        SUM(revenue)      AS revenue,
        SUM(alcohol_rev)  AS alcohol_rev,
        SUM(food_rev)     AS food_rev,
        SUM(total_guests) AS total_guests
    FROM daily_rev GROUP BY 1
),
daily_labor AS (
    SELECT date,
        SUM(labor_cost)   AS labor_cost,
        SUM(hours_worked) AS hours_worked
    FROM labor_hours GROUP BY 1
),
daily_cogs AS (
    SELECT date, SUM(total_cost) AS cogs
    FROM inventory_purchases GROUP BY 1
)
SELECT
    r.date,
    STRFTIME('%Y',  r.date)  AS year,
    STRFTIME('%m',  r.date)  AS month,
    STRFTIME('%W',  r.date)  AS week_num,
    CASE STRFTIME('%w', r.date)
        WHEN '0' THEN 'Sunday'   WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'  WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday' WHEN '5' THEN 'Friday'
        ELSE 'Saturday'
    END                      AS day_of_week,
    CASE WHEN STRFTIME('%w', r.date) IN ('5','6','0')
         THEN 'Weekend/Friday' ELSE 'Weekday' END AS day_type,
    r.checks,
    r.covers,
    r.total_guests,
    ROUND(r.revenue, 2)                               AS revenue,
    ROUND(r.alcohol_rev, 2)                           AS alcohol_revenue,
    ROUND(r.food_rev, 2)                              AS food_revenue,
    ROUND(r.alcohol_rev * 100.0 / NULLIF(r.revenue,0),1) AS alcohol_pct,
    ROUND(r.revenue / NULLIF(r.covers, 0), 2)         AS revenue_per_cover,
    COALESCE(ROUND(l.labor_cost, 2), 0)               AS labor_cost,
    COALESCE(ROUND(l.hours_worked, 1), 0)             AS hours_worked,
    COALESCE(ROUND(c.cogs, 2), 0)                     AS cogs,
    ROUND(r.revenue
          - COALESCE(l.labor_cost,0)
          - COALESCE(c.cogs,0), 2)                    AS operating_profit,
    ROUND((r.revenue - COALESCE(l.labor_cost,0) - COALESCE(c.cogs,0))
          / NULLIF(r.revenue,0) * 100, 1)             AS margin_pct
FROM daily_all r
LEFT JOIN daily_labor l ON r.date = l.date
LEFT JOIN daily_cogs  c ON r.date = c.date
ORDER BY r.date;
