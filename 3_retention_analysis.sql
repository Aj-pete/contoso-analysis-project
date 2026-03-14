WITH customer_last_purchase AS (
	SELECT
		customerkey,
		fullname,
		orderdate,
		ROW_NUMBER() OVER (PARTITION BY customerkey ORDER BY orderdate DESC) AS row_num,
		first_purchasedate,
		cohort_year
	FROM
		cohort_analysis
), customergroup AS (
	SELECT
		customerkey,
		fullname,
		orderdate AS last_purchase_date,
		CASE
			WHEN orderdate < (SELECT MAX(orderdate) FROM sales) - INTERVAL '6 months' THEN 'Churned'
			ELSE 'Active'
		END AS customer_status,
		cohort_year
	FROM customer_last_purchase 
	WHERE row_num = 1
		AND first_purchasedate < (SELECT MAX(orderdate) FROM sales) - INTERVAL '6 months'
)
SELECT cohort_year,
customer_status,
count(customerkey) AS customernum,
sum(count(customerkey)) OVER() AS total_customers,
round(100 * count(customerkey)/sum(count(customerkey)) OVER(), 0) AS percentage
FROM customergroup
GROUP BY cohort_year, 
customer_status 