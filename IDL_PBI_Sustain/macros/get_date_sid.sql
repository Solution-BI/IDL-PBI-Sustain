{% macro get_date_sid(my_date) %}
    CONCAT(year({{ my_date }})::varchar, 
    iff(len(month({{ my_date }})::varchar) = 2,month({{ my_date }})::varchar,concat('0',month({{ my_date }})::varchar))     
    ,iff(len(day({{ my_date }})::varchar) = 2,day({{ my_date }})::varchar,concat('0',day({{ my_date }})::varchar)))::int
{% endmacro %}
