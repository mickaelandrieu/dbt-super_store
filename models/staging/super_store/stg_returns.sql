SELECT
    Order_ID as order_id,
    Status as status
    
FROM
    {{ source('super_store', 'Returns')}}
