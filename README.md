# French Equities FP&A Analysis

End-to-end financial analytics project covering ~50 major French-listed companies (CAC 40 / SBF 120). Built to practice the full FP&A / Financial Data Analyst workflow: data collection → SQL storage → Python analysis & forecasting → Power BI dashboard.

## Motivation

I'm building this project to combine my accounting/audit background (Big 4 assurance, CMA) with data analytics skills (Python, SQL, Power BI) as I move toward a career in Financial Data Analysis / FP&A. The goal is to simulate a realistic FP&A workflow end-to-end, using real financial data rather than a toy dataset.

## Tech Stack

- **Python** (pandas, yfinance) — data collection and cleaning
- **SQL** (SQLite) — structured storage for financial statement data
- **Jupyter Notebook** — exploratory analysis, financial ratios, forecasting
- **Power BI** — interactive dashboard for cross-company comparison

## Repo Structure

| Folder | Contents |
|---|---|
| [`scripts/`](./scripts) | Standalone Python scripts (e.g. data collection from Yahoo Finance) |
| [`data/`](./data) | Raw and processed data files |
| [`sql/`](./sql) | Database schema and data-loading scripts |
| [`notebooks/`](./notebooks) | Jupyter notebooks for cleaning, EDA, and forecasting |
| [`powerbi/`](./powerbi) | Power BI dashboard file and screenshots |

## Progress

- [x] **Step 1 — Data Collection**: Pulled ~4 years of income statement, balance sheet, and cash flow data for ~50 CAC 40 / SBF 120 companies via the `yfinance` API. See [`scripts/01_fetch_data.py`](./scripts/01_fetch_data.py).
- [ ] **Step 2 — SQL Database**: Design a normalized schema and load the raw CSVs into SQLite.
- [ ] **Step 3 — Data Cleaning & EDA**: Handle missing/misaligned fiscal years, compute financial ratios (margins, ROE, ROA, etc.), explore cross-company trends.
- [ ] **Step 4 — Forecasting**: Build and compare revenue/cost forecasting models.
- [ ] **Step 5 — Power BI Dashboard**: Interactive dashboard with company comparison, trend, and forecast views.

## Data Source & Notes

- Financial data pulled from Yahoo Finance via the `yfinance` Python library.
- `yfinance` only provides ~4 years of financial statement history; some companies show a partially empty oldest-year column due to API artifacts — this will be handled during the cleaning step.
- Companies have different fiscal year-end dates, so calendar years shown may not align 1:1 across all companies (e.g. 2021–2025 vs. 2022–2026).

## Key Findings

_To be added once analysis is complete._

## Dashboard Preview

_Screenshot/GIF to be added once the Power BI dashboard is built._

## How to Reproduce

```bash
pip install yfinance pandas
python scripts/01_fetch_data.py
```

This downloads raw financial data into `data/raw/`.

## Author

Thanh Vinh Dang — [LinkedIn](https://www.linkedin.com/in/thanhvinhdang2001)
