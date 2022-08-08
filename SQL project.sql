
-- Start off by examining the data tables and looking at the columns to see what data we're working with. 
SELECT *
FROM dbo.CovidDeaths$

SELECT * 
FROM dbo.CovidVaccinations$

-- Focus on Covid deaths first and limit the columns to begin looking for trends and relationships. 

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM dbo.CovidDeaths$
ORDER BY 1,2

-- Looking at Total Cases vs. Total Deaths in the world
-- Shows likelihood of dying if you contract covid in your country 

SELECT Location, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 AS 'Death Percentage'
FROM dbo.CovidDeaths$
ORDER BY 1,2;

-- Looking at Total Cases vs. Total Deaths in the United States

SELECT Location, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 AS 'Death Percentage'
FROM dbo.CovidDeaths$
WHERE Location like '%states%'
ORDER BY 1,2;


-- Looking at Total Cases vs. Population
-- Shows what percentage of population contracted Covid

SELECT Location, date, total_cases, population, (Total_cases/population)*100 AS 'Contracted Covid Population'
FROM dbo.CovidDeaths$
ORDER BY 1,2

-- Looking at countries with the Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) AS 'Highest Infection Count', MAX((total_cases/population))*100 as 'Percent Population Infected'
FROM dbo.CovidDeaths$
GROUP BY location, population 
ORDER BY [Percent Population Infected] desc

-- Looking at the countries with the Highest Amount of Deaths 

SELECT Location, MAX(cast(Total_deaths as int)) as 'Total Death Count'
FROM dbo.CovidDeaths$
WHERE continent is not null
GROUP BY Location
ORDER BY [Total Death Count] desc

-- Looking at Continents 

SELECT Continent, MAX(cast(Total_deaths as int)) as 'Total Death Count'
FROM dbo.CovidDeaths$
WHERE continent is not null
GROUP BY continent
ORDER BY [Total Death Count] desc

SELECT location, MAX(cast(Total_deaths as int)) as 'Total Death Count'
FROM dbo.CovidDeaths$
WHERE continent is  null
GROUP BY location 
ORDER BY [Total Death Count] desc


-- Global Numbers 

SELECT date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_cases)*100 as 'DeathPercentage'
FROM dbo.CovidDeaths$
WHERE continent is not null 
GROUP BY date
ORDER BY 1,2

-- Looking at Total Population vs. Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM dbo.CovidDeaths$ dea
JOIN dbo.CovidVaccinations$ vac ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
