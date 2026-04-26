--=========================================================================================================================================================================
--                                         SOCIAL MEDIA AND USER BEHAVIOUR ANALYSIS
--=========================================================================================================================================================================
-- CREATING FIRST TABLE PLATFORM_STATISTICS_2026
--=========================================================================================================================================================================
CREATE TABLE platform_statistics_2026 (
  platform VARCHAR(MAX),
  monthly_active_users_billions FLOAT,
  year_over_year_growth_pct FLOAT,
  avg_daily_time_minutes INT,
  primary_age_group VARCHAR(MAX),
  primary_content_format VARCHAR(MAX),
  avg_engagement_rate_pct FLOAT,
  social_commerce_adoption_pct FLOAT,
  headquarters_country VARCHAR(MAX),
  founded_year INT,
  data_source VARCHAR(MAX)
);

--=========================================================================================================================================================================
--=========================================================================================================================================================================
--CREATING SECOND TABLE SOCIAL_MEDIA_USER_BEHAVIOR
CREATE TABLE social_media_user_behavior (
  user_id VARCHAR(255),
  age INT,
  age_group VARCHAR(255),
  gender VARCHAR(255),
  country VARCHAR(255),
  occupation VARCHAR(255),
  education_level VARCHAR(255),
  income_bracket VARCHAR(255),
  relationship_status VARCHAR(255),
  primary_platform VARCHAR(255),
  num_platforms_used INT,
  daily_screen_time_minutes INT,
  weekly_sessions INT,
  avg_session_duration_minutes FLOAT,
  preferred_content_type VARCHAR(255),
  primary_device VARCHAR(255),
  usage_purpose VARCHAR(255),
  posts_per_week INT,
  likes_per_day INT,
  comments_per_day INT,
  shares_per_week INT,
  followers_count INT,
  following_count INT,
  engagement_rate_pct FLOAT,
  video_consumption_daily_minutes INT,
  has_purchased_via_social BIT,
  follows_influencers BIT,
  ad_click_frequency VARCHAR(255),
  monthly_social_spending_usd FLOAT,
  uses_privacy_settings BIT,
  experienced_cyberbullying BIT,
  reports_fake_news_frequency VARCHAR(255),
  self_reported_mental_health_effect VARCHAR(255),
  sleep_hours_per_night FLOAT,
  addiction_level_1_to_10 INT,
  productivity_impact VARCHAR(255),
  platform_satisfaction VARCHAR(255),
  account_created_date DATE,
  account_age_years FLOAT,
  is_verified_account BIT,
  is_content_creator BIT,
  uses_ai_features BIT,
  daily_notifications INT,
  checks_phone_first_morning BIT,
  uses_screen_time_limits BIT
);

--=========================================================================================================================================================================
--=========================================================================================================================================================================
select
  top 5 *
from
  platform_statistics_2026;

select
  top 5 *
from
  social_media_user_behavior;

--=========================================================================================================================================================================
--=========================================================================================================================================================================
-- Q1 Count the total number of platform in platform_statistics_2026.
--=========================================================================================================================================================================
select
  COUNT(platform) as total_platform
from
  platform_statistics_2026;

--=========================================================================================================================================================================
-- Q2 Find the platform with highest monthly_active_users_billion.
--=========================================================================================================================================================================
SELECT
  top 1 platform,
  monthly_active_users_billions
from
  platform_statistics_2026
order by
  monthly_active_users_billions DESC;

--=========================================================================================================================================================================
-- Q3 Calculate average avg_daily_time_minutes across platforms.
--=========================================================================================================================================================================
SELECT
  AVG(avg_daily_time_minutes) as average_daily_time
FROM
  platform_statistics_2026;

--=========================================================================================================================================================================
-- Q4 Find platforms with year_over_year_growth_pct > 10 
--=========================================================================================================================================================================
select
  platform,
  year_over_year_growth_pct
from
  platform_statistics_2026
where
  year_over_year_growth_pct > 10;

--=========================================================================================================================================================================
-- Q5 Count platforms by primary_age_group.
--=========================================================================================================================================================================
SELECT
  primary_age_group,
  COUNT(platform) as total_platform
from
  platform_statistics_2026
group by
  primary_age_group
order by
  total_platform desc;

