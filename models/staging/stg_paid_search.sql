with source as (

    select * from {{ source('raw_data', 'paid_search_native') }}

),

renamed as (

    select
        date,
        campaign_name,
        spend,
        impressions,
        clicks
    from source

)

select * from renamed