SELECT 
    u.id AS customer_id,
    u.name,
    DATE_PART('month', AGE(CURRENT_DATE, u.date_joined)) AS tenure_months,
    COUNT(s.id) AS total_transactions_count,
    SUM(s.transaction_value) AS total_transaction_value,
    ROUND(
        (SUM(s.transaction_value) / DATE_PART('month', AGE(CURRENT_DATE, u.date_joined))) 
        * 12 * 0.001, 2
    ) AS estimated_clv
FROM 
    users_customuser u
JOIN 
    savings_savingsaccount s ON s.user_id = u.id
GROUP BY 
    u.id, u.name, u.date_joined
ORDER BY 
    estimated_clv DESC;
