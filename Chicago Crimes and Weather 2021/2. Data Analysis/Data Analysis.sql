-- Understanding the three tables
SELECT * FROM chicago_crimes_2021
SELECT * FROM chicago_temps_2021
SELECT * FROM chicago_areas


-- How many crimes were reported in 2021 in Chicago?
SELECT COUNT(*) FROM chicago_crimes_2021

-- What is the total amount of homicides, assaults and battery?
SELECT crime_type, COUNT(*) FROM chicago_crimes_2021 WHERE crime_type IN ('homicide','battery','assault') group by crime_type order by 2 desc

-- Creating a view that joins data from all over the three tables
DROP VIEW IF EXISTS chicago_crimes
CREATE VIEW chicago_crimes AS
	SELECT 
		CR.community_id,
		cr.date,
		cr.time_report,
		cr.month,
		CR.crime_type,
		CR.crime_description,
		CR.crime_location,
		CR.city_block,
		CA.name,
		CA.population,
		CA.area_sq_mi,
		CA.density,
		CR.arrest,
		CR.domestic,
		CT.temp_high,
		CT.temp_low,
		CT.precipitation,
		CR.latitude,
		CR.longitude
	FROM chicago_crimes_2021 cr
	JOIN chicago_areas ca on CR.community_id = CA.community_area_id
	JOIN chicago_temps_2021 ct ON cr.date = CT.date

SELECT * FROM chicago_crimes

-- What are the top 10 communities that had most crimes reported?
-- We are going to add the current population to see if area density is a factor.
SELECT TOP 10 name, population, density, COUNT(*) AS reported_crimes FROM chicago_crimes group by name, population, density ORDER BY reported_crimes DESC

-- What are the top 10 communities that had the least crimes reported?
-- We are going to add the current population to see if area density is a factor.
SELECT TOP 10 name, population, density, COUNT(*) AS reported_crimes FROM chicago_crimes group by name, population, density ORDER BY reported_crimes asc

-- What month had the most crimes reporterd?
SELECT DATENAME(MONTH,DATE), COUNT(*) AS n_crimes FROM chicago_crimes GROUP BY DATENAME(MONTH,DATE) ORDER BY N_CRIMES DESC

-- What month had the most homicides and what was the average and median temperature?
SELECT month, COUNT(*) AS n_homicides, ROUND(AVG(TEMP_HIGH),1) AS avg_high_temp
FROM chicago_crimes WHERE crime_type = 'HOMICIDE'GROUP BY month ORDER BY n_homicides DESC

--What weekday were most crimes comitted?
SELECT datename(WEEKDAY,date), COUNT(*) AS n_crimes FROM chicago_crimes GROUP BY datename(WEEKDAY,DATE) ORDER BY n_crimes DESC

--What are the top ten city streets that have the most reported crimes?
SELECT TOP 10 city_block, COUNT(*) as n_crimes FROM chicago_crimes GROUP BY city_block ORDER BY n_crimes DESC


--What are the top ten city streets that have had the most homicides
SELECT TOP 10 city_block, COUNT(*) AS N_HOMICIDES FROM chicago_crimes WHERE crime_type = 'HOMICIDE' GROUP BY city_block ORDER BY N_HOMICIDES DESC

-- What are the top ten city streets that have had the most burglaries?
SELECT TOP 10 city_block, COUNT(*) AS n_burglaries FROM chicago_crimes WHERE crime_type = 'burglary' GROUP BY city_block ORDER BY n_burglaries DESC

-- What was the number of reported crimes on the hottest day of the year vs the coldest?
WITH hottest AS (
	SELECT temp_high, COUNT(*) AS n_crimes FROM chicago_crimes WHERE temp_high = (SELECT MAX(TEMP_HIGH) FROM chicago_crimes) GROUP BY temp_high
),
coldest AS (
	SELECT temp_high, COUNT(*) AS N_CRIMES FROM chicago_crimes WHERE temp_high = (SELECT MIN(TEMP_HIGH) FROM chicago_crimes) GROUP BY temp_high)

	select h.temp_high, h.n_crimes from hottest h UNION SELECT c.temp_high, c.N_CRIMES FROM coldest c

-- What is the number and types of reported crimes on Michigan Ave?	
SELECT crime_type, COUNT(*) AS michigan_ave_crimes FROM chicago_crimes WHERE city_block like '%michigan ave%' GROUP BY crime_type ORDER BY michigan_ave_crimes DESC

-- What are the top 5 least reported crime, how many arrests were made and the percentage of arrests made?
SELECT TOP 5 
	crime_type, 
	least_amount, 
	arrest_count, 
	ROUND(100*(CAST(arrest_count AS float)/least_amount),2) as arrest_percentage 
FROM (SELECT 
	crime_type, 
	COUNT(*) AS least_amount, 
	sum(CASE
			WHEN arrest = 'true' THEN 1
			ELSE 0 END) as arrest_count 
	FROM chicago_crimes 
group by crime_type) as tmp ORDER BY least_amount

-- What is the percentage of domestic violence crimes?
SELECT
	100 - n_domestic_perc AS non_domestic_violence,
	n_domestic_perc AS domestic_violence
from(SELECT round(100 * CAST((SELECT count(*) FROM chicago_crimes WHERE domestic = 'true') AS float) / count(*), 2) AS n_domestic_perc
FROM chicago_crimes) AS tmp

-- Display how many crimes were reported on a monthly.
SELECT month, COUNT(*) FROM chicago_crimes GROUP BY month ORDER BY (month) desc

-- What is the Month, day of the week and the number of homicides that occured in a babershop or beauty salon?
SELECT DISTINCT month, DATENAME(WEEKDAY, date) as day, crime_location, crime_type,  COUNT(*) FROM chicago_crimes WHERE crime_location LIKE '%BARBER%' AND crime_type = 'HOMICIDE' GROUP BY month, DATENAME(WEEKDAY, date), crime_location, crime_type
