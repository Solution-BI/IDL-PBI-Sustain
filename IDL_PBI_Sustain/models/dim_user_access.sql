
select 
    email,
    email_2,
    nom,
    group_country as responsability,
    function, 
    name as country 
from {{ source('DWH_SUSTAIN_ID','SUSTAIN_ID_ACCESS')}} s
full outer join {{source('DWH_SUSTAIN_ID', 'COUNTRY')}} c 
    on JAROWINKLER_SIMILARITY(s.country, c.name) > 90
where group_country like 'Country%'
and name is not null
union all
select 
    email,
    email_2,
    nom,
    group_country as responsability,
    function, 
    name as country 
from {{ source('DWH_SUSTAIN_ID','SUSTAIN_ID_ACCESS')}} s
full outer join {{source('DWH_SUSTAIN_ID', 'COUNTRY')}} c
where group_country like 'Group%'