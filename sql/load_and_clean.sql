-- load_and_clean.sql
-- Populates the clean tables (defined in schema.sql) from the raw staging
-- tables you import directly from CSV via DB Browser's "Import Table from CSV".
--
-- BEFORE running this file:
-- 1. Run schema.sql first (creates the empty clean tables)
-- 2. Import the 4 CSVs via File > Import > Table from CSV, using these exact
--    staging table names:
--      companies.csv          -> companies            (already clean, load as-is)
--      income_statement.csv   -> income_statement_raw
--      balance_sheet.csv      -> balance_sheet_raw
--      cash_flow.csv          -> cash_flow_raw
--
-- Note: companies.csv doesn't need cleaning, so it's imported directly with its
-- final name "companies" - matching the table already created by schema.sql.
-- If DB Browser complains the table already exists, either drop the empty one
-- first (DROP TABLE companies;) then import, or import it as companies_import
-- and run: INSERT INTO companies SELECT * FROM companies_import;

-- ------------------------------------------------------------------
-- INCOME STATEMENT: select core metrics, filter out empty artifact rows
-- ------------------------------------------------------------------
INSERT INTO income_statement (
    ticker, fiscal_year_end, total_revenue, cost_of_revenue, gross_profit,
    operating_income, operating_expense, ebitda, ebit, pretax_income,
    tax_provision, interest_expense, net_income, basic_eps, diluted_eps
)
SELECT
    ticker,
    fiscal_year_end,
    TotalRevenue,
    CostOfRevenue,
    GrossProfit,
    OperatingIncome,
    OperatingExpense,
    EBITDA,
    EBIT,
    PretaxIncome,
    TaxProvision,
    InterestExpense,
    NetIncome,
    BasicEPS,
    DilutedEPS
FROM income_statement_raw
WHERE TotalRevenue IS NOT NULL;   -- drops the empty artifact year some companies have

-- ------------------------------------------------------------------
-- BALANCE SHEET: select core metrics, filter out empty artifact rows
-- ------------------------------------------------------------------
INSERT INTO balance_sheet (
    ticker, fiscal_year_end, total_assets, total_liabilities, stockholders_equity,
    common_stock_equity, retained_earnings, total_debt, net_debt,
    cash_and_equivalents, current_assets, current_liabilities, working_capital,
    inventory, accounts_receivable, accounts_payable
)
SELECT
    ticker,
    fiscal_year_end,
    TotalAssets,
    TotalLiabilitiesNetMinorityInterest,
    StockholdersEquity,
    CommonStockEquity,
    RetainedEarnings,
    TotalDebt,
    NetDebt,
    CashAndCashEquivalents,
    CurrentAssets,
    CurrentLiabilities,
    WorkingCapital,
    Inventory,
    AccountsReceivable,
    AccountsPayable
FROM balance_sheet_raw
WHERE TotalAssets IS NOT NULL;

-- ------------------------------------------------------------------
-- CASH FLOW: select core metrics, filter out empty artifact rows
-- ------------------------------------------------------------------
INSERT INTO cash_flow (
    ticker, fiscal_year_end, operating_cash_flow, investing_cash_flow,
    financing_cash_flow, free_cash_flow, capital_expenditure,
    cash_dividends_paid, depreciation_and_amortization,
    change_in_working_capital, end_cash_position, beginning_cash_position
)
SELECT
    ticker,
    fiscal_year_end,
    OperatingCashFlow,
    InvestingCashFlow,
    FinancingCashFlow,
    FreeCashFlow,
    CapitalExpenditure,
    CashDividendsPaid,
    DepreciationAndAmortization,
    ChangeInWorkingCapital,
    EndCashPosition,
    BeginningCashPosition
FROM cash_flow_raw
WHERE OperatingCashFlow IS NOT NULL;

-- ------------------------------------------------------------------
-- Quick sanity checks - run these after loading to confirm it worked
-- ------------------------------------------------------------------
-- SELECT COUNT(*) FROM companies;
-- SELECT COUNT(*) FROM income_statement;
-- SELECT COUNT(*) FROM balance_sheet;
-- SELECT COUNT(*) FROM cash_flow;
-- SELECT * FROM income_statement LIMIT 5;
