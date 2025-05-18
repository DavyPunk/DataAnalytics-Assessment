WITH savings AS (
    SELECT 
        owner_id,
        COUNT(*) AS savings_count,
        SUM(balance) AS savings_total
    FROM 
        savings_savingsaccount
    WHERE 
        status = 'funded'
    GROUP BY 
        owner_id
),
investments AS (
    SELECT 
        owner_id,
        COUNT(*) AS investment_count,
        SUM(balance) AS investment_total
    FROM 
        plans_plan
    WHERE 
        status = 'funded' AND type = 'investment'
    GROUP BY 
        owner_id
)
SELECT 
    u.id AS owner_id,
    u.name,
    s.savings_count,
    i.investment_count,
    ROUND(COALESCE(s.savings_total, 0) + COALESCE(i.investment_total, 0), 2) AS total_deposits
FROM 
    users_customuser u
JOIN 
    savings s ON u.id = s.owner_id
JOIN 
    investments i ON u.id = i.owner_id
ORDER BY 
    total_deposits DESC;
