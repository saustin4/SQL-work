/*
Stacy Austin
nested-joins
*/

ALTER SESSION SET CURRENT_SCHEMA = pv;


-- Query A 

SELECT username FROM performances
MINUS
SELECT DISTINCT username FROM
(SELECT * FROM
(SELECT username FROM performances)
CROSS JOIN
(SELECT DISTINCT meetid FROM meets WHERE venuetype='Indoor')
MINUS
SELECT username, meetid FROM performances)
NATURAL INNER JOIN meets
WHERE meetdate BETWEEN '01-JAN-2011' AND '31-DEC-2011';


-- Query B

SELECT * FROM 
( SELECT distinct rank() OVER (ORDER BY performance DESC)
AS rank, username, firstname, lastname, metricheight, englishheight
FROM vaulters
NATURAL INNER JOIN performances
INNER JOIN heights
ON performances.performance = heights.metricheight)
WHERE rank <= 10
ORDER BY rank;


-- Query C

SELECT username, firstname, lastname, EXTRACT(YEAR FROM meetdate)
AS YEAR, venuetype AS season, gender, performance AS metric_performance
FROM vaulters
NATURAL INNER JOIN performances
NATURAL INNER JOIN meets
WHERE  meetname LIKE 'ACC%'
ORDER BY meetdate, venuetype;

