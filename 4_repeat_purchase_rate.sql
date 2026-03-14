WITH purchase_count AS (
SELECT
customerkey,
COUNT(orderdate) AS total_orders
FROM cohort_analysis
GROUP BY customerkey
)

SELECT
COUNT(CASE WHEN total_orders = 1 THEN 1 END) AS one_time_customers,
COUNT(CASE WHEN total_orders > 1 THEN 1 END) AS repeat_customers,
ROUND(
100.0 * COUNT(CASE WHEN total_orders > 1 THEN 1 END) / COUNT(*),
2
) AS repeat_purchase_rate
FROM purchase_count;