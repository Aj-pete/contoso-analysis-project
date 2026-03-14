CREATE VIEW cohort_analysis AS 
WITH customer_rev  AS (
SELECT 
s.customerkey,
s.orderdate,
sum(s.quantity * s.netprice * s.exchangerate) AS total_net_revenue,
count(s.orderkey) AS order_num,
max(c.countryfull) AS countryfull,
max(c.age) AS age,
max(c.givenname) AS givenname,
max(c.surname) AS surname
FROM sales s
LEFT JOIN customer c ON c.customerkey  = s.customerkey 
GROUP BY 
s.customerkey,
s.orderdate
)
SELECT 
customerkey,
orderdate,
countryfull,
age,
total_net_revenue,
concat(trim(givenname), ' ', trim(surname)) AS fullname,
min(cr.orderdate) OVER (PARTITION BY cr.customerkey) AS first_purchasedate,
EXTRACT(YEAR FROM min(cr.orderdate) OVER (PARTITION BY cr.customerkey)) AS cohort_year
FROM customer_rev cr
