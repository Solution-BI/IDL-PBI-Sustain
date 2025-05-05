with raw_category as (
    select 
        a.* EXCLUDE (CREATED_AT, UPDATED_AT, DELETED_AT, CREATED_BY, UPDATED_BY, DELETED_BY),
        upper(concat(l.name, '_category')) as translation,
        la.value
    from {{ source('DWH_SUSTAIN_ID', 'CATEGORY') }} a
    join {{ source('DWH_SUSTAIN_ID', 'LANGUAGE_CATEGORY') }} la on a.id = la.category_id
    join {{ source('DWH_SUSTAIN_ID', 'LANGUAGE') }} l on la.language_id = l.id
)

select 
    *,
    from raw_category
    pivot(max(value) for translation in (any))

    
    
