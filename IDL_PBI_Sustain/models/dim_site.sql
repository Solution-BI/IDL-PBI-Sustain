with site_information_formatted as (
    select 
        site_id, 
        q.code, 
        value 
    from {{ ref('fact_answers') }} fa
    left join {{ source('DWH_SUSTAIN_ID', 'LANGUAGE_ANSWER') }} la on la.answer_id = fa.answer_id
    left join {{ source('DWH_SUSTAIN_ID', 'QUESTION') }} q on q.id = fa.question_id
    join {{ source('DWH_SUSTAIN_ID', 'LANGUAGE') }} l on la.language_id = l.id and l.id = 2
    where 1=1 
    -- and l.name like 'Fran%'
    and q.code in ('ID.004', 'ID.009')
), site_information_formatted_pivotted as (
    select 
        site_id,
        INITCAP(vertical) as vertical,
        INITCAP(temperature) as temperature
    from site_information_formatted
        pivot(max(value) for code in ('ID.004', 'ID.009')) as p (site_id, vertical, temperature)
), site_information as (
    select 
        site_id, 
        q.code,
        answer_value 
     from {{ ref('fact_answers') }} fa
     left join {{ source('DWH_SUSTAIN_ID', 'QUESTION') }} q on q.id = fa.question_id
     where 1=1 
     and q.code in ('ID.001','ID.002','ID.005', 'ID.006')
), site_information_pivotted as (
    select 
        site_id,
        code_site as code_site,
        code_sap as code_sap,
        INITCAP(main_activity) as main_activity,
        INITCAP(secondary_activity) as secondary_activity
    from site_information
        pivot(max(answer_value) for code in ('ID.001','ID.002','ID.005', 'ID.006')) as p (site_id, code_site, code_sap, main_activity, secondary_activity)
)
select 
    s.*,
    -----sip.site_id,
    sip.code_site,
    sip.code_sap,
    sifp.vertical,
    sip.main_activity,
    sip.secondary_activity,
    sifp.temperature
from {{ source('DWH_SUSTAIN_ID', 'SITE') }} s
left join site_information_pivotted sip on s.id = sip.site_id
left JOIN site_information_formatted_pivotted sifp ON s.id = sifp.site_id  
where 1=1
and code_site is not null 
and code_sap is not null

