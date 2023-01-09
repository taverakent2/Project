/*
Covid 19 Data Exploration

Skills used: Joins, CTE's Temp Tables, Window Functions, Agregate Functions, Creating View, 
Converting Data Types

*/

Select *
From Project..CC
Order by 3,4

--Select data that we are going to be using

Select location, date, total_cases,new_cases, population
From Project..cc
Order by 1 ASC

--Looking at Total Cae vs Country population
--Shows the growing rate of Covid Cases and Percentage of people
--that contracted the illness in solely one Country. Ex: U.S.

Select location, date, total_cases, population, (total_cases / population)
* 100 AS 'Case Percentage'
From Project..CC
--Where location like '%states%'
Order by 1,2


--Looking at Countries with Highest Infection Rate compared to
--Population

Select location, Max(total_cases) as HighestInfectionCount, population,
Max(total_cases / population) * 100 AS 'CasePercentage'
From Project..cc
Group by location, population, total_cases

--Breaking things down by Continents
Select continent, MAX(total_cases) as Total_cases
From Project..CC
--Where location is '%states%'
Where continent is not null
Group by continent
Order by continent Desc


-- Global Numbers

Select date, Sum(tottal_cases) OVER (Order BY date) as Total_cases),
(Select Sum(population) From Project..CC) as Global_Numbers, Sum(total_cases)
Over (Order by date) / (Select Sum(population) From Project..CC)* 100
AS 'CasePercentage'
From Project..CC
Where not Total_cases = 0
Group by date, population, total_cases




--- Looking at Total Population vs Vaccination



Select cases.continent, cases.location, cases.date, cases.population
vac.new_vaccinations, Sum(Convert(int,vac.new_vaccinations)) OVER
(Partition by cases.location
Order by cases.location, cases.date) as Rolling_People_Vaccinated
From Project..CC cases
Join Project..CV vac
		On cases.location = vac.location
		and cases.date = vac.date
	Where not cases.continent = ' ' And not vac.new_vaccinations = ' '
	Order by 2,3

	--or Cast

Select cases.continent, cases.location, cases.date, cases.population
vac.new_vaccinations, Sum(Cast(vac.new_vaccinations as int)) OVER
(Partition by cases.location
Order by cases.location, cases.date) as Rolling_People_Vaccinated
From Project..CC cases
Join Project..CV vac
		On cases.location = vac.location
		and cases.date = vac.date
	Where not cases.continent = ' ' And not vac.new_vaccinations = ' '
	Order by 2,3




	--Use CTE
	with PopvsVac (Continent, Location, Date, Population, new_vaccinations,
	Rolling_People_Vaccinated)
		as
		(
			Select cases.continent, cases.location, cases.date, cases.population
vac.new_vaccinations, Sum(Convert(int,vac.new_vaccinations)) OVER
(Partition by cases.location
Order by cases.location, cases.date) as Rolling_People_Vaccinated
From Project..CC cases
Join Project..CV vac
		On cases.location = vac.location
		and cases.date = vac.date
	Where not cases.continent = ' ' And not vac.new_vaccinations = ' '
	Order by 2,3
	) 
	Select *, (Rolling_People_Vaccinated/Population) * 100
	From PopvsVac


	--Temp Tables

	Drop Table if exists #Percent_population_Vaccinated
	Create Table #Percent_Population_Vaccinated
	(
	Continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	Population numeric,
	New_Vaccination numeric,
	Rolling_People_Vaccinated numeric
	)

	Insert into #Percent_Population_Vaccinated
		Select cases.continent, cases.location, cases.date, cases.population
vac.new_vaccinations, Sum(Convert(int,vac.new_vaccinations)) OVER
(Partition by cases.location
Order by cases.location, cases.date) as Rolling_People_Vaccinated
From Project..CC cases
Join Project..CV vac
		On cases.location = vac.location
		and cases.date = vac.date
	Where not cases.continent = ' ' And not vac.new_vaccinations = ' '
	Order by 2,3

	Select *, (Rolling_People_Vaccinated/Population) * 100
	From #Percent_Population_Vaccinated

	-- Creating Vew to store data for later Visualization

	Use Project
	Go

	Create view Percent_Population_Vaccinated as
			Select cases.continent, cases.location, cases.date, cases.population
vac.new_vaccinations, Sum(Convert(int,vac.new_vaccinations)) OVER
(Partition by cases.location
Order by cases.location, cases.date) as Rolling_People_Vaccinated
From Project..CC cases
Join Project..CV vac
		On cases.location = vac.location
		and cases.date = vac.date
	Where not cases.continent = ' ' And not vac.new_vaccinations = ' '
	--Order by 2,3

	Select *
	From Percent_Population_Vaccinated






