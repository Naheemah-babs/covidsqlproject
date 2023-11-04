--SELECT *
--FROM [COVID PROJECT]..CovidDeaths$
--ORDER BY 3,4

--SELECT *
--FROM [COVID PROJECT]..COVIDVACC$
--ORDER BY 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From [COVID PROJECT]..COVIDDeaths$
order by 1,2

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [COVID PROJECT]..COVIDDeaths$
Where location like '%states%'
order by 1,2

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [COVID PROJECT]..COVIDDeaths$
Where location like '%nigeria%'
order by 1,2

--population percentage with covid
Select Location, date, population, total_cases, (total_deaths/population)*100 as infectedPercentage
From [COVID PROJECT]..COVIDDeaths$
Where location like '%nigeria%'
order by 1,2

Select Location, population, max(total_cases) as HighestInfectionCount, max(total_cases/population)*100 as highestinfectedpercentage
From [COVID PROJECT]..COVIDDeaths$
--Where location like '%nigeria%'
group by Location, Population
order by highestinfectedpercentage desc

Select Location, max(total_cases) as HighestInfectionCount, max(total_cases/population)*100 as highestinfectedpercentage
From [COVID PROJECT]..COVIDDeaths$
--Where location like '%nigeria%'
group by Location, Population
order by highestinfectedpercentage desc

--countries with highest death count
Select Location, max(cast(Total_deaths as int)) as TotaLDeathCount
From [COVID PROJECT]..CovidDeaths$
where continent is not null
Group by Location
Order  by TotaLDeathCount desc

-- continent with highest death count
Select continent, max(cast(Total_deaths as int)) as TotaLDeathCount
From [COVID PROJECT]..CovidDeaths$
where continent is not null
Group by continent
Order  by TotaLDeathCount desc

Select location, max(cast(Total_deaths as int)) as TotaLDeathCount
From [COVID PROJECT]..CovidDeaths$
where continent is  null
Group by location
Order  by TotaLDeathCount desc

Select date, sum(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(New_cases) * 100 as DeathPercentage
From [COVID PROJECT]..CovidDeaths$
WHERE CONTINENT IS NOT NULL
Group By date

Select sum(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(New_cases) * 100 as DeathPercentage
From [COVID PROJECT]..CovidDeaths$
WHERE CONTINENT IS NOT NULL
--Group By date
ORDER BY 1,2

Select *
From [COVID PROJECT]..CovidDeaths$ dea
Join [COVID PROJECT]..COVIDVACC$ vac
	On dea.location = vac.location
	and dea.date = vac.date

-- total population vs vaccinations
select dea.continent, dea.location, dea.population, vac.new_vaccinations
From [COVID PROJECT]..CovidDeaths$ dea
Join [COVID PROJECT]..COVIDVACC$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 1,2,3

--CTE Table
With Popvsvac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
From [COVID PROJECT]..CovidDeaths$ dea
Join [COVID PROJECT]..COVIDVACC$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3
)
Select *, (RollingPeopleVaccinated/Population) * 100
From Popvsvac

-- Temp Table
DROP Table if exists #PercentPopulationVaccinated
CREATE Table #PercentPopulationVaccinated

(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
From [COVID PROJECT]..CovidDeaths$ dea
Join [COVID PROJECT]..COVIDVACC$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3

Select *, (RollingPeopleVaccinated/Population) * 100
From #PercentPopulationVaccinated


Create View PercentPopulationVaccinated4 as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
From [COVID PROJECT]..CovidDeaths$ dea
Join [COVID PROJECT]..COVIDVACC$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3

--Select *
--From PercentPopulationVaccinated