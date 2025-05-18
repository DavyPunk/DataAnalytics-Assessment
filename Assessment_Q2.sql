WITH customer_transactions AS (
    SELECT 
        u.id AS customer_id,
        DATE_TRUNC('month', t.timestamp) AS txn_month,
        COUNT(t.id) AS monthly_txns
    FROM 
        users_customuser u
    JOIN 
        savings_savingsaccount s ON u.id = s.owner_id
    JOIN 
        savings_transaction t ON s.id = t.account_id
    GROUP BY 
        u.id, DATE_TRUNC('month', t.timestamp)
),
avg_txns_per_customer AS (
    SELECT 
        customer_id,
        AVG(monthly_txns) AS avg_txns_per_month
    FROM 
        customer_transactions
    GROUP BY 
        customer_id
),
categorized_customers AS (
    SELECT 
        customer_id,
        avg_txns_per_month,
        CASE
            WHEN avg_txns_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txns_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM 
        avg_txns_per_customer
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txns_per_month), 1) AS avg_transactions_per_month
FROM 
    categorized_customers
GROUP BY 
    frequency_category
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
