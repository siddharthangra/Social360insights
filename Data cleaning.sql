select * from information;

create table demo_clean as
select * from (
select * , row_number() over(partition by user_id, post_id, timestamp, platform order by post_id ) as num from information) as query
where num = 1;

select * from demo_clean;
alter table demo_clean drop column num;
select distinct language from demo_clean;

UPDATE demo_clean
SET language = Case language 
	when 'ru' then 'Russian'
    when 'fr' then 'French'
    when 'hi' then 'Hindi'
    when 'es' then 'Spanish'
    when 'de' then 'German'
    when 'ar' then 'Arabic'
    when 'ja' then 'japanese'
    when 'en' then 'English'
    when 'zh' then 'Chinese'
    when 'pt' then 'Portugese' 
    Else language
End;

select distinct location from demo_clean;

select location, 
trim(substring(location, 1, Position(',' in location) -1)) as city,
trim(substring(location, Position(',' in location) +1)) as country
from demo_clean;

alter table demo_clean
add column city varchar(100),
add column country varchar(100);

update demo_clean
set city = trim(substring(location, 1, Position(',' in location) -1));
update demo_clean
set country = trim(substring(location, position(',' in location)+1));
Alter table demo_clean drop column location;

update demo_clean
set city = "Singapore"
where city = "";

select * from demo_clean where topic_category = "";

update demo_clean
set mentions = "no mentions"
where mentions = "";

select * from demo_clean;

alter table demo_clean
add column month varchar(20),
add column hour int; 

update demo_clean
set month = date_format(timestamp, '%b-%y'),
hour = hour(timestamp);

select month, hour from demo_clean;

alter table demo_clean drop column timestamp;

select * from demo_clean where likes_count < 0 OR shares_count<0 OR comments_count < 0;
select * from demo_clean;

select distinct mentions from demo_clean;
with recursive unique_mentions as 
(
	Select 
    trim(substring_index(mentions, ',',1)) as mention,
    substring(mentions, length(substring_index(mentions,',',1))+2) as rest
    from demo_clean
    where mentions != "no mentions"
    
    Union all
    
    Select
    trim(substring_index(rest, ',',1)) as mention,
    substring(rest, length(substring_index(rest,',',1))+2) as rest
    from unique_mentions
    where rest != ''
)
select distinct mention from unique_mentions;

select distinct brand_name from demo_clean;

select distinct campaign_name from demo_clean where brand_name = "Apple";

select * from demo_clean;

update demo_clean
set engagement_rate = round(engagement_rate*100,2),
	user_engagement_growth = round(user_engagement_growth*100,2);
    
update demo_clean
set toxicity_score = round(toxicity_score*100,2);

select engagement_rate, user_engagement_growth from demo_clean;

select timestamp,platform, brand_name as Brand, product_name as Product, campaign_name as Campaign,
	campaign_phase, month, hour, city, country, language, keywords, topic_category, sentiment_score, 
    sentiment_label, emotion_type, toxicity_score, likes_count, shares_count, comments_count, impressions, 
    engagement_rate, user_past_sentiment_avg, user_engagement_growth, buzz_change_rate, hashtags
from demo_clean;

select buzz_change_rate from demo_clean where buzz_change_rate < -100;

select campaign_name, campaign_phase from demo_clean where campaign_name = "FallCollection";

select distinct city from demo_clean where country = "China";

select distinct campaign_name from demo_clean where brand_name = "Apple" order by campaign_name;
