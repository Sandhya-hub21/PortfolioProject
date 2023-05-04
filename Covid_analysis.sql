select location,date,total_cases,new_cases,total_deaths 
from PortfolioProject..CovidDeaths
order by 1,2

--- Looking at total cases vs Total Deaths
--- Shows the % of deaths in country India

select location,date,total_cases,total_deaths, (total_deaths/ cast(total_cases as float)) * 100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%India%'
order by 1,2

-- Looking at Total cases v/s popoulation
-- Shows what percentage of population got covid in India

select location,date,total_cases,population, (total_cases/ population) * 100 as Cases_Percentage
from PortfolioProject..CovidDeaths
where location like '%India%'
order by 1,2

-- Looking at countries with Hightest infection rate compared to population

select location,population,Max(total_cases) as HightestInfection_count, Max((total_cases/ population)) * 100 as PercentagePopInfec
from PortfolioProject..CovidDeaths
--where location like '%India%'
group by location,population
order by PercentagePopInfec desc

-- Showing the countries with Highest death count per population
-- Let's break things by continent
select continent,Max(total_deaths) as total_deaths, Max((total_deaths/ population)) * 100 as PercentageDeaths
from PortfolioProject..CovidDeaths
--where location like '%India%'
where continent is not null
group by continent
order by PercentageDeaths desc

-- Global Numbers
select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, nullif(sum(new_deaths),0) /nullif(sum(new_cases),0)*100 as DeathPerc
from PortfolioProject..CovidDeaths
--where location like '%India%'
where continent is not null


-- Looking at Total Population vs population
with pop_perc (continent,location,date, population,new_vaccinations,RollingppVacc)
as
(
select da.continent,da.location,da.date,da.population,vac.new_vaccinations,
 sum(cast(vac.new_vaccinations as bigint)) over (partition by da.location order by da.location, da.date) as RollingppVacc

from PortfolioProject..CovidDeaths da
 join PortfolioProject..CovidVaccinations vac
 on (da.location = vac.location)  and (da.date = vac.date)
 where da.continent is not null)

 select *, (RollingppVacc / population) * 100 as per from pop_perc


 


 
 
 


