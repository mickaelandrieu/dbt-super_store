{% set table = 'stg_orders' %}

DECLARE columns ARRAY<STRING>;
DECLARE query STRING;
SET columns = (
  WITH all_columns AS (
    SELECT column_name
    FROM `{{ database }}.{{ schema }}.INFORMATION_SCHEMA.COLUMNS`
    WHERE table_name = '{{ table }}'
  )
  SELECT ARRAY_AGG((column_name) ) AS columns
  FROM all_columns
);

SET query = (select STRING_AGG('(select count(distinct '||x||')  from `{{ database }}.{{ schema }}.{{ table }}`) '||x ) AS string_agg from unnest(columns) x );

EXECUTE IMMEDIATE (
"SELECT  "|| query
);
