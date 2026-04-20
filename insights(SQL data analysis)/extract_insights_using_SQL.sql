SELECT * FROM lego_db.lego_sets_clean limit 5;

-- How many total LEGO sets are there?
SELECT COUNT(DISTINCT set_id) as total_sets
FROM lego_sets_clean;


-- How many sets are there per theme?
SELECT theme,COUNT(set_id) as sets_count
FROM lego_sets_clean
GROUP BY theme
ORDER BY 2 DESC ;


-- What is the average price of sets?
SELECT ROUND(AVG(REPLACE(price,"$","")+0),2) as avg_price -- Price column is stored as text (e.g., '$29.99'), 
FROM lego_sets_clean;									-- so we remove '$' and convert to numeric before averaging


-- What is the average number of pieces per set?

SELECT ROUND(avg(pieces),2) as avg_pieces
FROM lego_sets_clean;

-- Which set has the maximum price?
SELECT set_id,name,price
FROM lego_sets_clean
ORDER BY REPLACE(price,"$","")+0 DESC 
LIMIT 1;

-- Which set has the minimum number of pieces?
SELECT set_id,name,pieces
FROM lego_sets_clean
ORDER BY pieces 
LIMIT 1;

-- Count of sets by age range
SELECT Age_Range,COUNT(set_id) as sets_count
FROM lego_sets_clean
GROUP BY Age_Range
ORDER BY 2 DESC;

-- Count of sets by price range ($, $$, $$$)
SELECT Price_Range,COUNT(set_id) as sets_count
FROM lego_sets_clean
GROUP BY Price_Range
ORDER BY 2 DESC;




-- 📊 Product Analysis
-- Which theme has the highest number of sets?
SELECT theme,COUNT(set_id) AS sets_count
FROM lego_sets_clean
GROUP BY theme
ORDER BY 2 DESC 
LIMIT 1;

-- OR
-- IF ties 

SELECT theme,COUNT(set_id) AS sets_count
FROM lego_sets_clean
GROUP BY theme
HAVING sets_count=(
	SELECT MAX(theme_count)
    FROM (
		SELECT COUNT(set_id) as theme_count
        FROM lego_sets_clean
        GROUP BY theme
        )sub
);
    


-- Which themeGroup generates the highest average price?
SELECT themeGroup , ROUND(AVG(REPLACE(price,"$","")+0),2) as avg_price
FROM lego_sets_clean
GROUP BY themeGroup
ORDER BY avg_price DESC
LIMIT 1;

-- OR 

SELECT themeGroup , ROUND(AVG(REPLACE(price,"$","")+0),2) as avg_price
FROM lego_sets_clean
GROUP BY themeGroup
HAVING avg_price = (
	SELECT MAX(avg_price)
    FROM(
		SELECT ROUND(AVG(REPLACE(price,"$","")+0),2) as avg_price
        FROM lego_sets_clean
        GROUP BY themeGroup
    )sub
);


-- Top 5 sets with the highest price per piece ratio

SELECT set_id,name,theme,themeGroup,price,pieces,
	   ROUND((REPLACE(price,"$","")+0) / pieces,2) as price_per_piece
FROM lego_sets_clean
WHERE pieces > 0
ORDER BY price_per_piece DESC
LIMIT 5;

-- Which sets give best value for money (low price, high pieces)?

SELECT set_id,name,theme,themeGroup,price,pieces,
	   ROUND((REPLACE(price,"$","")+0) / pieces,2) as price_per_piece
FROM lego_sets_clean
WHERE pieces > 0
ORDER BY price_per_piece 
LIMIT 5;


-- 📈 Trend Analysis
-- Number of sets released per year

SELECT year,COUNT(set_id) as sets_count
FROM lego_sets_clean
GROUP BY year
ORDER BY year;


-- Average price trend over the years

SELECT year, ROUND(AVG(REPLACE(price,"$","")+0),2) as avg_price
FROM lego_sets_clean
GROUP BY year
ORDER BY year;

SELECT 
    year,
    ROUND(AVG(REPLACE(TRIM(price), '$', '') + 0), 2) AS avg_price,
    ROUND(
        AVG(REPLACE(TRIM(price), '$', '') + 0) 
        - LAG(AVG(REPLACE(TRIM(price), '$', '') + 0)) OVER (ORDER BY year),
    2) AS price_change
FROM lego_sets_clean
GROUP BY year
ORDER BY year;

-- Are newer sets more expensive?
SELECT CASE 
			WHEN year>=2020 THEN 'New Sets'
		    ELSE 'Old Sets' 
	    END AS category,
        ROUND(AVG(REPLACE(TRIM(price), '$', '') + 0), 2) AS avg_price
FROM lego_sets_clean
GROUP BY 1;
        

-- 👶 Customer Segmentation (Age-Based)
-- Which age range has the most products?
SELECT Age_Range,COUNT(set_id) products_count
FROM lego_sets_clean
GROUP BY Age_Range
ORDER BY products_count DESC
LIMIT 1;



-- Average price by age range

SELECT Age_Range,
ROUND(AVG(REPLACE(TRIM(price),"$","")+0),2) as avg_price
FROM lego_sets_clean
GROUP BY Age_Range
ORDER BY 2 DESC;

-- Which age group gets the most complex sets (pieces)?

SELECT Age_Range,
ROUND(AVG(pieces), 0) AS avg_pieces,
ROUND(AVG(REPLACE(TRIM(price),"$","")+0),2) as avg_price
FROM lego_sets_clean
GROUP BY Age_Range
ORDER BY 2 DESC;




