Covid Project – Summary and Method

Method

The aim of this project is to capture and visually display data related to specific countries’ infection, death, and vaccination rates related to COVID-19 as well as to track certain economic and healthcare for country’s during the pandemic’s height and how they correlate with each other. There are no explicit hypotheses being tested.

Data Collection and Filtering

The data for this project comes from two open sources: the website Our World in Data (OWD) and the World Bank. The OWD’s data was downloaded via as a csv file from https://ourworldindata.org/covid-deaths,  and imported into Microsoft SQL Server Management Studio (SSMS). The World Bank data was taken from https://databank.worldbank.org/source/world-development-indicators with a pre-filtering and selection of relevant columns, then downloaded as a csv file and imported into SSMS. 
The reason for the importation of both sources from csv into SMSS was to allow for manipulation of the data. Given the data sources are no longer being updated, there is no need for live connections to the SSMS and so the data was copied from SMSS and transferred to an excel file, which was then imported into Power BI.

Upon pulling data into SMSS, certain operations were required which allowed for the execution of successful queries. A few data type changes were executed hence the CAST AS function being used in some queries. In order to establish a link to the World Bank Economic data and OWD Covid data, I needed to create a column showcasing both country and year.
Another obstacle in filtering the OWD Covid data came with the raw table having continent names listed under countries. The common patterns these continents had was that in the separate column “Continent” the value listed was null. Therefore, the data was able to be filtered through this null value under “Continents” which is seen in the SQL queries.
When checking the summarized results to understand if they made sense logically, an initial red flag was that the vaccination rates per population were higher than the population of the countries themselves. After further review, this is in fact accurate as several countries possessed high rates of their population receiving a first and second additional “booster” vaccination up until the end of the time period this data covers.
Only one action of filtering occurred inside of Power Bi through Powery Query to show only countries and not the results on global or continent totals which are present in the World Bank file. The data from OWD also had the global and continental totals, however, these made more since to filter out on certain visuals.

Visualizations

For the Map graph under the “Summary” Power BI page, colors were filled in according to a gradient of green to red, with red being 3 standard deviations away from the maximum value, yellow being the mean, and green being the lowest value. Setting red to 3 standard deviations away from the mean allowed for increased color variation as the very few outliers were extreme.

Conclusions

On the “Healthcare Costs and Deaths” tab, we see that there is a surprising negative correlation to out of pocket expenditures as a percentage of the total national health expenditure. This can likely be attributed to those countries which have a high percentage of also having a low GDP per capita meaning that testing is less available.

# CovidProject
Making sense of public data on Covid-19
