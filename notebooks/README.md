# notebooks/

Jupyter notebooks for data cleaning, exploratory analysis, and forecasting.

Suggested naming convention (keeps them in logical run order):
- `01_data_cleaning.ipynb` — load from SQL, handle missing values, standardize currency/units
- `02_financial_ratios_eda.ipynb` — compute KPIs (margins, ROE, ROA, etc.) and explore trends
- `03_revenue_forecast.ipynb` — forecasting models (regression / Prophet) and error comparison

Keep notebooks readable: use markdown cells to explain *why*, not just code comments.
