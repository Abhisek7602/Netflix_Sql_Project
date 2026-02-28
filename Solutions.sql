--Drop The Table if Exits
DROP TABLE IF EXISTS netflix;

--Create the Table
CREATE TABLE netflix
(
	show_id	VARCHAR(5),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	description VARCHAR(550)
);

--Check The Table
Select *
from netflix;

--Count The Data
Select count(*) As Total_Content 
from netflix;

--Count The Type
Select Distinct type, count(*)
from netflix
group by type;

-- 15 Business Problems & Solutions

-- 1. Count the number of Movies vs TV Shows.
Select Distinct type, 
       count(*) as Total_Content
from netflix
group by type;


-- 2. Find the most common rating for movies and TV shows.
Select 
      type,
	  rating,
	  count(*)
from netflix
group by 1,2
order by 1,3 DESC;


-- 3. List all movies released in a specific year (e.g., 2020).
Select *
from netflix
where type = 'Movie' and release_year=2020;


-- 4. Find the top 5 countries with the most content on Netflix.
Select unnest(String_to_array(country,',')) as new_country,
       count(show_id) as Content
from netflix
group by country
order by content Desc
limit 5;


-- 5. Identify the longest movie.
Select type,
       duration
from netflix
where type='Movie' and duration=(Select max(duration) from netflix)
limit 1;


-- 6. Find content added in the last 5 years.
Select *
from netflix
where To_date(date_added,'Month dd yyyy') >= current_date-interval '5 years';


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'.
Select type,
       director
from netflix
where director Like '%Rajiv Chilaka%';


-- 8. List all TV shows with more than 5 seasons.
Select type,
       duration
from netflix
where type='TV Show' and duration > '5 Seasons';


-- 9. Count the number of content items in each genre.
Select
    unnest(string_to_array(listed_in,',')) as genre,
	count(*) as total_content
from netflix
group by genre;


-- 10.Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release.
Select 
      extract(year from to_date(date_added,'Month DD,YYYY')) as year ,
	  count(*) as content_per_year,
	  round(count(*)::numeric/(Select count(*) from netflix where country='India')::numeric * 100,2) as avg_content_per_year
from netflix
where country='India'
group by year
order by avg_content_per_year desc
limit 5;


-- 11. List all movies that are documentaries.
Select *
from netflix
where type='Movie' and listed_in like '%Documentaries%';


-- 12. Find all content without a director.
Select *
from netflix
where director is null;


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years.
Select *
from netflix
where casts like '%Salman Khan%' and release_year > extract (year from current_date)-10;


-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
Select unnest(String_to_array(casts,',')) as actor,
	   count(*)
from netflix
where country ilike 'India'
group by actor
order by count desc
limit 10;


-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.
With new_table 	
as (Select *,
               case 
	           when 
	           description like '%kill%' or
	           description like '%violence%' then 'Bad' 
	           else 'good' 
	           end category
from netflix)
select category,
        count(*) as total_content
		from new_table
		group by category
		order by total_content desc;


