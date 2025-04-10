with raw_question as (
    select 
        a.* EXCLUDE (CREATED_AT, UPDATED_AT, DELETED_AT, CREATED_BY, UPDATED_BY, DELETED_BY),
        upper(concat(l.name, '_question')) as translation,
        la.label
    from {{ source('DWH_SUSTAIN_ID', 'QUESTION') }} a
    join {{ source('DWH_SUSTAIN_ID', 'LANGUAGE_QUESTION') }} la on a.id = la.question_id
    join {{ source('DWH_SUSTAIN_ID', 'LANGUAGE') }} l on la.language_id = l.id
)

select 
    *,
    from raw_question
    pivot(max(label) for translation in (any))
    
