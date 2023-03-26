SELECT *
FROM dbo.deaths
WHERE continent is not null AND location IN ('Brunei','Cambodia','Indonesia','Laos','Malaysia','Myanmar','Philippines','Singapore','Thailand','Vietnam')
ORDER BY 3,4

SELECT *
FROM dbo.vaccinations
WHERE continent is not null AND location IN ('Brunei','Cambodia','Indonesia','Laos','Malaysia','Myanmar','Philippines','Singapore','Thailand','Vietnam')
ORDER BY 3,4

--SE Asia total vax, tests, cases, and deaths
SELECT v.location, MAX(v.total_vaccinations) as "Total Vaccinations", MAX(v.total_tests) as "Total Tests", MAX(d.total_cases) as "Total Cases", MAX(d.total_deaths) as "Total Deaths" 
FROM dbo.vaccinations v
JOIN dbo.deaths d
	ON d.location = v.location AND d.date=v.date
WHERE v.continent is not null AND v.Location IN ('Brunei','Cambodia','Indonesia','Laos','Malaysia','Myanmar','Philippines','Singapore','Thailand','Vietnam')
GROUP BY v.location

--SE Asia socioeconomic data
SELECT Location, AVG(cast(population_density as float)) as "Population Density", AVG(cast(gdp_per_capita as float)) as "GDP per Capita", AVG(cast(extreme_poverty as float)) as "Extreme Poverty Rate", AVG(cast(human_development_index as float)) as "HDI"
FROM dbo.Vaccinations
WHERE continent is not null AND location IN ('Brunei','Cambodia','Indonesia','Laos','Malaysia','Myanmar','Philippines','Singapore','Thailand','Vietnam')
GROUP BY location


--Breaking down by continent -- issue with data on columns starting with "new" so dividing by "2" to fix

SELECT continent, (SUM(new_cases)/2) as "total_case_count", (SUM(cast(new_deaths as int))/2) as "total_death_count", (SUM(cast(new_vaccinations as int))/2) as "vaccinations"
FROM dbo.deaths
WHERE continent is not null
GROUP BY continent

-- Global totals

SELECT (SUM(new_cases)/2) as 'total_cases', (SUM(cast(new_deaths as int))/2) as 'total_deaths', (SUM(cast(new_deaths as int))/2)/(SUM(new_cases)/2) AS "death_vs_infections"
FROM dbo.deaths
WHERE continent is not null
ORDER BY 1,2

--SEA totals

SELECT (SUM(new_cases)/2) as 'total_cases', (SUM(cast(new_deaths as int))/2) as 'total_deaths', (SUM(cast(new_deaths as int))/2)/(SUM(new_cases)/2) AS "death_vs_infections"
FROM dbo.deaths
WHERE continent is not null AND location IN ('Brunei','Cambodia','Indonesia','Laos','Malaysia','Myanmar','Philippines','Singapore','Thailand','Vietnam')
ORDER BY 1,2

-- SE Asia totals

SELECT (SUM(new_cases)/2) as 'total_cases', (SUM(cast(new_deaths as int))/2) as 'total_deaths', (SUM(cast(new_deaths as int))/2)/(SUM(new_cases)/2)*100  AS "death_vs_infections"
FROM dbo.deaths
WHERE continent is not null AND location IN ('Brunei','Cambodia','Indonesia','Laos','Malaysia','Myanmar','Philippines','Singapore','Thailand','Vietnam')
ORDER BY 1,2

-- SE Asia time series for infections, deaths, vaccinations

SELECT v.location, v.date, (SUM(cast(v.new_vaccinations as int))/2) as vaccinations, (SUM(cast(d.new_cases as int))/2) as infections, (SUM(cast(d.new_deaths as int))/2) as deaths
FROM dbo.Vaccinations v
JOIN dbo.Deaths d
	ON v.date = d.date AND v.location = d.location
WHERE d.continent IS NOT NULL  AND v.location IN ('Brunei','Cambodia','Indonesia','Laos','Malaysia','Myanmar','Philippines','Singapore','Thailand','Vietnam')
GROUP BY v.location, v.date
ORDER BY v.location, v.date asc