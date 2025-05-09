with raw_theme as (
    select 
        a.* EXCLUDE (CREATED_AT, UPDATED_AT, DELETED_AT, CREATED_BY, UPDATED_BY, DELETED_BY),
        upper(concat(l.name, '_theme')) as translation,
        la.value
    from {{ source('DWH_SUSTAIN_ID', 'THEME') }} a
    join {{ source('DWH_SUSTAIN_ID', 'LANGUAGE_THEME') }} la on a.id = la.theme_id
    join {{ source('DWH_SUSTAIN_ID', 'LANGUAGE') }} l on la.language_id = l.id
)

select 
    *,
    from raw_theme
    pivot(max(value) for translation in (any))
    


