with source as (

    select *
    from {{ ref('stg_paid_search') }}

),

parsed as (

    select
        date,
        campaign_name,

        -- Landing page: everything before the query string
        regexp_extract(campaign_name, r'^([^?]+)') as landing_page,

        -- UTM parameters
        regexp_extract(campaign_name, r'utm_source=([^&]+)')   as source,
        regexp_extract(campaign_name, r'utm_medium=([^&]+)')   as medium,
        regexp_extract(campaign_name, r'utm_campaign=([^&]+)') as utm_campaign,

        -- Campaign taxonomy split by '_'
        -- Expected structure:
        -- season_company_tactic_placement_objective_audience_cta
        split(regexp_extract(campaign_name, r'utm_campaign=([^&]+)'), '_')[safe_offset(0)] as season_code,
        split(regexp_extract(campaign_name, r'utm_campaign=([^&]+)'), '_')[safe_offset(1)] as company_code,
        split(regexp_extract(campaign_name, r'utm_campaign=([^&]+)'), '_')[safe_offset(2)] as tactic_code,
        split(regexp_extract(campaign_name, r'utm_campaign=([^&]+)'), '_')[safe_offset(3)] as placement_code,
        split(regexp_extract(campaign_name, r'utm_campaign=([^&]+)'), '_')[safe_offset(4)] as objective_code,
        split(regexp_extract(campaign_name, r'utm_campaign=([^&]+)'), '_')[safe_offset(5)] as audience_code,
        split(regexp_extract(campaign_name, r'utm_campaign=([^&]+)'), '_')[safe_offset(6)] as cta_code,

        spend,
        impressions,
        clicks

    from source

),

decoded as (

    select
        date,
        campaign_name,
        landing_page,
        source,
        medium,
        utm_campaign,

        -- ========================
        -- Season
        -- ========================
        season_code,
        case season_code
            when 'win24'  then 'Winter 2024'
            when 'spr25'  then 'Spring 2025'
            when 'sum25'  then 'Summer 2025'
            when 'fall25' then 'Fall 2025'
            when 'hol24'  then 'Holiday 2024'
            else season_code
        end as season,

        -- ========================
        -- Company
        -- ========================
        company_code,
        case company_code
            when 'osc'   then 'Oscorp Industries'
            when 'stark' then 'Stark Industries'
            when 'pym'   then 'Pym Technologies'
            when 'wdg'   then 'Wakanda Design Group'
            when 'f4'    then 'Future Foundation'
            when 'rox'   then 'Roxxon Energy Corp'
            else company_code
        end as company,

        -- ========================
        -- Tactic
        -- ========================
        tactic_code,
        case tactic_code
            when 'pds' then 'Paid Social'
            when 'ps'  then 'Paid Search'
            else tactic_code
        end as tactic,

        -- ========================
        -- Placement
        -- ========================
        placement_code,
        case placement_code
            when 'insta'  then 'Instagram App'
            when 'fbfeed' then 'Facebook Newsfeed'
            when 'story'  then 'Instagram/Facebook Stories'
            when 'reels'  then 'Instagram Reels'
            when 'audnet' then 'Audience Network'
            when 'brand'  then 'Branded Keywords'
            when 'nbrnd'  then 'Non-Brand/Generic Keywords'
            when 'shpng'  then 'Google Shopping'
            when 'ytube'  then 'YouTube Search/Ads'
            when 'local'  then 'Google Maps/Local Search'
            else placement_code
        end as placement,

        -- ========================
        -- Objective
        -- ========================
        objective_code,
        case objective_code
            when 'awar'  then 'Brand Awareness'
            when 'conv'  then 'Conversions/Sales'
            when 'retrg' then 'Retargeting'
            when 'vv'    then 'Video Views'
            else objective_code
        end as objective,

        -- ========================
        -- Audience
        -- ========================
        audience_code,
        case audience_code
            when 'supfan'             then 'Superfans/Hardcore Enthusiasts'
            when 'avenger'            then 'Avengers-aligned Interests'
            when 'stark_tech'         then 'Tech-heavy/Engineering Interests'
            when 'wakanda_tech'       then 'Advanced Science/Vibranium Interests'
            when 'multiverse_visitor' then 'General/Broad Reach'
            when 'hydra_loyalist'     then 'Competitive/Niche Segment'
            else audience_code
        end as audience,

        -- ========================
        -- CTA
        -- ========================
        cta_code,
        case cta_code
            when 'shop'      then 'Shop Now'
            when 'learn'     then 'Learn More'
            when 'get_offer' then 'Claim Offer'
            when 'subscribe' then 'Sign Up / Newsletter'
            when 'pre'       then 'Early Access / Pre-order'
            else cta_code
        end as cta,

        spend,
        impressions,
        clicks

    from parsed

)

select *
from decoded