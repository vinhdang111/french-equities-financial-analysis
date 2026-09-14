-- load_and_clean.sql

-- INCOME STATEMENT: select core metrics, filter out empty artifact rows

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


-- BALANCE SHEET: select core metrics, filter out empty artifact rows

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


-- CASH FLOW: select core metrics, filter out empty artifact rows

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

