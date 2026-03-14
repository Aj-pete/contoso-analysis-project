WITH customer_ltv AS (
SELECT customerkey,
fullname,
sum(total_net_revenue) AS total_ltv
FROM cohort_analysis 
GROUP BY 
customerkey,
fullname
), customer_percentile AS (
SELECT 
percentile_cont(0.25) WITHIN GROUP (ORDER BY total_ltv) AS ltv25th,
percentile_cont(0.75) WITHIN GROUP (ORDER BY total_ltv) AS ltv75th
FROM 
customer_ltv
), segment AS (
SELECT c.*,
CASE 
	WHEN c.total_ltv  < cp.ltv25th THEN '1-low value'
	WHEN c.total_ltv  <= cp.ltv75th THEN '2-medium value'
	ELSE '3-high value'
END AS customer_segment
FROM customer_ltv c,
customer_percentile cp
)
SELECT 
customer_segment,
sum(total_ltv) AS tltv,
count(customerkey) AS num_customer,
sum(total_ltv)/count(customerkey) AS avg_ltv
FROM segment 
GROUP BY customer_segment