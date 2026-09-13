# scripts/

Standalone Python scripts that aren't notebooks (e.g. data collection, ETL jobs
you want to run repeatedly rather than interactively).

- `01_fetch_data.py` — downloads ~4 years of financial statements for ~50 CAC 40 / SBF 120
  companies via `yfinance` and saves them to `data/raw/`.
