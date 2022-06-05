SELECT
    customer_id,
    customer_name,
    MIN(ordered_at) AS first_order,
    MAX(ordered_at) AS last_order,
    DATE_DIFF(MAX(ordered_at), MIN(ordered_at), DAY) + 1 AS loyalty,
    ROUND(DATE_DIFF(MAX(ordered_at), MIN(ordered_at), DAY) / COUNT(order_id)) + 1 AS average_time_between_orders
FROM {{ ref('stg_orders') }}
GROUP BY customer_id, customer_name