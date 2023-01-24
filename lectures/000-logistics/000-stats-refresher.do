*-----------------------------------------------------------------------
*-----------------------------------------------------------------------
*																		
*                     EC 339: APPLIED ECONOMETRICS                     
*      
*-----------------------------------------------------------------------																		
*  Prof. Santetti														
*-----------------------------------------------------------------------



*------------------------------------------------------*
* STATS REFRESHER & STATA INTRODUCTION				   
*------------------------------------------------------*


* Whenever using Stata, your first step shoul always be
* setting your working directory (that is, where your data files)
* will come from, and where you will save your work.

* In the top left corner, simply go to "File" > "Change Working Directory" > and choose
* your desired folder. Your data files should be there as well,
* so Stata can find and import it.



* Let us import an external data set into our environment. The 'cdc_data.csv' file 
* contains data on drug overdose deaths from the CDC and poverty and unemployment rates 
* from the University of Kentucky Poverty Research Center.
* Thanks to Kyle Raze for making the data set available.


* In the top left corner, simply go to "File" > "Import" > "Text data" > and 
* select the .csv file. We will usually work with data sets in this format.


* As soon as you import the data set, make sure to paste here the code that Stata generates
* on the main window. It should start with "import delimited ..."

* The next time you work with this .do file, you just run the code and 
* Sata will import it.


*---------------------------


*------- Now, to some basic statistical procedures:



* To browse the data (similar to an Excel overview):

browse


* For a quick summary (containing important statistics):

summarize


* In more detail...

summarize, detail


* For a more "custom" summary table, we can use the "tabstat" function:

tabstat poverty_rate unemployment_rate, statistics(n mean median variance sd min max)


*---------------------------


* If we want to create new variables, we use the "gen" function.
* Suppose we want the death rate per 100,000 people:

gen death_rate = deaths / population * 100000




*---------------------------


* To filter the data by a specifi year (say, 2017):


keep if (year == 2017) 


* whenever you modify your data set and want to save the modified version under a 
* different file name, use the "save" function:


save cdc_data17


* To use it,


use cdc_data17


*---------------------------


* Now, filter out more than 1 state and tabulate by state:


keep if (stname == "New York" | stname == "Utah")


tabstat poverty_rate unemployment_rate, by(year) statistics(mean sd median)



* Bonus: summarizing by more than 1 group (not required for now):

egen gp = group(year stname), label  

tabstat unemployment_rate, by(gp)



*---------------------------


*--- In addition to univariate measures (mean, median, variance, SD), 
* we can compute bivariate statistics:



* Correlation:

correlate unemployment_rate death_rate


* Covariance:

correlate unemployment_rate death_rate, covariance


*---------------------------


* Visualizing data:


*--- Scatter plots:


* Notice the variable ordering (first, y-, and then x-axis)

twoway (scatter unemployment_rate death_rate)

twoway (scatter poverty_rate death_rate)


*--- Histogram:


histogram death_rate


* Adding a density curve:


histogram death_rate, kdensity



*--- Box plot:


graph box (death_rate poverty_rate)



*---------------------------


*--- Quick challenge:

* Filter out only one state from the original cdc_data data set (say, NY).
* This way, you will have a time-series data set.

* Figure out how to plot the unemployment rate, poverty rate, and death rates
* variables over time.






