SELECT 
cohort_year,
count(DISTINCT customerkey) AS total_customers,
sum(total_net_revenue) AS total_rev,
sum(total_net_revenue)/count(DISTINCT customerkey) AS customer_rev
FROM cohort_analysis
GROUP BY 
cohort_year;
--adjusted query to look at revenue for that cohort year if purchase was done on the first day becuase majority of purchases were done on the first day
SELECT 
cohort_year,
count(DISTINCT customerkey) AS total_customers,
sum(total_net_revenue) AS total_rev,
sum(total_net_revenue)/count(DISTINCT customerkey) AS customer_rev
FROM cohort_analysis
WHERE orderdate= first_purchasedate
GROUP BY 
cohort_year;
--investigate monthly revenue and customer trend to see why customers are spending less over time
SELECT
date_trunc('month',ca.orderdate)::date AS year_month,
sum(total_net_revenue) AS total_rev,
count(DISTINCT customerkey) AS total_customers,
sum(total_net_revenue)/count(DISTINCT customerkey) AS customer_rev
FROM cohort_analysis ca
GROUP BY 
 year_month
 ORDER BY
 year_month;