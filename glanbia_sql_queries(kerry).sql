-- Step 1: Create the table
-- A table for our benchmark company, Kerry Group, structured the same way as Glanbia's table
-- Note: 2023's "cogs" value will be left blank (NULL) since Kerry didn't publish
-- a comparable Raw Materials figure for that year

CREATE TABLE kerry_financials (
    year INT PRIMARY KEY,
    revenue DECIMAL(10,1),
    cogs DECIMAL(10,1),
    inventories DECIMAL(10,1),
    receivables DECIMAL(10,1),
    payables DECIMAL(10,1)
);

-- Step 2: Load in the data
-- Loading Kerry Group's three years of data
-- 2023's cogs is entered as NULL (genuinely missing) rather than 0 (which would falsely imply zero cost)

INSERT INTO kerry_financials (year, revenue, cogs, inventories, receivables, payables)
VALUES
(2023, 6974.9, NULL, 1100.2, 1279.0, 1773.1),
(2024, 6929.1, 3361.1, 1050.7, 1235.5, 1742.5),
(2025, 6757.6, 3263.7, 958.9, 1280.6, 1486.6);

-- Step 3: Confirm it loaded

SELECT * FROM kerry_financials;

-- Step 4: Calculate the KPIs
-- Same four KPIs as Glanbia, now for Kerry Group
-- 2023 will show blank for inventory_days, dpo, and cash_conversion_cycle (all need cogs, which is missing)
-- DSO still calculates for 2023 since it only needs revenue and receivables

SELECT
    year,
    ROUND((inventories / cogs) * 365, 1)                                    AS inventory_days,
    ROUND((receivables / revenue) * 365, 1)                                 AS dso,
    ROUND((payables / cogs) * 365, 1)                                       AS dpo,
    ROUND((inventories / cogs) * 365
        + (receivables / revenue) * 365
        - (payables / cogs) * 365, 1)                                       AS cash_conversion_cycle
FROM kerry_financials;