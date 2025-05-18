# DataAnalytics-Assessment

1. To identify high-value customers who:

Have at least one funded savings account, AND

At least one funded investment plan (assuming "funded" means there's a positive balance or deposit),

And return the total deposits across those accounts,

Here's the SQL query to achieve that.

Assumptions (based on common schema practices):
users_customuser:

id = customer ID

name

savings_savingsaccount:

user_id = FK to users_customuser.id

balance or deposit_amount indicates funding

plans_plan:

user_id = FK to users_customuser.id

plan_type or similar (to distinguish investment plans if needed)

balance or deposit_amount for funding




2. To calculate the average number of transactions per customer per month and categorize them into frequency buckets using the tables users_customuser and savings_savingsaccount, I will typically follow these steps using SQL (assuming a relational database like PostgreSQL or MySQL):

Assumptions:
savings_savingsaccount contains a record for each transaction.

It has a user_id to relate to users_customuser.

There’s a created_at or similar timestamp field to track transaction date.

users_customuser.id is the primary key.


Step-by-Step Calculation Logic:
Count total transactions per customer.

Calculate active months for each customer based on their first and last transaction.

Compute average transactions per month.

Categorize customers based on average transactions per month.

Group by frequency category and count customers.



3. To find active accounts with no inflow transactions in the last 1 year, I will follow this logic:

Assumptions:
Table plans_plan holds all plan accounts (both savings and investments).

Has fields: id (plan_id), owner_id, and type (e.g., "Savings", "Investment").

Table savings_savingsaccount (possibly misnamed and should actually be something like transactions) stores transactions.

Has fields: plan_id, transaction_type, amount, created_at.

I am assuming inflows are identified by transaction_type = 'inflow'.



4.To estimate Customer Lifetime Value (CLV) using a simplified model, I will follow the logic provided:

 Assumptions:
users_customuser contains:

id (as customer_id)

name

date_joined (for calculating tenure)

savings_savingsaccount contains:

user_id (foreign key to users_customuser)

amount (transaction amount)

created_at (timestamp of transaction)

Profit per transaction is 0.1% of the transaction amount
→ i.e., amount * 0.001

CLV formula:

CLV
=
(
total_transactions
tenure_months
)
×
12
×
avg_profit_per_transaction
CLV=( 
tenure_months
total_transactions
​
 )×12×avg_profit_per_transaction

 Notes:

I use GREATEST(tenure_months, 1) to avoid division by zero.

I can add filters (e.g., active users only) if needed.

I may also want to cast AVG to numeric for precise rounding.
