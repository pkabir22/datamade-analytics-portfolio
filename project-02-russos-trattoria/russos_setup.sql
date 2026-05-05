-- ============================================================
-- PROJECT  : Russo's Trattoria — Restaurant Analytics
-- Client   : Sofia Russo, Owner — Garden City, Long Island
-- Author   : DataMade Analytics
-- Script   : russos_setup.sql — Infrastructure & Table Definitions
-- Note     : Uses IF NOT EXISTS — safe to run without wiping data
-- ============================================================


-- ────────────────────────────────────────────────────────────
-- SECTION 1 · WAREHOUSE, DATABASE & SCHEMA
-- ────────────────────────────────────────────────────────────

CREATE WAREHOUSE IF NOT EXISTS RUSSOS_WH
    WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND   = 60
    AUTO_RESUME    = TRUE;

CREATE DATABASE IF NOT EXISTS RUSSOS_DB;

CREATE SCHEMA IF NOT EXISTS RUSSOS_DB.RAW;
CREATE SCHEMA IF NOT EXISTS RUSSOS_DB.ANALYTICS;

USE WAREHOUSE RUSSOS_WH;
USE DATABASE  RUSSOS_DB;
USE SCHEMA    RUSSOS_DB.RAW;


-- ────────────────────────────────────────────────────────────
-- SECTION 2 · TABLE DEFINITIONS
-- ────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS RAW.SALES_TRANSACTIONS (
    order_id        INTEGER,
    reservation_id  INTEGER,
    date            DATE,
    day_of_week     VARCHAR,
    service         VARCHAR,
    hour            INTEGER,
    table_num       INTEGER,
    party_size      INTEGER,
    category        VARCHAR,
    item            VARCHAR,
    unit_price      FLOAT,
    qty             INTEGER,
    discount_pct    FLOAT,
    line_total      FLOAT,
    is_alcohol      VARCHAR,
    server_id       VARCHAR,
    res_type        VARCHAR
);

CREATE TABLE IF NOT EXISTS RAW.RESERVATIONS (
    reservation_id  INTEGER,
    date            DATE,
    service         VARCHAR,
    table_num       INTEGER,
    party_size      INTEGER,
    server_id       VARCHAR,
    res_type        VARCHAR,
    hour            INTEGER
);

CREATE TABLE IF NOT EXISTS RAW.INVENTORY_PURCHASES (
    purchase_id          INTEGER,
    date                 DATE,
    ingredient_category  VARCHAR,
    supplier             VARCHAR,
    qty                  INTEGER,
    unit                 VARCHAR,
    unit_cost            FLOAT,
    total_cost           FLOAT
);

CREATE TABLE IF NOT EXISTS RAW.LABOR_HOURS (
    shift_id        INTEGER,
    date            DATE,
    employee_id     VARCHAR,
    employee_name   VARCHAR,
    role            VARCHAR,
    hours_worked    FLOAT,
    hourly_rate     FLOAT,
    labor_cost      FLOAT
);

CREATE TABLE IF NOT EXISTS RAW.GUEST_PROFILES (
    guest_id            VARCHAR,
    first_visit_date    DATE,
    total_visits        INTEGER,
    avg_check           FLOAT,
    lifetime_value      FLOAT,
    segment             VARCHAR,
    satisfaction        FLOAT,
    preferred_course    VARCHAR,
    town                VARCHAR
);

CREATE TABLE IF NOT EXISTS RAW.MENU_DIM (
    item_id             VARCHAR,
    category            VARCHAR,
    item                VARCHAR,
    price               FLOAT,
    cogs_pct            FLOAT,
    gross_margin_pct    FLOAT,
    is_alcohol          BOOLEAN,
    launch_year         INTEGER
);

CREATE TABLE IF NOT EXISTS RAW.STAFF_DIM (
    employee_id      VARCHAR,
    name             VARCHAR,
    role             VARCHAR,
    base_hourly_rate FLOAT,
    hire_date        DATE
);
