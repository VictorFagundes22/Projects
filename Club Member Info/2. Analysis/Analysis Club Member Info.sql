-- Some questions we might have from this cleaned data:

-- 1. What is the average age from the member's club?
SELECT AVG(AGE) FROM club_member_info

-- 2. Most of the members are married or single?
SELECT COUNT(martial_status), martial_status FROM club_member_info WHERE martial_status IS NOT NULL GROUP BY martial_status ORDER BY 1 DESC

-- 3. What is the most common job?
SELECT COUNT(job_title), job_title FROM club_member_info WHERE job_title IS NOT NULL GROUP BY job_title ORDER BY 1 DESC

-- 4. What is the number of members per city?
SELECT COUNT(city), city FROM club_member_info WHERE city IS NOT NULL GROUP BY city ORDER BY 1 DESC

-- 5. What is the city that have more members?
SELECT COUNT(city), city FROM club_member_info WHERE city IS NOT NULL GROUP BY city ORDER BY 1 DESC

-- 6. Most of the members that have between 35 and 45 years old are married or single?
SELECT COUNT(martial_status), martial_status FROM club_member_info WHERE AGE < 45 AND AGE > 35 GROUP BY martial_status ORDER BY 1 DESC

-- 7. What is the average age of members that are married?
SELECT AVG(AGE) FROM club_member_info WHERE martial_status = 'MARRIED'

-- 8. What is the average age of members that are single?
SELECT AVG(AGE) FROM club_member_info WHERE martial_status = 'SINGLE'

/* 9. Is there some action that we can take with these data? 
		1. Promote events for single members with the target age of 42 and promote events for married members with the target age of 41.
		2. Create an event for the biggest 10 cities in each city, so the members from each city can interact with each other more easily.
		3. Collect more data from the members. Here are some ideas of research:
			. Do you have any children?
			. What is your favorite sport?
*/