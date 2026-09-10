CREATE TABLE financials (
    year INT PRIMARY KEY,
    revenue DECIMAL(10,1),
    cogs DECIMAL(10,1),
    inventories DECIMAL(10,1),
    receivables DECIMAL(10,1),
    payables DECIMAL(10,1)
);
INSERT INTO financials (year, revenue, cogs, inventories, receivables, payables)
VALUES
(2023, 5425.4, 4301.3, 550.2, 501.8, 659.1),
(2024, 3839.7, 2674.3, 634.8, 391.5, 611.7),
(2025, 3946.4, 2885.0, 662.9, 476.4, 715.9);

SELECT * FROM financials;

SELECT
    year,
    cogs,
    inventories,
    ROUND(cogs / inventories, 2) AS inventory_turnover
FROM financials;

-- DSO = Days Sales Outstanding
-- Measures: on average, how many days does it take customers to pay their invoices?
-- Lower is better (cash comes in faster). Rising DSO = customers taking longer to pay = cash tied up.
-- Formula: (Trade Receivables / Revenue) * 365
SELECT
    year,
    receivables,                                       
    revenue,                                            
    ROUND((receivables / revenue) * 365, 1) AS dso      
FROM financials;

-- DPO = Days Payables Outstanding
-- Measures: on average, how many days does Glanbia take to pay its own suppliers?
-- Higher is generally better for cash position (holding cash longer before paying out).
-- Formula: (Trade Payables / Cost of Goods Sold) * 365
SELECT
    year, payables, cogs,                                 
    ROUND((payables / cogs) * 365, 1) AS dpo
FROM financials;

-- Cash Conversion Cycle (CCC) = the master working capital KPI
-- Measures: total number of days cash is "stuck" in the business —
-- from paying for stock, through selling it, to finally collecting payment.
-- Lower is better (cash flows through faster). Rising CCC = more cash tied up in operations.
-- Formula: Inventory Days + DSO - DPO

SELECT
    year,
    ROUND((inventories / cogs) * 365, 1)                                    AS inventory_days,
    ROUND((receivables / revenue) * 365, 1)                                 AS dso,
    ROUND((payables / cogs) * 365, 1)                                       AS dpo,
    ROUND((inventories / cogs) * 365
        + (receivables / revenue) * 365
        - (payables / cogs) * 365, 1)                                       AS cash_conversion_cycle
FROM financials;

-- Step 1: Run Scenario A (DSO improvement)
-- SCENARIO A: What if Glanbia's 2025 DSO returned to its 2023 level (33.8 days)?
-- Logic: the "days" difference represents extra days of revenue sitting uncollected
-- in receivables. Converting that back to euros shows the real cash opportunity.

SELECT
    year,
    ROUND((receivables / revenue) * 365, 1) AS current_dso,
    33.8 AS target_dso_2023_level,
    ROUND((((receivables / revenue) * 365) - 33.8) / 365 * revenue, 1) AS cash_freed_if_target_hit
FROM financials
WHERE year = 2025;

-- Step 2: Run Scenario B (Inventory Days improvement)
-- SCENARIO B: What if Glanbia's 2025 Inventory Days returned to its 2023 level (46.7 days)?
-- Same logic, but using COGS as the base since inventory value relates to production cost

SELECT
    year,
    ROUND((inventories / cogs) * 365, 1) AS current_inventory_days,
    46.7 AS target_inventory_days_2023_level,
    ROUND((((inventories / cogs) * 365) - 46.7) / 365 * cogs, 1) AS cash_freed_if_target_hit
FROM financials
WHERE year = 2025;

-- Step 3: Scenario C — the combined opportunity
-- SCENARIO C: Combined effect of BOTH Scenario A (DSO) and Scenario B (Inventory Days)
-- improving back to their 2023 levels simultaneously.
-- This represents the full working capital opportunity identified by the diagnostic.

SELECT
    year,
    ROUND((((receivables / revenue) * 365) - 33.8) / 365 * revenue, 1) AS cash_freed_from_dso,
    ROUND((((inventories / cogs) * 365) - 46.7) / 365 * cogs, 1) AS cash_freed_from_inventory,
    ROUND(
        ((((receivables / revenue) * 365) - 33.8) / 365 * revenue)
        + ((((inventories / cogs) * 365) - 46.7) / 365 * cogs)
    , 1) AS total_cash_opportunity
FROM financials
WHERE year = 2025;

-- combining Glanbia and Kerry into one table
-- Combines Glanbia and Kerry's KPIs into one table, labeled by company.
-- This single, combined table is what we'll feed into Power BI for easy comparison charts.
-- UNION ALL stacks the two SELECT results on top of each other (must have matching column count/order).

SELECT
    'Glanbia' AS company,
    year,
    ROUND((inventories / cogs) * 365, 1) AS inventory_days,
    ROUND((receivables / revenue) * 365, 1) AS dso,
    ROUND((payables / cogs) * 365, 1) AS dpo,
    ROUND((inventories / cogs) * 365 + (receivables / revenue) * 365 - (payables / cogs) * 365, 1) AS cash_conversion_cycle
FROM financials

UNION ALL

SELECT
    'Kerry Group' AS company,
    year,
    ROUND((inventories / cogs) * 365, 1),
    ROUND((receivables / revenue) * 365, 1),
    ROUND((payables / cogs) * 365, 1),
    ROUND((inventories / cogs) * 365 + (receivables / revenue) * 365 - (payables / cogs) * 365, 1)
FROM kerry_financials;