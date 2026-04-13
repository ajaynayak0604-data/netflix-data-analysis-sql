-- Duplicate Records (Data Cleaning)
select title,count(*) 
from netflix_titles 
group by title 
having count(*)>1;

delete n1 
from netflix_titles n1 
join netflix_titles n2 
on n1.title = n2.title 
and n1.release_year < n2.release_year
where n1.show_id between 's1' and 's101';

--------------------------------------------------

-- Same Title with Different Year/Type
SELECT a.title,
       a.release_year AS year_,
       b.release_year AS year_1,
       a.type AS type_,
       b.type AS type_1
FROM netflix_titles a 
JOIN netflix_titles b 
ON a.title = b.title 
AND (a.release_year <> b.release_year OR a.type <> b.type)
AND a.show_id < b.show_id;

--------------------------------------------------

-- Directors with Above Average Titles
select director,COUNT(*) as titles 
from netflix_titles 
WHERE director IS NOT NULL AND director <> ''
group by director 
having count(*)>(
    select avg(title)
    from (
        select COUNT(*) as title 
        from netflix_titles 
        where director is not null 
        group by director
    ) as avg_table
);

--------------------------------------------------

-- Content Type Distribution
select type,count(*) as total,
round(count(*) *100/(select count(*) from netflix_titles), 2) as percentage 
from netflix_titles 
group by type;

--------------------------------------------------

-- Country-wise Ranking
SELECT country, COUNT(*) AS titles,
RANK() OVER (ORDER BY COUNT(*) DESC) AS country_rank
FROM netflix_titles
WHERE country IS NOT NULL 
AND country NOT LIKE '%,%' 
AND country <> ''
GROUP BY country;

--------------------------------------------------

-- Second Most Recent Release Year by Rating
select rating, release_year 
from (
    select rating,release_year,
           dense_rank() over(partition by rating order by release_year desc) as rank_
    from netflix_titles 
    where rating is not null
) t 
where rank_ = 2;

--------------------------------------------------

-- Year-wise Comparison
SELECT year_add, titles,
LAG(titles) OVER (ORDER BY year_add) AS prev_year,
titles - LAG(titles) OVER (ORDER BY year_add) AS difference
FROM (
    SELECT YEAR(STR_TO_DATE(date_added, '%M %d, %Y')) AS year_add,
           COUNT(*) AS titles
    FROM netflix_titles
    WHERE date_added IS NOT NULL
    GROUP BY YEAR(STR_TO_DATE(date_added, '%M %d, %Y'))
) t;
