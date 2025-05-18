WITH last_transaction AS (
    -- Get the last transaction date for each account
    SELECT 
        t.account_id,
        MAX(t.transaction_date) AS last_txn_date
    FROM 
        savings_transaction t
    WHERE 
        t.transaction_type = 'deposit'  -- We focus on inflow transactions only
    GROUP BY 
        t.account_id
),
inactive_accounts AS (
    -- Identify accounts with no transactions in the last year (365 days)
    SELECT 
        p.id AS plan_id,
        p.owner_id,
        p.type,
        lt.last_txn_date,
        DATEDIFF(CURRENT_DATE, lt.last_txn_date) AS inactivity_days
    FROM 
        plans_plan p
    LEFT JOIN 
        last_transaction lt ON p.id = lt.account_id
    WHERE 
        lt.last_txn_date IS NULL 
        OR DATEDIFF(CURRENT_DATE, lt.last_txn_date) > 365
    UNION
    SELECT 
        s.id AS plan_id,
        s.owner_id,
        'Savings' AS type,
        lt.last_txn_date,
        DATEDIFF(CURRENT_DATE, lt.last_txn_date) AS inactivity_days
    FROM 
        savings_savingsaccount s
    LEFT JOIN 
        last_transaction lt ON s.id = lt.account_id
    WHERE 
        lt.last_txn_date IS NULL 
        OR DATEDIFF(CURRENT_DATE, lt.last_txn_date) > 365
)
SELECT 
    plan_id,
    owner_id,
    type,
    last_txn_date,
    inactivity_days
FROM 
    inactive_accounts
ORDER BY 
    inactivity_days DESC;
