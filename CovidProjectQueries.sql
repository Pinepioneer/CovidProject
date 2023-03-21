SELECT *
FROM dbo.deaths
WHERE continent is not null
ORDER BY 3,4

--SELECT *
--FROM dbo.vaccinations
--ORDER BY 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM dbo.deaths
WHERE continent is not null
ORDER BY 1,2

--total cases vs population

SELECT Location, date, total_cases, Population, (total_cases/population)*100  AS "percent_population_infected"
FROM dbo.deaths
WHERE continent is not null
ORDER BY 1,2

-- total deaths vs population
SELECT Location, date, total_deaths, Population, (total_deaths/population)*100  AS "percent_population_dead"
FROM dbo.deaths
WHERE continent is not null
ORDER BY 1,2

--countries with highest infection rates (total cases vs population)

SELECT Location, MAX(total_cases) as "peak_infection_count", MAX((total_cases/population))*100  AS "percent_population_infected"
FROM dbo.deaths
WHERE continent is not null
GROUP BY Location
ORDER BY percent_population_infected DESC


--countries with highest death rates (total deaths vs population)

SELECT Location, population, MAX(cast(total_deaths as int)) as "total_death_count", (MAX(cast(total_deaths as int))/population)*100 as "death_vs_population"
FROM dbo.deaths
WHERE continent is not null
GROUP BY Location, population
ORDER BY death_vs_population DESC

--Breaking down by continent 

SELECT continent, (SUM(cast(new_deaths as int))) as "total_death_count" 
FROM dbo.deaths
WHERE continent is not null
GROUP BY continent
ORDER BY total_death_count DESC

--global numbers

SELECT SUM(new_cases) as 'total_cases', SUM(cast(new_deaths as int)) as 'total_deaths', SUM(cast(new_deaths as int))/SUM(new_cases)*100  AS "global_infections_vs_dead"
FROM dbo.deaths
WHERE continent is not null
ORDER BY 1,2


--Looking at total vaccination vs population, using CTE

WITH total_vax_vs_pop (continent, location, date, population, new_vaccinations, rolling_vaccinations)
AS
(
SELECT d.location, d.continent, d.date, d.population, v.new_vaccinations, SUM(cast(v.new_vaccinations as int))  OVER (Partition by d.location ORDER BY d.date) as rolling_vaccinations
FROM dbo.vaccinations v 
JOIN dbo.deaths d 
	ON d.location = v.location AND d.date = v.date
WHERE d.continent IS NOT NULL
)
SELECT *, (rolling_vaccinations/population)*100 as vax_rate
FROM total_vax_vs_pop

-- month and year for infections, deaths, vaccinations

SELECT MONTH(v.date) as month_number, YEAR(v.date) as year, SUM(cast(v.new_vaccinations as int)) as vaccinations, SUM(cast(d.new_cases as int)) as infections, SUM(cast(d.new_deaths as int)) as deaths
FROM dbo.Vaccinations v
JOIN dbo.Deaths d
	ON v.date = d.date AND v.location = d.location
WHERE d.continent IS NOT NULL
GROUP BY MONTH(v.date), YEAR(v.date)
ORDER BY MONTH(v.date) asc

--Creating Views

-- for total infections by country
Create view total_infection_rate as
SELECT Location, MAX(total_cases) as "peak_infection_count", MAX((total_cases/population))*100  AS "percent_population_infected"
FROM dbo.deaths
WHERE continent is not null
GROUP BY Location

--for total deaths by country
Create view total_death_rate as
SELECT Location, population, MAX(cast(total_deaths as int)) as "total_death_count", (MAX(cast(total_deaths as int))/population)*100 as "death_vs_population"
FROM dbo.deaths
WHERE continent is not null
GROUP BY Location, population

--for total vaccinations by country
Create view total_vax_rate as
WITH total_vax_vs_pop (continent, location, date, population, new_vaccinations, rolling_vaccinations)
AS
(
SELECT d.location, d.continent, d.date, d.population, v.new_vaccinations, SUM(cast(v.new_vaccinations as int))  OVER (Partition by d.location ORDER BY d.date) as rolling_vaccinations
FROM dbo.vaccinations v 
JOIN dbo.deaths d 
	ON d.location = v.location AND d.date = v.date
WHERE d.continent IS NOT NULL
)
SELECT *, (rolling_vaccinations/population)*100 as vax_rate
FROM total_vax_vs_pop


-- for vaccination, deaths, infections data on month and year
CREATE VIEW data_over_time as
SELECT MONTH(v.date) as month_number, YEAR(v.date) as year, SUM(cast(v.new_vaccinations as int)) as vaccinations, SUM(cast(d.new_cases as int)) as infections, SUM(cast(d.new_deaths as int)) as deaths
FROM dbo.Vaccinations v
JOIN dbo.Deaths d
	ON v.date = d.date AND v.location = d.location
WHERE d.continent IS NOT NULL
GROUP BY MONTH(v.date), YEAR(v.date)