--=========================================================================================================================================================================
-- Q6 Find top 3 platforms by avg_engagement_rate_pct
--=========================================================================================================================================================================
SELECT
  top 3 platform,
  avg_engagement_rate_pct
from
  platform_statistics_2026
order by
  avg_engagement_rate_pct desc;

--=========================================================================================================================================================================
-- Q7 Count total users in social_media_user_behaviour.
--=========================================================================================================================================================================
SELECT
  count(*) as total_users
from
  social_media_user_behavior;

--=========================================================================================================================================================================
-- Q8 Find average time_spent_minutes_user_behaviour.
--=========================================================================================================================================================================
select
  AVG(daily_screen_time_minutes) as average_time_spent
from
  social_media_user_behavior;

--=========================================================================================================================================================================
-- Q9 List top 5 users with highest follower_count.
--=========================================================================================================================================================================
select
  top 5 user_id,
  followers_count
from
  social_media_user_behavior
order by
  followers_count desc;

--=========================================================================================================================================================================
-- Q10 Count users by country.
--=========================================================================================================================================================================
SELECT
  country,
  COUNT(user_id) as total_users
from
  social_media_user_behavior
group by
  country
order by
  total_users desc;

--=========================================================================================================================================================================
-- Q11 Find users where purchase_probability > 0.7.
--=========================================================================================================================================================================
select
  *
from
  social_media_user_behavior
where
  has_purchased_via_social = 1
  AND monthly_social_spending_usd > 0.7;

--=========================================================================================================================================================================
-- Q12 Count users with churn_risk = 1.
--=========================================================================================================================================================================
select
  COUNT(*) as churned_users
FROM
(
    select
      case
        when daily_screen_time_minutes < 30
        and monthly_social_spending_usd = 0 then 1
        else 0
      end as churn_risk
    from
      social_media_user_behavior
  ) t
where
  churn_risk = 1;

--=========================================================================================================================================================================
-- Q13 Find average satisfaction_score by platform.
--=========================================================================================================================================================================
SELECT
  primary_platform,
  AVG(
    case
      when platform_satisfaction = 'very satisfied' then 5
      when platform_satisfaction = 'satisfies' then 4
      when platform_satisfaction = 'neutral' then 3
      when platform_satisfaction = 'dissatisfies' then 2
      when platform_satisfaction = 'very dissatisfied' then 1
    end
  ) as avg_satisfaction_score
from
  social_media_user_behavior
group by
  primary_platform
order by
  avg_satisfaction_score desc;

--=========================================================================================================================================================================
-- Q14 Join both tables and comapre engagement metrics .
--=========================================================================================================================================================================
SELECT
  u.primary_platform,
  AVG(u.engagement_rate_pct) as user_avg_engagement,
  p.avg_engagement_rate_pct as platform_engagement,
  AVG(u.engagement_rate_pct) - p.avg_engagement_rate_pct as engagement_gap
from
  social_media_user_behavior u
  join platform_statistics_2026 p on u.primary_platform = p.platform
group by
  u.primary_platform,
  p.avg_engagement_rate_pct
order by
  engagement_gap desc;

--=========================================================================================================================================================================
-- Q15 Find platforms where user time_spent exceeds platform average.
--=========================================================================================================================================================================
SELECT
  u.primary_platform AS platform,
  AVG(CAST(u.daily_screen_time_minutes AS FLOAT)) AS user_avg_time,
  p.avg_daily_time_minutes AS platform_avg_time
FROM
  social_media_user_behavior u
  JOIN platform_statistics_2026 p ON u.primary_platform = p.platform
GROUP BY
  u.primary_platform,
  p.avg_daily_time_minutes
HAVING
  AVG(CAST(u.daily_screen_time_minutes AS FLOAT)) > p.avg_daily_time_minutes;

--=============================================================================================================================================================================================
--=============================================================================================================================================================================================


CREATE VIEW combined_view AS
SELECT 
    u.*,
    p.monthly_active_users_billions,
    p.avg_daily_time_minutes,
    p.avg_engagement_rate_pct,
    p.year_over_year_growth_pct
FROM social_media_user_behavior u
LEFT JOIN platform_statistics_2026 p 
    ON u.primary_platform = p.platform;

SELECT * FROM combined_view;