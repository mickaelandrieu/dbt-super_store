SELECT
    Row_ID AS order_unique_id,
    Order_ID AS order_id,

    CONCAT('CUST-', TO_BASE64(SHA256(CONCAT(Customer_Name, Region, Province)))) as customer_id,
    Customer_Name as customer_name,
    Province as province,
    Region as region,
    Customer_Segment as segment,

    Product_Name as product,
    Product_Category as category,
    Product_Sub_Category as sub_category,

    CAST(REGEXP_REPLACE(Sales, ",", ".") AS FLOAT64) as sales,
    CAST(REGEXP_REPLACE(Profit, ",", ".") AS FLOAT64) as profit,
    CAST(REGEXP_REPLACE(Discount, ",", ".") AS FLOAT64) as discount,
    CAST(Order_Quantity AS INT64) as order_quantity,
    CAST(REGEXP_REPLACE(Unit_Price, ",", ".") AS FLOAT64) as unit_price,
    CAST(REGEXP_REPLACE(Product_Base_Margin, ",", ".") AS FLOAT64) as product_base_margin,

    CAST(REGEXP_REPLACE(Shipping_Cost, ",", ".")  AS FLOAT64) as shipping_cost,
    Ship_Mode as shipping_mode,

    Product_Container as product_container,
    PARSE_DATE('%d/%m/%Y', Ship_Date) as shipped_at,
    Order_Priority as order_priority

FROM {{ source('super_store', 'Orders')}}
