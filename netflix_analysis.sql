-- Director Analysis
SELECT director, COUNT(*) AS titles
FROM netflix_titles
WHERE director IS NOT NULL AND director <> ''
GROUP BY director
HAVING COUNT(*) > (
    SELECT AVG(title)
    FROM (
        SELECT COUNT(*) AS title
        FROM netflix_titles
        WHERE director IS NOT NULL
        GROUP BY director
    ) AS avg_table
);

-- Content Type Distribution
SELECT type, COUNT(*) AS total,
ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM netflix_titles), 2) AS percentage
FROM netflix_titles
GROUP BY type;

-- Country-wise Ranking
SELECT country, COUNT(*) AS titles,
RANK() OVER (ORDER BY COUNT(*) DESC) AS country_rank
FROM netflix_titles
WHERE country IS NOT NULL
AND country NOT LIKE '%,%'
AND country <> ''
GROUP BY country;

-- Rating & Release Analysis
SELECT rating, release_year
FROM (
    SELECT rating, release_year,
    DENSE_RANK() OVER (PARTITION BY rating ORDER BY release_year DESC) AS rank_
    FROM netflix_titles
    WHERE rating IS NOT NULL
) t
WHERE rank_ = 2;
