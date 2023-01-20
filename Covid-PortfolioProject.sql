/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

--Select *
--From CovidDeaths
--order by 3,4

--Select *
--From CovidVaccinations
--order by 3,4


Select location,date,total_cases,new_cases,total_deaths,population
From CovidDeaths
Order by 1,2

---1.Looking at likelihood of death in case infected i.e. Death Percentages
Select location,date,total_cases,total_deaths,(total_deaths/total_cases) *100 as DeathPercentage 
From CovidDeaths
Order by 1, DeathPercentage desc

--looking at percentages in India
Select location,date,total_cases,total_deaths,(total_deaths/total_cases) *100 as DeathPercentage 
From CovidDeaths
where location = 'India'
Order by DeathPercentage desc

---looking at percentages in US
Select location,date,total_cases,total_deaths,(total_deaths/total_cases) *100 as DeathPercentage 
From CovidDeaths
where location like '%states%'
Order by DeathPercentage desc

---2.Looking at likelihood of getting infected i.e. what percentage of population is likely to be infected
Select location,date,Population,total_cases,(total_cases/Population) *100 as InfectionRate 
From CovidDeaths
Order by 1, InfectionRate desc

---In India
Select location,date,Population,total_cases,(total_cases/Population) *100 as InfectionRate 
From CovidDeaths
where location = 'India'
Order by InfectionRate desc

---In US
Select location,date,Population,total_cases,(total_cases/Population) *100 as InfectionRate 
From CovidDeaths
where location like '%states%'
Order by InfectionRate desc

---Looking at countries with Highest Infection rate (percentage) and highest count of total cases (number)
Select location,population,max ((total_cases/Population)*100) as HighestInfectionRate , max(total_cases) as HighestInfectionCount
From CovidDeaths
Group by location,population
Order by HighestInfectionRate desc

-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc

---2. BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc

-- 3.GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
--Group By date
order by 1,2

--4. Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 