# French Equities FP&A Analysis

End-to-end financial analytics project covering ~50 major French-listed companies (CAC 40 / SBF 120). Built to practice the full FP&A / Financial Data Analyst workflow: data collection → SQL storage → Python analysis & forecasting → Power BI dashboard.

## Motivation

I'm building this project to combine my accounting/audit background (Big 4 assurance, CMA) with data analytics skills (Python, SQL, Power BI) as I move toward a career in Financial Data Analysis / FP&A. The goal is to simulate a realistic FP&A workflow end-to-end, using real financial data rather than a toy dataset.

## Tech Stack

- **Python** (pandas, yfinance, scikit-learn) — data collection, cleaning, and modeling
- **SQL** (SQLite) — schema design, data cleaning, and structured storage
- **Jupyter Notebook** — exploratory analysis, financial ratios, forecasting
- **Power BI** — interactive dashboard for cross-company comparison

## Repo Structure

| Folder | Contents |
|---|---|
| [`scripts/`](./scripts) | Standalone Python scripts (e.g. data collection from Yahoo Finance) |
| [`data/`](./data) | Raw and processed data files |
| [`sql/`](./sql) | Database schema and data-loading/cleaning scripts |
| [`notebooks/`](./notebooks) | Jupyter notebooks for cleaning, EDA, and forecasting |
| [`powerbi/`](./powerbi) | Power BI dashboard file and screenshots |

## Progress

- [x] **Step 1 — Data Collection**: Pulled ~4 years of annual income statement, balance sheet, and cash flow data for ~50 CAC 40 / SBF 120 companies via the `yfinance` API. See [`scripts/01_fetch_data.py`](./scripts/01_fetch_data.py).
- [x] **Step 2 — SQL Database**: Designed a normalized schema and loaded/cleaned the raw CSVs into SQLite entirely in SQL (no Python). See [`sql/schema.sql`](./sql/schema.sql) and [`sql/load_and_clean.sql`](./sql/load_and_clean.sql).
- [ ] **Step 3 — Data Cleaning & EDA**: Compute financial ratios (margins, ROE, ROA, etc.), explore cross-company trends.
- [ ] **Step 4 — Forecasting**: Pooled/panel regression model (scikit-learn) predicting next-year revenue growth from current-year financial ratios across all companies.
- [ ] **Step 5 — Power BI Dashboard**: Interactive dashboard with company comparison, trend, and model-insight views.

## Data Source & Design Decisions

- Financial data pulled from Yahoo Finance via the `yfinance` Python library.
- **Annual data only.** Quarterly data was initially considered to get more data points per company, but testing showed most French/EU-listed companies return 0 quarters of usable data via `yfinance`. This is because the EU Transparency Directive (amended in 2013) removed the mandatory quarterly reporting requirement that still applies to US-listed companies — most EU issuers now only publish annual and semi-annual reports. This is a real market/regulatory constraint, not a data-collection bug.
- **Forecasting approach**: because each company only has ~4 years of annual history — too few observations for a per-company time-series train/test split — the project uses a **pooled/panel regression** instead: one row per company-year (~150 rows across all companies), predicting next-year revenue growth from current-year financial ratios (margin, leverage, size, sector, etc.). This trades time-series depth for cross-sectional breadth, which is both more statistically sound given the data available and arguably more relevant to FP&A/investment-analysis use cases than forecasting a single company's revenue from 4 data points.
- **SQL schema design**: the raw `yfinance` output is very wide and sparse (income statement ~80 columns, balance sheet ~130, cash flow ~100), since it includes every possible US-GAAP line item even though French companies only report a subset. Rather than mirroring that structure, the SQL schema keeps only 10-15 core financial metrics per statement type — the ones actually needed for ratio analysis and modeling. Raw CSVs are first loaded into staging tables, then transformed into clean, normalized tables (`companies`, `income_statement`, `balance_sheet`, `cash_flow`) via `CREATE TABLE` + `INSERT INTO ... SELECT`, which also filters out empty artifact rows.
- Companies have different fiscal year-end dates, so calendar years shown may not align 1:1 across all companies.

## Key Findings

_To be added once analysis is complete._

## Dashboard Preview

_Screenshot/GIF to be added once the Power BI dashboard is built._

## How to Reproduce

```bash
pip install yfinance pandas
python scripts/01_fetch_data.py
```

This downloads raw annual financial data into `data/raw/`. Then, in DB Browser for SQLite (or any SQLite client):
1. Run `sql/schema.sql` to create the clean tables.
2. Import the 4 raw CSVs as staging tables (see comments in `sql/load_and_clean.sql` for exact table names).
3. Run `sql/load_and_clean.sql` to populate the clean tables.

## Author

Thanh Vinh Dang — [LinkedIn](https://www.linkedin.com/in/thanhvinhdang2001)
