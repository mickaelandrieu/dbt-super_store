SELECT
    dim_rfm_basics.customer_id,
    dim_rfm_basics.recency,
    dim_rfm_basics.frequency,
    dim_rfm_basics.monetary,
    dim_rfm_basics.variety,

    dim_rfm_scoring.rfm_score,
    dim_rfm_scoring.rfm,
    dim_rfm_segments.segment

FROM
    {{ ref('dim_rfm_basics') }}
INNER JOIN
    {{ ref('dim_rfm_scoring') }}
ON dim_rfm_basics.customer_id = dim_rfm_scoring.customer_id
INNER JOIN
    {{ ref('dim_rfm_segments') }}
ON dim_rfm_scoring.customer_id = dim_rfm_segments.customer_id
