with source as (

    select * from {{ source('raw_data', 'paid_social_native') }}

),

renamed as (

    select
        string_field_0  as date,
        string_field_1  as campaign_name,
        string_field_2  as spend,
        string_field_3  as impressions,
        string_field_4  as clicks

    from source

    -- exclude the header row that was loaded as data
    where string_field_0 != 'date'

)

select * from renamed