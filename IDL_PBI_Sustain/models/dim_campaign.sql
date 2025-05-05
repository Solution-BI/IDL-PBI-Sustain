select 
    * EXCLUDE (CREATED_AT, UPDATED_AT, DELETED_AT, CREATED_BY, UPDATED_BY, DELETED_BY),
    {{ get_date_sid('END_DATE') }} AS END_DATE_ID,
    {{ get_date_sid('START_DATE') }} AS START_DATE_ID
from {{ source('DWH_SUSTAIN_ID', 'CAMPAIGN') }}


