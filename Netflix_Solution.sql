

drop table if exists Netflix;

create table Netflix(
	show_id varchar(6),
	types varchar(10),
	title  varchar(150),
	director varchar(208),
	casts varchar(1000),
	country varchar(150),
	date_added varchar(50),
	release_year INT,
	rating varchar(10),
	duration varchar(15),
	listed_in varchar(100),
	descriptions varchar(250)
);

select * from Netflix;

select count(*) as total_content from Netflix;

select distinct types from Netflix;

---  *** Solve 15 Business Problems Using SQL ***

-- 1. Count the number of Movies vs Tv Shows?

Select types, count(*) as Content_count from Netflix 
Group By types;

-- 2. Find most common Rating for Movies and Tv Shows?

select types, rating
from(
	select types, rating, count(*), rank() over (partition by types order by count(*) desc) as rnk
	from Netflix
	group by 1,2) as t1
where rnk=1;	

-- 3. List all Movies which is Release in 2020?

select count(*) listed_movie_2020 from Netflix where release_year = 2020 and types= 'Movie';

-- 4. Find the top 5 Countries with the Most Content on Netflix?

select * from Netflix;

select UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	   count(show_id) as Total_content  from Netflix
group by 1
order by 2 desc
Limit 5;

-- 5. Find The Logest Duration Movie?

select * from Netflix;

select title, max(duration) as Longest_movie from Netflix
where types = 'Movie' and duration is not null
group by title
order by Longest_movie desc
limit 1;


-- 6. Find the Contents which is added in last 5 years?

SELECT * FROM Netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 Years'

SELECT CURRENT_DATE - INTERVAL '5 YEARS'


-- 7. Find all Movies and Tv Shows that is Directed by 'Rajiv Chilaka'?

select types, director from Netflix where director 	ILIKE '%Rajiv Chilaka%';

--8. List all Tv Show with more than 5 Seasons?

Select * from Netflix where types = 'TV Show' and SPLIT_PART(duration,' ',1):: numeric > 5;

-- 9. Count the Number of Content in each Genre?

select UNNEST(STRING_TO_ARRAY(listed_in, ',')) as Genre, count(show_id) as Total_Content
from Netflix
group by 1;

-- 10. Find each years and the AVG Number of content release by India on Netflix, Return Top 5 years with higest Avg Content relase?

select Avg(types) as Avg_content from netflix where country = 'India';

select EXTRACT(Year from To_date(date_added, 'Month DD, YYYY')) as Year,
count(*) as yearly_content,
round(
	count(*):: numeric / (select count(*) from Netflix where country = 'India')*100,2
) as avg_content_per_year
from Netflix
where country = 'India'
group by 1;

-- 11. List All Movies That are Documentaries?

select * from Netflix where types = 'Movie' and listed_in = 'Documentaries';

-- 12. Find All The Content without Director?

Select types from Netflix where director is Null;

-- 13. Find Total number of Movies where Actor is Salman Khan Aperied from Last 10 Years?

select * from Netflix where casts ILIKE '%Salman Khan%'
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

-- 14. Find Top 10 Actors who have Appeared in the Higest Number of Movies Produced in India?

select UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
count(*) as Total_content from Netflix 
where country = 'India'
group by 1
Order by 2 desc
limit 10

-- 15. Categories the content based on the presence of the keywords 'kill' and 'violance' in description. Label the content is 'Bad' and Other content is 'Good'. Count items fall in each category?

with cte as(

select *,
	CASE 
	WHEN 
		descriptions ILIKE '%kill%' or 
		descriptions ILIKE '%violance%' THEN 'BAD_CONTENT'
	ELSE 'GOOD_CONTENT'
	
	END as Category
	
from Netflix)

select category, count(*) as total_content from cte
group by 1;
	
			











