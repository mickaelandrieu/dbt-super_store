{% set table = 'stg_orders' %}

DECLARE columns ARRAY<STRING>;
DECLARE query STRING DEFAULT '';
DECLARE counter INT64 DEFAULT 0;

SET columns = (
  WITH all_columns AS (
    SELECT column_name
    FROM `{{ database }}.{{ schema }}.INFORMATION_SCHEMA.COLUMNS`
    WHERE table_name = 'stg_orders' 
  )
  SELECT ARRAY_AGG((column_name) ) AS columns
  FROM all_columns
);

LOOP
    SET counter = counter + 1;

    IF counter > ARRAY_LENGTH(columns) THEN 
        LEAVE;
    END IF;
 
    SET query = ' DELETE FROM  `{{ database }}.{{ schema }}.{{ table }}` WHERE ' || columns[ORDINAL(counter)] || ' is null '  ;
    EXECUTE IMMEDIATE (
        query
    );

END LOOP;
