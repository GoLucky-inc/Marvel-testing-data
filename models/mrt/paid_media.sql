with paid_search as (

    select *
    from {{ ref('clean_paid_search') }}

),

paid_social as (

    select *
    from {{ ref('clean_paid_social') }}

),

combined as (

    select
        date,
        campaign_name,
        landing_page,
        source,
        medium,
        utm_campaign,
        season_code,
        season,
        company_code,
        company,
        tactic_code,
        tactic,
        placement_code,
        placement,
        objective_code,
        objective,
        audience_code,
        audience,
        cta_code,
        cta,
        cast(spend as int64)        as spend,
        cast(impressions as int64)  as impressions,
        cast(clicks as int64)       as clicks
    from paid_search

    union all

    select
        date,
        campaign_name,
        landing_page,
        source,
        medium,
        utm_campaign,
        season_code,
        season,
        company_code,
        company,
        tactic_code,
        tactic,
        placement_code,
        placement,
        objective_code,
        objective,
        audience_code,
        audience,
        cta_code,
        cta,
        cast(spend as int64)        as spend,
        cast(impressions as int64)  as impressions,
        cast(clicks as int64)       as clicks
    from paid_social

)

select *
from combined