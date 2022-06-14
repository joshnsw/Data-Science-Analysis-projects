
<b>Description:</b>
In this project, I utilized public covid statistics data to do some basic data analysis using mysql queries.

<b>What I learnt:</b>
Putting data into sql database,using common sql queries to get information out of a huge dataset.


<b>Details of the project:</b>

The steps of this project are as follows:
1.Download public covid data
2. Use mysql queries in order to find out:
-countries with highest infection rate compared to population
-country with highest death count
-continent with highest death count
-total cases and deaths worldwide
-total population that was vaccinated by rolling count of new vaccinations

```
SELECT * 
FROM PortfolioProject.covid_deaths
ORDER BY 3,4 ;


SELECT location,date,total_cases,total_deaths,CONCAT((total_deaths/total_cases)*100,'%')
FROM PortfolioProject.covid_deaths
ORDER BY 1,2 ;

-- Looking at countries with highest infection rate compared to population

SELECT location,Population,MAX(total_cases) as HighestInfectionCount,MAX(total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProject.covid_deaths
GROUP BY location,population
ORDER BY PercentPopulationInfected DESC;


-- Show country with highest death count

SELECT location,MAX(convert(total_deaths,unsigned)) as TotalDeathCount
FROM PortfolioProject.covid_deaths
WHERE continent IS NOT NULL AND continent <> '' 
GROUP BY location
ORDER BY TotalDeathCount DESC;


-- Showing continents with highest death count
SELECT continent,MAX(convert(total_deaths,unsigned)) as TotalDeathCount
FROM PortfolioProject.covid_deaths
WHERE continent IS NOT NULL AND continent <> '' 
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Show total cases and deaths worldwide
SELECT SUM(new_cases) as total_cases,SUM(convert(new_deaths,unsigned)) as total_deaths,
SUM(convert(new_deaths,unsigned))/SUM(new_cases)*100 as death_percentage
FROM PortfolioProject.covid_deaths
WHERE continent IS NOT NULL AND continent <> '' 
ORDER BY 1,2;


-- look at total population that was vaccinated by rolling count of new vaccinations

SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(convert(vac.new_vaccinations,unsigned)) OVER (PARTITION BY dea.location ORDER BY dea.date) as rolling_vaccinated
FROM PortfolioProject.covid_deaths dea 
JOIN PortfolioProject.covid_vaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND dea.continent <> '' 
ORDER BY 2,3 ;


-- create view

CREATE VIEW PercentagePopulationVaccinated AS	
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(convert(vac.new_vaccinations,unsigned)) OVER (PARTITION BY dea.location ORDER BY dea.date) as rolling_vaccinated
FROM PortfolioProject.covid_deaths dea 
JOIN PortfolioProject.covid_vaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND dea.continent <> '' 
ORDER BY 2,3 ;

-- select view

SELECT * FROM PortfolioProject.percentagepopulationvaccinated;

```
