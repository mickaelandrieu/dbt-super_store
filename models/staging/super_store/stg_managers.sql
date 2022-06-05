SELECT
    Manager as manager,
    Region as region
    
FROM
    {{ source('super_store', 'Users')}}
