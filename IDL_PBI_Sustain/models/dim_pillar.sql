with raw_pillar as (
    select 
        a.* EXCLUDE (CREATED_AT, UPDATED_AT, DELETED_AT, CREATED_BY, UPDATED_BY, DELETED_BY),
        upper(concat(l.name, '_pillar')) as translation,
        la.value
    from {{ source('DWH_SUSTAIN_ID', 'PILLAR') }} a
    join {{ source('DWH_SUSTAIN_ID', 'LANGUAGE_PILLAR') }} la on a.id = la.pillar_id
    join {{ source('DWH_SUSTAIN_ID', 'LANGUAGE') }} l on la.language_id = l.id
)

select 
    *,
    from raw_pillar
    pivot(max(value) for translation in (any))
    
