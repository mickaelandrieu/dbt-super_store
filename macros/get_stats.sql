{%- macro get_stats(table, column, over_column) -%}
SELECT 
    {{ over_column }},
    stat,
    AVG(min) AS min,
    AVG(q25) AS q25,
    AVG(median) AS median,
    AVG(q75) AS q75,
    AVG(max) AS max
FROM (
    SELECT
        {{ over_column }}, 
        '{{ column }}' AS stat,
        PERCENTILE_CONT({{ column }}, 0) OVER(partition by {{ over_column }}) AS min,
        PERCENTILE_CONT({{ column }}, 0.25) OVER(partition by {{ over_column }}) AS q25,
        PERCENTILE_CONT({{ column }}, 0.5) OVER(partition by {{ over_column }}) AS median,
        PERCENTILE_CONT({{ column }}, 0.75) OVER(partition by {{ over_column }}) AS q75,
        PERCENTILE_CONT({{ column }}, 1) OVER(partition by {{ over_column }}) AS max
    FROM `{{ database }}.{{ schema }}.{{ table }}` 
)
GROUP BY 1, 2
{%- endmacro -%}