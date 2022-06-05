SELECT
    customer_id,
    NTILE(5) OVER (
        ORDER BY recency DESC
    ) AS recency_score,
    NTILE(5) OVER (
        ORDER BY frequency
    ) AS frequency_score,
    NTILE(5) OVER (
        ORDER BY monetary
    ) AS monetary_score,
    
    NTILE(5) OVER (ORDER BY recency DESC) + NTILE(5) OVER (ORDER BY frequency) + NTILE(5) OVER (ORDER BY monetary) AS rfm_score,
    CONCAT(
        NTILE(5) OVER (ORDER BY recency DESC),
        NTILE(5) OVER (ORDER BY frequency),
        NTILE(5) OVER (ORDER BY monetary)
    ) AS rfm
FROM {{ ref('dim_rfm_basics') }}
