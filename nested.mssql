/*
Stacy Austin

xlevel lineage and nested queries
*/

--Query 1
SELECT country, NAME, age,avgdrive
FROM pga.golfers
WHERE avgdrive IN (
SELECT MAX(avgdrive)
OVER(ORDER BY country) AS highestavg
FROM pga.golfers)
ORDER BY avgdrive DESC;


--Query 2
WITH startview AS(SELECT country, name, earnings, avg(earnings)
OVER(ORDER BY country) AS avgearnings
FROM pga.golfers)
SELECT country, NAME, ROUND(avgearnings,2) AS avgearnings,earnings,
ROUND(earnings-avgearnings,2) AS overavg
FROM startview NATURAL JOIN pga.golfers
WHERE earnings > avgearnings
ORDER BY overavg DESC;

--Query 3
SELECT * FROM
(WITH sview AS(SELECT agentid, NVL(COUNT(agentid),0) AS collectioncount,
NVL(sum(price),0) AS collectionworth
FROM(SELECT mls.agents.agentid, lname, fname, NVL(price,0) AS price
FROM mls.homes
INNER JOIN mls.agents ON mls.homes.agentid = mls.agents.agentid)
GROUP BY agentid) SELECT lname, fname, NVL(collectioncount,0) AS collectioncount,
NVL(collectionworth,0) AS collectionworth
FROM sview INNER JOIN mls.agents ON sview.agentid = mls.agents.agentid);


--Query 4
SELECT * FROM
(WITH sview AS(SELECT agentid, COUNT(agentid) AS collectioncount,
sum(price) AS collectionworth
FROM(
SELECT mls.agents.agentid, lname, fname, price
FROM mls.homes INNER JOIN mls.agents ON mls.homes.agentid = mls.agents.agentid)
GROUP BY agentid)
SELECT lname, fname, collectioncount, collectionworth,
RANK() OVER(ORDER BY collectionworth DESC) AS rankings
FROM sview INNER JOIN mls.agents ON sview.agentid = mls.agents.agentid)
WHERE rankings < 6;

--Query 5
SELECT acctno, tdate, description, nvl(credit,0) AS credit,
nvl(charge,0) AS charge, nvl(sum(credit)
OVER (ORDER BY acctno ROWS BETWEEN acctno PRECEDING AND CURRENT ROW),0) AS balance
FROM bank.trans NATURAL INNER JOIN bank.accounts
ORDER BY acctno, tdate;

--Query 6
SELECT *
FROM (SELECT acctno, firstname, lastname, balance,
RANK() OVER (ORDER BY balance desc) AS rankings
FROM bank.accounts
NATURAL INNER JOIN bank.customers)
WHERE rankings < 4;

--Query 7
SELECT ticker, close, NVL((close - Lag(close, 1) OVER (ORDER BY tradedate)),0)
AS difference, volume
FROM marketdata
WHERE ticker IN('DCC', 'OBO') AND EXTRACT(MONTH FROM tradedate) = '01'
ORDER BY tradedate;

--Query 8
SELECT NAME FROM
(SELECT LEVEL AS xlevel, NAME FROM people
START WITH NAME='Sue'
CONNECT BY PRIOR  father = NAME OR PRIOR mother = NAME)
WHERE xlevel =3;

--Query 9
SELECT NAME FROM
(SELECT LEVEL AS xlevel, NAME FROM people
START WITH NAME='Marge'
CONNECT BY PRIOR NAME = father OR PRIOR NAME = mother)
WHERE xlevel =4;

--Query 10
SELECT NAME FROM
(SELECT LEVEL AS xlevel, NAME FROM people
START WITH NAME='Vern'
CONNECT BY PRIOR NAME = father OR PRIOR NAME = mother)
WHERE xlevel =2;
