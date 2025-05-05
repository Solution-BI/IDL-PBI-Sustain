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
    and q.code in ('ID.004', 'ID.009','ID.022','ID.023','ID.025','ID.026','ID.027','ID.029')
), site_information_formatted_pivotted as (
    select 
        site_id,
        INITCAP(vertical) as vertical,
        INITCAP(temperature) as temperature,
        INITCAP(construction_type) as construction_type,
        INITCAP(environment_certification) as environment_certification,
        INITCAP(security_building_class) as security_building_class,
        INITCAP(performance_certificate_energy) as performance_certificate_energy,
        INITCAP(type_of_operation) as type_of_operation
    from site_information_formatted
        pivot(max(value) for code in ('ID.004', 'ID.009','ID.022','ID.023','ID.025','ID.026','ID.029')) 
        as p (site_id, vertical, temperature, construction_type, environment_certification, security_building_class, performance_certificate_energy, type_of_operation)
), site_information as (
    select 
        site_id, 
        q.code,
        answer_value 
     from {{ ref('fact_answers') }} fa
     left join {{ source('DWH_SUSTAIN_ID', 'QUESTION') }} q on q.id = fa.question_id
     where 1=1 
     and q.code in ('ID.001','ID.002','ID.005', 'ID.006','ID.019','ID.020','ID.021','ID.024','ID.028','ID.007','ID.008','ID.027')
), site_information_pivotted as (
    select 
        site_id,
        code_site as code_site,
        code_sap as code_sap,
        INITCAP(main_activity) as main_activity,
        INITCAP(secondary_activity) as secondary_activity,
        INITCAP(energy_management_device) as energy_management_device,
        INITCAP(energy_storage) as energy_storage,
        INITCAP(presence_generator) as presence_generator,
        INITCAP(site_in_env_risk_zone) as site_in_env_risk_zone,
        INITCAP(intramural_canteen) as intramural_canteen,
        TO_DATE(date_site_opened_idl) as date_site_opened_idl,
        TO_DATE(date_site_built) as date_site_built,
        TO_DATE(date_last_cid_audit) as date_last_cid_audit
    from site_information
        pivot(max(answer_value) for code in ('ID.001','ID.002','ID.005', 'ID.006','ID.019','ID.020','ID.021','ID.024','ID.028','ID.007','ID.008','ID.027')) 
            as p (site_id, code_site, code_sap, main_activity, secondary_activity, energy_management_device, energy_storage, presence_generator, site_in_env_risk_zone, intramural_canteen, date_site_opened_idl, date_site_built, date_last_cid_audit  )
)
select 
    s.* EXCLUDE (CREATED_AT, UPDATED_AT, DELETED_AT, CREATED_BY, UPDATED_BY, DELETED_BY),
    -----sip.site_id,
    sip.code_site,
    sip.code_sap,
    sifp.vertical,
    sip.main_activity,
    sip.secondary_activity,
    sifp.temperature,
    sip.energy_management_device,
    sip.energy_storage,
    sip.presence_generator,
    sip.site_in_env_risk_zone,
    sip.intramural_canteen,
    sifp.construction_type,
    sifp.environment_certification,
    sifp.security_building_class,
    sifp.performance_certificate_energy,
    sifp.type_of_operation,
    sip.date_site_opened_idl,
    sip.date_site_built,
    sip.date_last_cid_audit
from {{ source('DWH_SUSTAIN_ID', 'SITE') }} s
left join site_information_pivotted sip on s.id = sip.site_id
left JOIN site_information_formatted_pivotted sifp ON s.id = sifp.site_id  
where 1=1
and code_site is not null 
and code_sap is not null

