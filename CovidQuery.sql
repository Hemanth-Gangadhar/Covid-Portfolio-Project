Select *
From [Covid Project]..CovidDeaths$
where continent is not null
order by 3,4

--selecting data to work on

Select location, date, total_cases, new_cases, total_deaths, population
from [Covid Project]..CovidDeaths$
order by 1, 2

--Total Cases vs Total Deaths in INDIA
--To check rate of death of people who contracted covid
Select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [Covid Project]..CovidDeaths$
where location like '%INDIA%'
order by 1, 2


--Total Cases vs Popuation in INDIA
--To check rate of contraction
Select location, date, total_cases,population, (total_deaths/population)*100 as ContPercentage
from [Covid Project]..CovidDeaths$
where location like '%INDIA%'
order by 1, 2


--Highest Infection Rate to Population in every country

Select location,population , MAX(total_cases) as HighestInfectionCount, MAX((total_deaths/population)*100) as ContPercentage
from [Covid Project]..CovidDeaths$
where continent is not null
group by location, population 
order by ContPercentage desc

--Showing Continent with Highest Death count per Population

Select continent, MAX(cast(total_deaths as int)) as ContinentDeathCount
from [Covid Project]..CovidDeaths$
where continent is not null
group by continent
order by ContinentDeathCount desc


--Showing Countries with Highest Death count per Population

Select location, MAX(cast(total_deaths as int)) as CountryDeathCount
from [Covid Project]..CovidDeaths$
where continent is not null
group by location 
order by TotalDeathCount  desc


--Global new cases, new deaths, deathPercentage at each date


Select date,SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, 
            SUM(cast(new_deaths as int))/SUM(new_cases)* 100 as DeathPercentage
from [Covid Project]..CovidDeaths$
where continent is not null
group by date 
order by 1, 2


--Total Populations vs Vaccinations

with PopvsVac (continent, location, date, population, new_vaccinations, RollingVac)
as
(
select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM (convert(bigint,v.new_vaccinations) ) 
 OVER (partition by d.location order by d.location,d.date) as RollingVac
  
from [Covid Project]..CovidDeaths$ d
join [Covid Project]..CovidVaccinations$ v
  on d.location = v.location
  and d.date = v.date
where d.continent is not null
 )
select *, (RollingVac/population)*100 as VacPercent
from PopvsVac


--Creating view for Visualization

create view VacPercent as
select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM (convert(bigint,v.new_vaccinations) ) 
 OVER (partition by d.location order by d.location,d.date) as RollingVac
  
from [Covid Project]..CovidDeaths$ d
join [Covid Project]..CovidVaccinations$ v
  on d.location = v.location
  and d.date = v.date
where d.continent is not null
