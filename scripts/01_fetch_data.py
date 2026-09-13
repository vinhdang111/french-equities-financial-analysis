"""
Step 1: Collect raw financial data for ~50 of the largest companies on the French
stock exchange (CAC 40 + a few SBF 120 names), last ~4 years, via the yfinance library.

Output:
    data_raw/companies.csv           -> basic company info
    data_raw/income_statement.csv    -> income statement (annual, ~4 years)
    data_raw/balance_sheet.csv       -> balance sheet (annual, ~4 years)
    data_raw/cash_flow.csv           -> cash flow statement (annual, ~4 years)

Notes:
- yfinance only returns roughly 4 years of financial statement history — this is a
  limitation of the API, not of this script.
- A few tickers may fail because the company was recently merged, renamed, or
  delisted (e.g. Suez, Vivendi's 2024 split) -> the script logs these and continues
  instead of stopping.
- Run this in a Jupyter Notebook or a terminal with internet access. It will NOT
  work in a sandboxed environment without access to Yahoo Finance.
"""

import time
import os
import pandas as pd
import yfinance as yf

# ------------------------------------------------------------------
# ~50 CAC 40 / SBF 120 companies (tickers as used by Yahoo Finance)
# Double-check the current CAC 40 / SBF 120 constituent list before running,
# since index composition changes over time.
# ------------------------------------------------------------------
TICKERS = {
    "AC.PA": "Accor",
    "AI.PA": "Air Liquide",
    "AIR.PA": "Airbus",
    "ALO.PA": "Alstom",
    "MT.AS": "ArcelorMittal",
    "CS.PA": "AXA",
    "BNP.PA": "BNP Paribas",
    "EN.PA": "Bouygues",
    "CAP.PA": "Capgemini",
    "CA.PA": "Carrefour",
    "ACA.PA": "Credit Agricole",
    "BN.PA": "Danone",
    "DSY.PA": "Dassault Systemes",
    "EDEN.PA": "Edenred",
    "ENGI.PA": "Engie",
    "EL.PA": "EssilorLuxottica",
    "ERF.PA": "Eurofins Scientific",
    "RMS.PA": "Hermes",
    "KER.PA": "Kering",
    "OR.PA": "L'Oreal",
    "LR.PA": "Legrand",
    "MC.PA": "LVMH",
    "ML.PA": "Michelin",
    "ORA.PA": "Orange",
    "RI.PA": "Pernod Ricard",
    "PUB.PA": "Publicis",
    "RNO.PA": "Renault",
    "SAF.PA": "Safran",
    "SGO.PA": "Saint-Gobain",
    "SAN.PA": "Sanofi",
    "SU.PA": "Schneider Electric",
    "GLE.PA": "Societe Generale",
    "STLAP.PA": "Stellantis",
    "STMPA.PA": "STMicroelectronics",
    "TEP.PA": "Teleperformance",
    "HO.PA": "Thales",
    "TTE.PA": "TotalEnergies",
    "URW.AS": "Unibail-Rodamco-Westfield",
    "VIE.PA": "Veolia",
    "DG.PA": "Vinci",
    "VIV.PA": "Vivendi",
    "WLN.PA": "Worldline",
    "ATO.PA": "Atos",
    "BVI.PA": "Bureau Veritas",
    "SW.PA": "Sodexo",
    "FR.PA": "Valeo",
    "GET.PA": "Getlink",
    "ELIS.PA": "Elis",
    "RXL.PA": "Rexel",
    "SPIE.PA": "SPIE",
    "IPN.PA": "Ipsen",
}

OUTPUT_DIR = "data_raw"
SLEEP_BETWEEN_CALLS = 1.5  # seconds, to avoid Yahoo Finance rate-limiting


def fetch_company_data(ticker: str, company_name: str):
    """Fetch info + 3 annual financial statements for one company. Returns dict of DataFrames."""
    stock = yf.Ticker(ticker)

    info = stock.info or {}
    company_row = {
        "ticker": ticker,
        "company_name": company_name,
        "sector": info.get("sector"),
        "industry": info.get("industry"),
        "country": info.get("country"),
        "currency": info.get("currency"),
        "market_cap": info.get("marketCap"),
    }

    def _prep(df: pd.DataFrame, statement_name: str) -> pd.DataFrame:
        if df is None or df.empty:
            return pd.DataFrame()
        df = df.T.reset_index().rename(columns={"index": "fiscal_year_end"})
        df.insert(0, "ticker", ticker)
        df.insert(1, "company_name", company_name)
        df.insert(2, "statement", statement_name)
        return df

    income = _prep(stock.get_income_stmt(freq="yearly"), "income_statement")
    balance = _prep(stock.get_balance_sheet(freq="yearly"), "balance_sheet")
    cashflow = _prep(stock.get_cash_flow(freq="yearly"), "cash_flow")

    return company_row, income, balance, cashflow


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    companies_rows = []
    income_list, balance_list, cashflow_list = [], [], []
    failed_tickers = []

    total = len(TICKERS)
    for i, (ticker, name) in enumerate(TICKERS.items(), start=1):
        print(f"[{i}/{total}] Fetching data for: {ticker} ({name})...")
        try:
            company_row, income, balance, cashflow = fetch_company_data(ticker, name)
            companies_rows.append(company_row)
            if not income.empty:
                income_list.append(income)
            if not balance.empty:
                balance_list.append(balance)
            if not cashflow.empty:
                cashflow_list.append(cashflow)
        except Exception as e:
            print(f"    -> ERROR for {ticker}: {e}")
            failed_tickers.append((ticker, str(e)))

        time.sleep(SLEEP_BETWEEN_CALLS)

    # Write output files
    pd.DataFrame(companies_rows).to_csv(f"{OUTPUT_DIR}/companies.csv", index=False)

    if income_list:
        pd.concat(income_list, ignore_index=True).to_csv(
            f"{OUTPUT_DIR}/income_statement.csv", index=False
        )
    if balance_list:
        pd.concat(balance_list, ignore_index=True).to_csv(
            f"{OUTPUT_DIR}/balance_sheet.csv", index=False
        )
    if cashflow_list:
        pd.concat(cashflow_list, ignore_index=True).to_csv(
            f"{OUTPUT_DIR}/cash_flow.csv", index=False
        )

    print(f"\nDone. Data saved to '{OUTPUT_DIR}/' folder.")
    print(f"Success: {total - len(failed_tickers)}/{total} companies.")
    if failed_tickers:
        print("Tickers that failed (check ticker symbol or recent delisting/merger):")
        for t, err in failed_tickers:
            print(f"  - {t}: {err}")


if __name__ == "__main__":
    main()
