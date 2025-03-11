SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1, 2

-- TOTAL CASES VS TOTAL DEATHS
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DEATHPERCENT
FROM CovidDeaths
WHERE location like 'india'
ORDER BY 5 desc

--TOTAL CASES VS POPULATION
SELECT location, date, population, total_cases, (total_cases/population)*100 AS INFECPERCENT
FROM CovidDeaths
WHERE location like 'india'
ORDER BY 1, 2

SELECT location, population, MAX(total_cases) AS HIGHESTINFCOUNT, MAX((total_cases/population))*100 AS PERPOPINFEC
FROM CovidDeaths
--WHERE location like 'india'
GROUP BY location, population
ORDER BY 1, 2

--COUNTRIES WITH HIGHESTDEATHCOUNT PER POP.
SELECT location, MAX(CAST(total_deaths AS INT)) AS HIGHESDEATHCOUNT, MAX((total_deaths/population))*100 AS PERPOPDEATH
FROM CovidDeaths
--WHERE location like 'india'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC

-- CONTINENT
SELECT location, population, MAX(CAST(total_deaths AS INT)) AS HIGHESDEATHCOUNT, MAX((total_deaths/population))*100 AS PERPOPDEATH
FROM CovidDeaths
--WHERE location like 'india'
WHERE continent IS NULL
GROUP BY location, population
ORDER BY 2 DESC


--GLOBAL NUMBERS
SELECT date,SUM(new_cases) AS glcase, SUM(CAST(new_deaths AS INT)) AS glDeath, SUM(CAST(new_deaths AS INT))/sum(new_cases)*100 AS DEATHPER
FROM CovidDeaths
--WHERE location like 'india'
WHERE continent IS not NULL
GROUP BY date
ORDER BY 1, 2


