SELECT count(*)
FROM covid_data_csv cdc 
;

SELECT population
FROM covid_data_csv cdc
order by 1 desc
limit 11755 ;


SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS 
  WHERE table_name = 'tbl_name' AND COLUMN_NAME = 'col_name';  

DESCRIBE Portifolio_Proj.covid_data_csv 


select population, total_deaths , (population/total_deaths)*100
from covid_data_csv cdc ;


SELECT count(*)
FROM covid_vaccinations_csv cvc ; 
 

SELECT* 
FROM covid_vaccinations_csv cvc
where continent  is not null
order by 3,4 desc;



 ----- SELECTING DATA THAT WE'RE GOONA BE USING
 
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid_data_csv cdc 
where continent  is not null
order by 1,2;


SELECT location, continent, total_cases, new_cases, total_deaths, population
FROM covid_data_csv cdc 
where location  like '%world%';



----looking at the total_cases vs total_deaths 

--- Show likelihood for you daying if you contract covid in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathsPercentage
FROM covid_data_csv cdc 
where location like  '%Brazil%' and  continent  is not null
order by 1,2 desc;


---------- LOOKING AT TOTAL CASES VS POPULATION
---------- SHOWS WHAT PERCENTAGE OF POPULATION GOT COVID

SELECT location, date, population , total_cases, (total_cases /population)*100 as PopPercentage
FROM covid_data_csv cdc 
where location like  '%Brazil%' and continent  is not null
order by 1,2 desc;


---------- Looking at countries with highest infection rate compared to population

SELECT location, population , max(total_cases) as highest, max(total_cases/population)*100 as HIghesttxinf
FROM covid_data_csv cdc 
-- where location like  '%Brazil%'
group by location, population 
order by HIghesttxinf desc;


--- showing countries with highest death count per population

SELECT location, max(total_deaths) as highest
FROM covid_data_csv cdc 
where continent  is not null and TRIM(continent) <> ''
group by location
order by highest desc;


---- LETS BREAK THINGS DOWN BY CONTINENT
---  SHOWING THE CONTINENTS WITH THE HIGHEST DEATH COUNT PER POPULATION


--- this query only shows the continents but it's not a accurate representation of the real number of cases

SELECT continent , max(total_deaths) as highest
FROM covid_data_csv cdc 
where continent is not null and TRIM(continent) <> ''
group by continent  
order by highest desc;


--- this query is more accuarte once it shows all the cases by continent and others views


SELECT location, max(total_deaths) as highest
FROM covid_data_csv cdc 
where continent = ''
group by location 
order by highest desc;


-- GLOBAL NUMBERS PER DAY

SELECT date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths,  (SUM(new_deaths))/(SUM(new_cases))*100 as perc_deaths
FROM covid_data_csv cdc 
where continent != ''
group by 1
order by 1 desc;

-- GLOBAL NUMBERS 

SELECT  SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths,  (SUM(new_deaths))/(SUM(new_cases))*100 as perc_deaths
FROM covid_data_csv cdc 
where continent != ''
order by 1 desc;





SELECT *
FROM covid_vaccinations_csv cvc 


------ LOOKING AT TOTAL POPULATION VS VACCINATIONS

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from covid_data_csv dea 
join covid_vaccinations_csv vac
on dea.location = vac.location
AND dea.date = vac.date
where dea.continent != ''
-- where dea.location = 'Brazil'
order by 2,3 DESC;


---- with cte table and PARTITION BT clause


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location
order by dea.location, dea.date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/dea.population
from covid_data_csv dea 
join covid_vaccinations_csv vac
on dea.location = vac.location
AND dea.date = vac.date
where dea.continent != ''
-- where dea.location = 'Brazil'
order by 2,3;



-- USING A CTE (COMON TABLE EXPRESSION)

WITH PopVsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location
order by dea.location, dea.date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100
from covid_data_csv dea 
join covid_vaccinations_csv vac
on dea.location = vac.location
AND dea.date = vac.date
where dea.continent != ''
-- where dea.location = 'Brazil'
-- order by 2,3
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopVsVac ;


--- USIGN TEMP TABLE 

DROP TABLE IF EXISTS PercentPopulationVaccinated

CREATE TEMPORARY TABLE PercentPopulationVaccinated
(
continent varchar(18),
location varchar (50), 
date varchar(16),
population varchar(50),
new_vaccinations varchar(50),
RollingPeopleVaccinated varchar(255)
)

INSERT INTO PercentPopulationVaccinated 
SELECT  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location
order by dea.location, dea.date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100
from covid_data_csv dea 
join covid_vaccinations_csv vac
on dea.location = vac.location
AND dea.date = vac.date
-- where dea.continent != '';
-- where dea.location = 'Brazil'
-- order by 2,3

SELECT *, (RollingPeopleVaccinated/population)*100
FROM PercentPopulationVaccinated ;


-- CRIATING  VIEW TO STORE DATA FOR LATER VISUALIZATIONS


CREATE VIEW PercentPopulationVaccinated_VIEW AS 
SELECT  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location
order by dea.location, dea.date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100
from covid_data_csv dea 
join covid_vaccinations_csv vac
on dea.location = vac.location
AND dea.date = vac.date
where dea.continent != '';
-- where dea.location = 'Brazil'
-- order by 2,3

SELECT* FROM  PercentPopulationVaccinated_VIEW;



































