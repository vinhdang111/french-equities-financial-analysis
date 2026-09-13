# data/

Holds the project's data files. **Raw source files only in `raw/`** — never overwrite them.
Cleaned/transformed outputs go in `processed/`.

- `raw/` — untouched CSVs downloaded directly from Yahoo Finance (via `scripts/01_fetch_data.py`).
- `processed/` — cleaned data after the Jupyter cleaning/EDA notebook (ready for SQL load or Power BI).

> Note: if the raw/processed CSVs are large, consider adding `data/raw/*.csv` to `.gitignore`
> and just documenting how to regenerate them, rather than committing large data files to GitHub.
