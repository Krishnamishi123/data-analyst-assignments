USE world;

SELECT c.Name AS country_name,COUNT(CT.ID) AS city_count
FROM Country c LEFT JOIN City CT ON c.Code = CT.CountryCode
GROUP BY c.Name;

SELECT Continent, COUNT(*) AS country_count FROM Country
GROUP BY Continent HAVING COUNT(*) > 30;

SELECT Region , SUM(Population) FROM country GROUP BY Region
HAVING SUM(Population)>200000000;

SELECT Continent,AVG(GNP) FROM Country GROUP BY Continent
ORDER BY AVG(GNP) DESC LIMIT 5;

SELECT c.Continent,COUNT(DISTINCT cl.Language) AS 
official_language_count FROM Country c JOIN CountryLanguage cl
ON c.Code = cl.CountryCode WHERE cl.IsOfficial = 'T'
GROUP BY c.Continent;

SELECT Continent,MAX(GNP),MIN(GNP) FROM country GROUP BY
Continent;

SELECT c.Name AS country_name, AVG(ci.Population)  FROM Country c
JOIN City ci ON c.Code = ci.CountryCode GROUP BY c.Code, c.Name
ORDER BY AVG(ci.Population)  DESC LIMIT 1;

SELECT c.Continent,AVG(ci.Population)  FROM Country c JOIN City ci
ON c.Code = ci.CountryCode GROUP BY c.Continent
HAVING AVG(ci.Population) > 200000;

SELECT Continent,SUM(Population),AVG(LifeExpectancy) FROM country
GROUP BY Continent ORDER BY AVG(LifeExpectancy) DESC;

SELECT Continent,AVG(LifeExpectancy) FROM country 
 GROUP BY Continent HAVING SUM(Population)>200000000
 ORDER BY AVG(LifeExpectancy) DESC LIMIT 3;
