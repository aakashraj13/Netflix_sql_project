--1. Count the number of Movies vs TV Shows
SELECT 
  type, 
  COUNT(*)
FROM netflex
GROUP BY type;






--2. Find the most common rating for movies and TV shows
SELECT 
  type,
  rating

FROM 
(
SELECT 
  type,
  rating,
  count(*),
  RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as Ranking
FROM netflex
GROUP BY 1,2
) as t1
WHERE Ranking = 1



--3. List all movies released in a specific year (e.g., 2020)

SELECT * FROM netflex
WHERE 
   type = 'Movie'
   AND 
   release_year = 2020
   

--4. Find the top 5 countries with the most content on Netflix

SELECT  
   UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
      COUNT(show_id)  as total_content
FROM netflex 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

SELECT 
  UNNEST(STRING_TO_ARRAY(country,',')) as new_country
FROM netflex   






--5. Identify the longest movie
SELECT * FROM netflex
WHERE 
   type = 'Movie'
   AND 
   duration = (SELECT MAX(duration) FROM netflex)





--6. Find content added in the last 5 years
SELECT 
  *
FROM netflex 
WHERE 
   TO_DATE(date_added, 'Month DD,YYYY') >= Current_Date - INTERVAL '5 years'

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!


SELECT type , director , title
FROM netflex
WHERE 
    director ILIKE '%Rajiv Chilaka%'


--8. List all TV shows with more than 5 seasons

SELECT 
  * 
  --SPLIT_PART(duration, ' ', 1) as sessions 
FROM netflex
WHERE 
   type = 'TV Show'
   AND
   SPLIT_PART(duration, ' ', 1):: numeric > 5  


9. Count the number of content items in each genre
SELECT 
  
  UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
  COUNT(show_id)
FROM netflex 
GROUP BY 1



--10.Find each year and the average numbers of content release in India on netflix. return top 5 year with highest avg content release!
SELECT 
  EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD,YYYY')) as Year,
  COUNT(*),
  ROUND(
  COUNT(*)::numeric / (SELECT COUNT(*) FROM netflex WHERE country = 'India')::numeric*100
  ,2)as Avg_content_per_yr
FROM netflex 
WHERE country = 'India'
GROUP BY 1






--11. List all movies that are documentaries
SELECT * FROM netflex
WHERE
  listed_in ILIKE '%documentaries%'


--12. Find all content without a director
SELECT * FROM netflex
WHERE
  director IS null





13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT 
 *
FROM netflex
WHERE 
  casts ILIKE '%Salman Khan%'
  AND 
  release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10


14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT 
 UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
 COUNT(*) as Total_content 

FROM netflex 
WHERE country ILIKE '%india%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many itemsfall into each category.

WITH new_table
AS
(
SELECT 
*,
 
 CASE
 WHEN  
      description ILIKE '%kill%'OR
      description ILIKE '%violence%' THEN 'Bad_content'
	  ELSE 'Good content'
	 END category 
FROM netflex 
) 
SELECT 
  category, 
  COUNT(*) as total_content
FROM new_table
GROUP BY 1




   

