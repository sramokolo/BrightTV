SELECT *
FROM
  brighttv.tv.userprofiles
   LIMIT 5;
----Establish the min and max time

  SELECT TO_CHAR(MAX(TO_TIMESTAMP(RECORDDATE2 ,'YYYY/MM/DD HH24:MI')),'HH24:MI') AS max_time 
from brighttv.tv.viewership;
     
SELECT TO_CHAR(MIN(TO_TIMESTAMP(RECORDDATE2 ,'YYYY/MM/DD HH24:MI')),'HH24:MI') AS min_time,
from brighttv.tv.viewership;
  
----Count distinct variable
SELECT count(distinct(coalesce(A.UserID,B.UserID))) AS SUBSCRIBERS,
    A.Race,
    A.Gender,
    A.Age,
    A.Province,
	B.CHANNEL2,
    B.DURATION2,
    B.RECORDDATE2,
	
----use case statement to have different age groups
CASE 
    WHEN A.Age BETWEEN 0 AND 12 then 'Kids'
    WHEN A.Age BETWEEN 13 AND 19 then 'Teenagers'
    WHEN A.Age BETWEEN 20 AND 30 then 'Young Adults'
    WHEN A.Age BETWEEN 31 AND 40 then 'Adults'
    WHEN A.Age BETWEEN 41 AND 60 then 'Elder'
    Else 'Pensioners'
    End AS Age_group,

---Separated Date and time from timestamp by using to_date, to_char, extraxt dayname and monthname

TO_DATE(TO_TIMESTAMP(B.RECORDDATE2 ,'YYYY/MM/DD HH24:MI')) AS Date,
TO_CHAR(TO_TIMESTAMP(B.RECORDDATE2 ,'YYYY/MM/DD HH24:MI'),'HH24:MI') AS Time,

CASE EXTRACT(MONTH FROM TO_TIMESTAMP(B.RECORDDATE2, 'YYYY/MM/DD HH24:MI'))
        WHEN 01 THEN 'January'
        WHEN 02 THEN 'February'
        WHEN 03 THEN 'March'
        WHEN 04 THEN 'April'
        WHEN 05 THEN 'May'
        WHEN 06 THEN 'June'
        WHEN 07 THEN 'July'
        WHEN 08 THEN 'August'
        WHEN 09 THEN 'September'
        WHEN 10 THEN 'October'
        WHEN 11 THEN 'November'
        WHEN 12 THEN 'December'
    END AS month_name,
DAYNAME(TO_TIMESTAMP(B.RECORDDATE2 ,'YYYY/MM/DD HH24:MI')) AS Day_name,

----use case statement to have time_categories
CASE 
    WHEN TO_CHAR(MAX(TO_TIMESTAMP(RECORDDATE2 ,'YYYY/MM/DD HH24:MI')),'HH24:MI') BETWEEN '00:32' AND '06:00' then 'Early Morning'
    WHEN TO_CHAR(MAX(TO_TIMESTAMP(RECORDDATE2 ,'YYYY/MM/DD HH24:MI')),'HH24:MI') BETWEEN '06:01' AND '11:59' then 'Morning'
    WHEN TO_CHAR(MAX(TO_TIMESTAMP(RECORDDATE2 ,'YYYY/MM/DD HH24:MI')),'HH24:MI') BETWEEN '12:00' AND '17:00' then 'Afternoon'
    WHEN TO_CHAR(MAX(TO_TIMESTAMP(RECORDDATE2 ,'YYYY/MM/DD HH24:MI')),'HH24:MI') BETWEEN '17:01' AND '20:00' then 'Evening'
    Else 'Night'
    End AS Time_category,
	
----Full outer join the two tables
      
FROM brighttv.tv.userprofiles A
FULL OUTER JOIN viewership B
ON A.userid = B.userid


----Exclude null entries

WHERE 
    A.UserID IS NOT NULL
    AND A.Race IS NOT NULL
    AND A.Gender IS NOT NULL
    AND A.Age IS NOT NULL
    AND A.Province IS NOT NULL
    AND B.UserID IS NOT NULL
    AND B.Channel2 IS NOT NULL
    AND B.Duration2 IS NOT NULL
    AND B.RecordDate2 IS NOT NULL
GROUP BY ALL;



