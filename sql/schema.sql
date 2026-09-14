
CREATE TABLE IF NOT EXISTS companies (
    ticker        TEXT PRIMARY KEY,
    company_name  TEXT NOT NULL,
    sector        TEXT,
    industry      TEXT,
    country       TEXT,
    currency      TEXT,
    market_cap    REAL
);

-- One row per company per fiscal year. Core income statement metrics only.
CREATE TABLE IF NOT EXISTS income_statement (
    ticker              TEXT NOT NULL,
    fiscal_year_end     TEXT NOT NULL,   -- stored as ISO date text, e.g. '2025-12-31'
    total_revenue       REAL,
    cost_of_revenue     REAL,
    gross_profit        REAL,
    operating_income    REAL,
    operating_expense   REAL,
    ebitda              REAL,
    ebit                REAL,
    pretax_income       REAL,
    tax_provision       REAL,
    interest_expense    REAL,
    net_income          REAL,
    basic_eps           REAL,
    diluted_eps         REAL,
    PRIMARY KEY (ticker, fiscal_year_end),
    FOREIGN KEY (ticker) REFERENCES companies(ticker)
);

-- One row per company per fiscal year. Core balance sheet metrics only.
CREATE TABLE IF NOT EXISTS balance_sheet (
    ticker                  TEXT NOT NULL,
    fiscal_year_end         TEXT NOT NULL,
    total_assets            REAL,
    total_liabilities       REAL,
    stockholders_equity     REAL,
    common_stock_equity     REAL,
    retained_earnings       REAL,
    total_debt              REAL,
    net_debt                REAL,
    cash_and_equivalents    REAL,
    current_assets          REAL,
    current_liabilities     REAL,
    working_capital         REAL,
    inventory               REAL,
    accounts_receivable     REAL,
    accounts_payable        REAL,
    PRIMARY KEY (ticker, fiscal_year_end),
    FOREIGN KEY (ticker) REFERENCES companies(ticker)
);

-- One row per company per fiscal year. Core cash flow metrics only.
CREATE TABLE IF NOT EXISTS cash_flow (
    ticker                      TEXT NOT NULL,
    fiscal_year_end             TEXT NOT NULL,
    operating_cash_flow         REAL,
    investing_cash_flow         REAL,
    financing_cash_flow         REAL,
    free_cash_flow              REAL,
    capital_expenditure         REAL,
    cash_dividends_paid         REAL,
    depreciation_and_amortization REAL,
    change_in_working_capital   REAL,
    end_cash_position           REAL,
    beginning_cash_position     REAL,
    PRIMARY KEY (ticker, fiscal_year_end),
    FOREIGN KEY (ticker) REFERENCES companies(ticker)
);
