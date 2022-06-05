SELECT
    customer_id,
    customer_name,
    DATE_DIFF(CURRENT_DATE(), MAX(shipped_at), DAY) AS recency,
    COUNT(order_id) AS frequency,
    CAST(ROUND(SUM(sales)) AS INT64) AS monetary,
    COUNT(DISTINCT product) as variety
FROM {{ ref('stg_orders') }}
GROUP BY customer_id, customer_name
