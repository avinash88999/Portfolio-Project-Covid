SELECT * 
FROM CovidDeaths DEA
JOIN CovidVaccinations VAC
ON DEA.location = VAC.location
AND DEA.date = VAC.date
ORDER BY DEA.location

-- TOTAL POPULATION VS VACCINATIONS
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations 
, SUM(cast(VAC.new_vaccinations as int)) OVER (PARTITION BY DEA.location ORDER BY DEA.location,
dea.date) as rollcountvac
FROM CovidDeaths DEA
JOIN CovidVaccinations VAC
ON DEA.location = VAC.location
AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL
ORDER BY 2, 3

-- MAKE CTE TO UTILIZE NEW COLUMN

WITH PopVSVac ( continent, location, date, population, new_vaccinations 
, rollcountvac)
as
(
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations 
, SUM(cast(VAC.new_vaccinations as int)) OVER (PARTITION BY DEA.location ORDER BY DEA.location,
dea.date) as rollcountvac
FROM CovidDeaths DEA
JOIN CovidVaccinations VAC
ON DEA.location = VAC.location
AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL
-- ORDER BY 2, 3
)

SELECT *, (rollcountvac/population)*100 FROM PopVSVac

-- TEMP TABLE
DROP TABLE IF EXISTS #PERCENTPOPVAC
CREATE TABLE #PERCENTPOPVAC(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime, 
population numeric,
new_vac numeric, 
rollcountvacs numeric
)

INSERT INTO #PERCENTPOPVAC
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations 
, SUM(cast(VAC.new_vaccinations as int)) OVER (PARTITION BY DEA.location ORDER BY DEA.location,
dea.date) as rollcountvac
FROM CovidDeaths DEA
JOIN CovidVaccinations VAC
ON DEA.location = VAC.location
AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL
ORDER BY 2, 3



SELECT *, (rollcountvacs/population)*100 AS PERCENTVACCED FROM #PERCENTPOPVAC
