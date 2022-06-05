SELECT
    dim_rfm.customer_id,
    dim_rfm.customer_name,
    dim_rfm.recency,
    dim_rfm.frequency,
    dim_rfm.monetary,
    dim_rfm.variety,

    dim_rfm.rfm_score,
    dim_rfm.rfm,
    dim_rfm.segment

FROM
    {{ ref('dim_rfm') }} AS dim_rfm
