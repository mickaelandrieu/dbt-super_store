DECLARE columns ARRAY<STRING>;
DECLARE query STRING DEFAULT '';
DECLARE i,j INT64 DEFAULT 0;

SET columns = (
  WITH all_columns AS (
    SELECT column_name
    FROM `your-client.staging.INFORMATION_SCHEMA.COLUMNS`
    WHERE table_name = 'churn' 
        and column_name not in ('RowNumber', 'CustomerId', 'Surname')
        and  data_type IN ('INT64','FLOAT64')
  )
  SELECT ARRAY_AGG((column_name) ) AS columns
  FROM all_columns
);

LOOP
    SET i = i + 1;

    IF i > ARRAY_LENGTH(columns) THEN 
        LEAVE;
    END IF;

    IF i > 1 THEN 
        SET query = query || ' UNION ALL ';
    END IF;
        SET query = query || ' SELECT '|| i || ","||"'"||columns[ORDINAL(i)]|| "'" ;
        
        LOOP
            SET j = j + 1;

            IF j > ARRAY_LENGTH(columns) THEN 
                LEAVE;
            END IF;
 
            SET query = query || ' , round(corr('|| columns[ORDINAL(i)] ||','|| columns[ORDINAL(j)] ||'),4)  as ' ||" "||columns[ORDINAL(j)]|| " "  ;
        END LOOP;
        SET query = query || ' FROM  `your-client.staging.churn` ' ;
        SET j = 0;
    

END LOOP;

--select query;


EXECUTE IMMEDIATE (
        query || " order by 1;"
    );