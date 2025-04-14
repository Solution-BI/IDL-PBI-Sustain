select 
    country.id as country_id,
    s.id as site_id,
    c.id as campaign_id,
    cs.id as campaign_site_id,
    p.id as pillar_id,
    t.id as theme_id,
    ct.id as category_id,
    q.id as question_id,
    (case 
        when q.type = 'YES_NO' then iff(cast(ae.other_answer as boolean) is not null,ae.other_answer,null)
        when q.type = 'NUMERIC' then 
            iff(try_cast(regexp_replace(ae.other_answer,'\\W+|²+|[\\D+]','') as number) is not null,
                regexp_replace(ae.other_answer,'\\W+|²+|[\\D+]',''),null)
        when q.type = 'DATE' then iff(cast(ae.other_answer as date) is not null, ae.other_answer,null)
        else iff(cast(ae.other_answer as text) is not null,ae.other_answer,null)
    end)::varchar as answer_value,
    a.id as answer_id,
    a.weight
from {{ source('DWH_SUSTAIN_ID', 'EVALUATION') }} e
left join {{ source('DWH_SUSTAIN_ID', 'CAMPAIGN_SITE') }} cs on e.campaign_site_id = cs.id
left join {{ source('DWH_SUSTAIN_ID', 'CAMPAIGN') }} c on cs.campaign_id = c.id
left join {{ source('DWH_SUSTAIN_ID', 'SITE') }} s on cs.site_id = s.id
left join {{ source('DWH_SUSTAIN_ID', 'COUNTRY') }} country on country.id = s.country_id
left join {{ source('DWH_SUSTAIN_ID', 'ANSWER_EVALUATION') }} ae on ae.evaluation_id = e.id
left join {{ source('DWH_SUSTAIN_ID', 'ANSWER') }} a on ae.answer_id = a.id
left join {{ source('DWH_SUSTAIN_ID', 'QUESTION') }} q on e.question_id = q.id
left join {{ source('DWH_SUSTAIN_ID', 'THEME') }} t on q.theme_id = t.id
left join {{ source('DWH_SUSTAIN_ID', 'PILLAR') }} p on t.pillar_id = p.id
left join {{ source('DWH_SUSTAIN_ID', 'CATEGORY') }} ct on q.category_id = ct.id
where 1=1
and cs.id is not null
group by all