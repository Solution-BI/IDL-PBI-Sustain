select 
    *,
    max(weight) over (partition by question_id) as max_weight
from {{ source('DWH_SUSTAIN_ID', 'ANSWER') }}