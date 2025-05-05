with raw_answer as (
    select 
        a.* EXCLUDE (CREATED_AT, UPDATED_AT, DELETED_AT, CREATED_BY, UPDATED_BY, DELETED_BY),
        max(weight) over (partition by question_id) as max_weight,
        upper(concat(l.name, '_answer')) as translation,
        la.value
    from {{ source('DWH_SUSTAIN_ID', 'ANSWER') }} a
    join {{ source('DWH_SUSTAIN_ID', 'LANGUAGE_ANSWER') }} la on a.id = la.answer_id
    join {{ source('DWH_SUSTAIN_ID', 'LANGUAGE') }} l on la.language_id = l.id
)

select 
    *,
    from raw_answer
    pivot(max(value) for translation in (any))
    


