
select * from corona_virus_dataset;
 -- 1)-Code for check null values
 
 select * from corona_virus_dataset
 where 'Province' is null
 or 'Country/Regi' is null
 or 'Latitude' is null
 or 'Longitude' is null
 or 'Date' is null
 or 'Confirmed' is null
 or 'Deaths' is null
 or ' Recovered' is null ;
 
 -- 2)- If null value are present,update them with zero for all columns
 
SET SQL_SAFE_UPDATES = 0;

UPDATE corona_virus_dataset
SET 
    Province = 0,
    `Country/Region` = 0,
    Latitude = 0,
    Longitude = 0,
    Date = 0,
    Confirmed = 0,
    Deaths = 0,
    Recovered = 0
WHERE 
    Province IS NULL OR
    `Country/Region` IS NULL OR
    Latitude IS NULL OR
    Longitude IS NULL OR
    Date IS NULL OR
    Confirmed IS NULL OR
    Deaths IS NULL OR
    Recovered IS NULL;

SET SQL_SAFE_UPDATES = 1;

 -- 3)-check total number of rows
 select count(*) from corona_virus_dataset;
 
 -- 4)- Check what is start_date start_date and end_date
SELECT 
    MIN(Date) AS start_date,
    MAX(Date) AS end_date
FROM 
    corona_virus_dataset;
    
-- 5)- Number of month present in dataset

select count(distinct extract(month from str_to_date(Date, '%d-%m-%y'))) as total_month 
from corona_virus_dataset;

-- 6)-Find monthly average for confirmed , deaths , recovered

SELECT 
    AVG(Confirmed) AS avg_confirmed,
    AVG(Deaths) AS avg_deaths,
    AVG(Recovered) AS avg_recovered,
	MONTH(STR_TO_DATE(Date, '%d-%m-%y')) AS month_number,
    MONTHNAME(STR_TO_DATE(Date, '%d-%m-%y')) AS month_name
FROM 
    corona_virus_dataset
GROUP BY 
    month_name , month_number
order by month_number;
    
-- 7)-Find most frequent value for confirmed,death,recovered each month
 
 SELECT 
	YEAR(STR_TO_DATE(Date, '%d-%m-%y')) AS year,
    MONTH(STR_TO_DATE(Date, '%d-%m-%y')) AS month_number,
    substring_index(group_concat(Confirmed ORDER BY Confirmed DESC), ',',1) as Most_frequent_confirmed,
	substring_index(group_concat(Deaths ORDER BY Deaths DESC), ',',1) as Most_frequent_Deaths,
	substring_index(group_concat(Recovered ORDER BY Recovered DESC), ',',1) as Most_frequent_Recovered
FROM 
    corona_virus_dataset
GROUP BY 
    month_number,year
order by month_number;

--  7)-minimum value of confirmed , death , recover per year

select min(Confirmed),min(Deaths),min(Recovered) from corona_virus_dataset
group by YEAR(STR_TO_DATE(Date, '%d-%m-%y')) 
order by YEAR(STR_TO_DATE(Date, '%d-%m-%y')) ;

-- 8)- maximum value of confirmed , death , recover per year

select max(Confirmed),max(Deaths),max(Recovered) from corona_virus_dataset
group by YEAR(STR_TO_DATE(Date, '%d-%m-%y')) 
order by YEAR(STR_TO_DATE(Date, '%d-%m-%y')) ;

-- 9)- total number of case confirmed , death , recover per month

select sum(Confirmed),sum(Deaths),sum(Recovered) from corona_virus_dataset
group by MONTH(STR_TO_DATE(Date, '%d-%m-%y')) 
order by MONTH(STR_TO_DATE(Date, '%d-%m-%y')) ;

-- 10)-  Check how corona virus spread out with respect to confirmed case
  --    (Eg.: total confirmed cases, their average, variance & STDEV )
  
  select  sum(Confirmed) as toatl_confirmed_case ,
  avg(Confirmed) as avg_confirmed_case , 
  variance(Confirmed) as varrince_confirmed_case, 
  stddev(Confirmed)  as std_confirmed_case
  from corona_virus_dataset;
  
  
  -- 11)- Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )

 select  MONTH(STR_TO_DATE(Date, '%d-%m-%y')) as month_num ,
 YEAR(STR_TO_DATE(Date, '%d-%m-%y')) as year_num,
 sum(Deaths) as toatl_death_case,
  avg(Deaths) as avg_death_case , 
  variance(Deaths) as varrince_death_case, 
  stddev(Deaths)  as std_death_case
  from corona_virus_dataset
  group by
         month_num , year_num
  order by 
        month_num , year_num;
  
  -- )Q13- Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

 select  sum(Recovered) as toatl_death_case,
  avg(Recovered) as avg_recovered_case , 
  variance(Recovered) as varrince_recovered_case, 
  stddev(Recovered)  as std_recovered_case
  from corona_virus_dataset;
  
  -- Q14. Find Country having highest number of the Confirmed case
  
  select `Country/Region`,sum(Confirmed) as total_confirmed 
from corona_virus_dataset
group by `Country/Region`
order by  total_confirmed DESC limit 1;
  
  
-- Q15. Find Country having lowest number of the death case

select `Country/Region`,sum(Deaths) as total_deaths
from corona_virus_dataset
group by `Country/Region`
order by  total_deaths ASC limit 1;


-- Q16. Find top 5 countries having highest recovered case
select `Country/Region`,sum(Recovered) as total_recovered
from corona_virus_dataset
group by `Country/Region`
order by  total_recovered DESC limit 5;
  
