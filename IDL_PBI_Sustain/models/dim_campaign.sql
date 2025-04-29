select 
    *,
    {{ get_date_sid('END_DATE') }} AS END_DATE_ID,
    {{ get_date_sid('START_DATE') }} AS START_DATE_ID
from {{ source('DWH_SUSTAIN_ID', 'CAMPAIGN') }}