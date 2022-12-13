select *
From PortfolioProject.dbo.CovidDeaths
Where continent is not null
Order by 3,4

select location, total_deaths
From PortfolioProject.dbo.CovidDeaths

--select *
--From PortfolioProject.dbo.CovidVaccinations
--Order by 3,4

Select Location, date, total_cases, new_cases,total_deaths,population
from PortfolioProject.dbo.CovidDeaths
Where continent is not null
order by 1,2

--Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in

Select Location, date, population,  total_cases,total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
from PortfolioProject.dbo.CovidDeaths
where location like '%India%' and continent is not null
order by 1,2

--Loking at Total Cases vs Population
--Shows what percentage of population got Covid

Select Location, date, population,  total_cases, (total_cases/population)*100 AS PercentPopulationInfected
From PortfolioProject.dbo.CovidDeaths
--where location = 'India'
order by 1,2


--Looking at Countries with Highest Infection Rate compared to Population

select Location,Population, max(total_cases) AS HighestInfectionCount, Max(total_cases/population)*100 AS PercentPopulationInfected
From PortfolioProject.dbo.CovidDeaths 
Group by Location,Population
Order By  PercentPopulationInfected desc

--Showing Countries with Highest Death Count per population

Select location, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject.dbo.CovidDeaths
Where continent is not null
Group by location
Order by TotalDeathCount desc

--LET'S BREAK THINGS BY CONTINENT


--Showing continents with the highest death count per population

Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject.dbo.CovidDeaths
Where continent is not null
Group by continent 
Order by TotalDeathCount desc

--GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as  total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
From PortfolioProject.dbo.CovidDeaths
Where continent is not null
Order by 1,2

--Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location order by 
dea.location,dea.Date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null 
Order by 2,3

--USE CTE

With PopvsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location order by 
dea.location,dea.Date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null 
--Order by 2,3
)
select *,(RollingPeopleVaccinated/Population)*100
From PopvsVac

--TEMP TABLE
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(225),
Location nvarchar(225),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location order by 
dea.location,dea.Date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
--Where dea.continent is not null 
--Order by 2,3
select *,(RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

--Creating View to store data for later visualization
Drop Table if exists #PercentPopulationVaccinated
Create View ParcentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location order by 
dea.location, dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
   ON dea.location = vac.location
   and dea.date = vac.date
Where dea.continent is not null 
--Order by 2,3

select *
From ParcentPopulationVaccinated 
