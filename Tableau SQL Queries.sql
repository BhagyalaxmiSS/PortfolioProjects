/* 
Queries Used for Tableau Project
*/

--1
--Global Numbers
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as  total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
From PortfolioProject.dbo.CovidDeaths
Where continent is not null
Order by 1,2

--2
--Total Deaths Per Continent
Select location, Sum(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject.dbo.CovidDeaths
Where continent is null and location not in ('World', 'European Union', 'International')
Group by location
Order by TotalDeathCount desc

--3
--Percent Population Infected Per Country
select Location,Population, max(total_cases) AS HighestInfectionCount, Max(total_cases/population)*100 AS PercentPopulationInfected
From PortfolioProject.dbo.CovidDeaths 
Group by Location,Population
Order By  PercentPopulationInfected desc

--4
--Percent Population Infected
select Location,Population,date, max(total_cases) AS HighestInfectionCount, Max(total_cases/population)*100 AS PercentPopulationInfected
From PortfolioProject.dbo.CovidDeaths 
Group by Location, Population, date
Order By  PercentPopulationInfected desc