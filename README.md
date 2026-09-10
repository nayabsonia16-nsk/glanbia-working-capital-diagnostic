# Glanbia plc: Working Capital Diagnostic

A self-directed consulting-style analysis of Glanbia plc's working capital efficiency (2023-2025), built to practice
the diagnostic skillset used in business consulting graduate roles.

## Problem
Is Glanbia's working capital efficiency improving or deteriorating, and where is the cash opportunity?

## Method
- Sourced 3 years of financial data directly from Glanbia's published annual reports
- Built a SQL database (MySQL) and calculated four core KPIs: Inventory Turnover/Days, DSO, DPO, and Cash Conversion Cycle
- Benchmarked against sector peer Kerry Group
- Modelled three improvement scenarios
- Visualised findings in a 3-page Power BI dashboard

## Key Findings
- Glanbia's Cash Conversion Cycle worsened from **24.5 days (2023)** to **37.4 days (2025)**
- Glanbia collects payment from customers roughly **twice as fast** as Kerry Group (DSO benchmark)
- Returning DSO and Inventory Days to 2023 levels would free up an estimated **€404.7m** in cash

## Files in this repo
- `Glanbia_Working_Capital_Data.xlsx` - raw financial data
- `glanbia_sql_queries.sql` - all SQL analysis with commented KPI logic
- `Glanbia_Working_Capital_Dashboard.pbix` - Power BI dashboard
- `diagnostic_summary.md` - one-page written summary
- Dashboard screenshots

## Methodology Notes
See `diagnostic_summary.md` for data cleaning decisions and cross-company comparability caveats.
