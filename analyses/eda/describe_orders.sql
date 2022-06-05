{% set table = 'stg_orders' %}

DECLARE columns ARRAY<STRING>;
DECLARE query1, query2, query3, query4, query5, query6, query7 STRING;
SET columns = (
  WITH all_columns AS (
    SELECT column_name
    FROM `{{ database }}.{{ schema }}.INFORMATION_SCHEMA.COLUMNS`
    WHERE table_name = '{{ table }}' AND data_type IN ('INT64','FLOAT64')
  )
  SELECT ARRAY_AGG((column_name)) AS columns
  FROM all_columns
);

SET query1 = (select STRING_AGG('(select stddev( '||x||')  from `{{ database }}.{{ schema }}.{{ table }}`) '||x ) AS string_agg from unnest(columns) x );
SET query2 = (select STRING_AGG('(select avg( '||x||')  from `{{ database }}.{{ schema }}.{{ table }}`) '||x ) AS string_agg from unnest(columns) x );
SET query3 = (select STRING_AGG('(select PERCENTILE_CONT( '||x||', 0.5) over()  from `{{ database }}.{{ schema }}.{{ table }}` limit 1) '||x ) AS string_agg from unnest(columns) x );
SET query4 = (select STRING_AGG('(select PERCENTILE_CONT( '||x||', 0.25) over()  from `{{ database }}.{{ schema }}.{{ table }}` limit 1) '||x ) AS string_agg from unnest(columns) x );
SET query5 = (select STRING_AGG('(select PERCENTILE_CONT( '||x||', 0.75) over()  from `{{ database }}.{{ schema }}.{{ table }}` limit 1) '||x ) AS string_agg from unnest(columns) x );
SET query6 = (select STRING_AGG('(select max( '||x||')  from `{{ database }}.{{ schema }}.{{ table }}`) '||x ) AS string_agg from unnest(columns) x );
SET query7 = (select STRING_AGG('(select min( '||x||')  from `{{ database }}.{{ schema }}.{{ table }}`) '||x ) AS string_agg from unnest(columns) x );

EXECUTE IMMEDIATE (
"SELECT 'stddev' ,"|| query1 || " UNION ALL " ||
"SELECT 'mean'   ,"|| query2 || " UNION ALL " ||
"SELECT 'median' ,"|| query3 || " UNION ALL " ||
"SELECT '0.25' ,"|| query4 || " UNION ALL " ||
"SELECT '0.75' ,"|| query5 || " UNION ALL " ||
"SELECT 'max' ,"|| query6 || " UNION ALL " ||
"SELECT 'min' ,"|| query7
);