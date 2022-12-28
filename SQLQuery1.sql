/*
Covid 19 Data Exploration

Skills used: Joins, CTE's, Temp Tables, Window Functions, 
Aggregate Functions, Creating View, Converting Data Types

*/

	Select *
	From Project..CC
	Order by 3,4

	
	--Select *
	--From Project..CV
	--Order by 3,4

	-- Select data that we are going to be using

	Select location, date, total_cases, new_cases, population
	From Project..CC
	Order by 1 ASC

	--Looking at Total Cases vs Country population
	--Shows the growing rate of Covid Cases and Percentage of people
    --that contracted the illness in the US

	Select location, date, total_cases, population, (total_cases / population) * 100 AS 'Case Percentage'
	From Project..CC
	--Where location like '%states%'
	Order by 1, 2
	

	--Looking at Countries with Highest Infection Rate compared
	--to Population

	Select location, Max(total_cases) as HighestInfectionCount, population
	,Max(total_cases / population) * 100 AS CasePercentage
	From Project..CC
	Group by location, population, total_cases

	-- Breakng things down now by Continents
	Select Continent, Max(Total_Cases) as Total_cases
	From Project..CC
	--Where location like %states%
	Where continent is not null
	Group by continent
	Order by continent Desc



	-- Global Numbers
	
	Select date, SUM(total_cases) Over (Order BY date) as Total_Cases, 
	(Select Sum(population) From Project..CC) as Global_Numbers, 
	SUM(total_cases) Over (Order BY date) / (Select Sum(population) From Project..CC) * 100
	AS 'Case Percentage'
	From Project..CC
	Where not Total_Cases = 0
	Group by date, population, total_cases



	-- Looking at Toal Population vs Vaccination

	Select cases.continent, cases.location, cases.date, cases.population,
	vac.new_vaccinations, SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by cases.location
	Order by cases.location, cases.date) as Rolling_People_Vaccinated
	From Project..CC cases
	Join Project..CV vac
		On cases.location = vac.location
		and cases.date = vac.date
	where not cases.continent = ' ' And not vac.new_vaccinations = ' '
	Order by 2,3

	--or (Cast)

		Select cases.continent, cases.location, cases.date, cases.population,
	vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by cases.location
	Order by cases.location, cases.date) as Rolling_People_Vaccinated
	From Project..CC cases
	Join Project..CV vac
		On cases.location = vac.location
		and cases.date = vac.date
	where not cases.continent = ' ' And vac.new_vaccinations = ' '
	Order by 2,3


	--Use CTE
	with PopvsVac (Continent, Location, Date, Population,new_vaccinations, Rolling_People_Vaccinated)
	as
	(
		Select cases.continent, cases.location, cases.date, cases.population,
	vac.new_vaccinations, SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by cases.location
	Order by cases.location, cases.date) as Rolling_People_Vaccinated
	From Project..CC cases
	Join Project..CV vac
		On cases.location = vac.location
		and cases.date = vac.date
	where not cases.continent = ' ' And not vac.new_vaccinations = ' '
	--Order by 2,3
	)
	Select *, (Rolling_People_Vaccinated/Population) * 100
	From PopvsVac


	--Temp Tables

	Drop Table if exists #Percent_Population_Vaccinated
	Create Table #Percent_Population_Vaccinated
	(
	Continent nvarchar(255),
	Location nvarchar (255),
	Date datetime,
	Population numeric,
	New_vaccination numeric,
	Rolling_People_Vaccinated numeric
	)


	Insert Into #Percent_Population_Vaccinated
		Select cases.continent, cases.location, cases.date, cases.population,
	vac.new_vaccinations, SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by cases.location
	Order by cases.location, cases.date) as Rolling_People_Vaccinated
	From Project..CC cases
	Join Project..CV vac
		On cases.location = vac.location
		and cases.date = vac.date
	where not cases.continent = ' ' And not vac.new_vaccinations = ' '
	Order by 2,3

	Select *, (Rolling_People_Vaccinated/Population) * 100
	From #Percent_Population_Vaccinated

	-- Creating View to store data for later Visualization

	Use Project
	Go
	
	Create View Percent_Population_Vaccinated as 
		Select cases.continent, cases.location, cases.date, cases.population,
	vac.new_vaccinations, SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by cases.location
	Order by cases.location, cases.date) as Rolling_People_Vaccinated
	From Project..CC cases
	Join Project..CV vac
		On cases.location = vac.location
		and cases.date = vac.date
	where not cases.continent = ' ' And not vac.new_vaccinations = ' '
	--Order by 2,3

	Select *
	From Percent_Population_Vaccinated