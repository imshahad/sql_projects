CREATE TABLE applestore_description_combined AS

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4;

-- check the number of unique aps in both tablesapplestoreAppleStore

select count(DISTINCT id) as UniqueAppIDs
FROM AppleStore;

SELECT COUNT(DISTINCT id) AS UniqueAppIDS
FROM applestore_description_combined;

-- check for any missing values in key fieldsAppleStore

SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL;

SELECT COUNT(*) AS MissingValues
FROM applestore_description_combined
WHERE app_desc is NULL;

-- find out the number of apps per genre

SELECT prime_genre, COUNT(*) AS NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC;

-- Get an overview of the apps' ratings

SELECT MIN(user_rating) AS MinRating,
		MAX(user_rating) AS MaxRating,
		AVG(user_rating) AS AvgRating

FROM AppleStore;

-- Determine whether paid apps have highter ratings than free apps

SELECT CASE
			WHEN price > 0 THEN 'Paid'
            ELSE 'Free'
       END AS App_Type,
       AVG(user_rating) as Avg_Rating
FROM AppleStore
GROUP BY App_Type;

-- Check if apps with more supported languages have higher ratings

SELECT CASE
			when lang_num < 10 THEN '<10 languages'
            WHEN lang_num BETWEEN 10 and 30 THEN '10-30 languages'
            ELSE '>30 languages'
        END AS language_number,
        AVG(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY language_number
ORDER BY Avg_Rating DESC;

--Check genres with low ratings

SELECT prime_genre, AVG(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY prime_genre
ORDER BY Avg_Rating ASC LIMIT 10;

--Check if there is correlation between the length of the app description and the user ratingAppleStore

SELECT CASE
			when length(b.app_desc) < 500 then 'short'
            WHEN length(b.app_desc) BETWEEN 500 AND 1000 THEN 'medium'
            ELSE 'long'
        END AS description_length,
        AVG(a.user_rating) AS Avg_Rating

FROM
		AppleStore AS A
JOIN
		applestore_description_combined as B
ON
		A.id = B.id
        
GROUP BY description_length
ORDER BY Avg_Rating DESC;

-- check the top-rated apps for each genre

SELECT track_name, prime_genre, user_rating
FROM (
  		SELECT
  		prime_genre,
  		track_name,
  		user_rating,
  		RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
  		FROM 
  		AppleStore
  	) AS A
WHERE 
A.RANK = 1;