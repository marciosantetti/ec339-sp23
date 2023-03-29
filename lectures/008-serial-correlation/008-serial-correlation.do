*-----------------------------------------------------------------------*
*												                        *
*												                        *
*                     EC 339: APPLIED ECONOMETRICS                      *    
*												                        *
*  Prof. Santetti									                    *
*-----------------------------------------------------------------------*



*------------------------------------------------------*
*            SERIAL CORRELATION IN PRACTICE            *
*------------------------------------------------------*


* Whenever using Stata, your first step should always be
* setting your working directory (that is, where your data files)
* will come from, and where you will save your work.

* In the top left corner, simply go to "File" > "Change Working Directory" > and choose
* your desired folder. Your data files should be there as well,
* so Stata can find and import it.


**---------------------------------------------------------

**--- Okun's law model:

** Let us reproduce the model we saw in class, exploring Okun's law for 
** the Australian economy between 1978Q2 and 2016Q2.


**---------------------------------------------------------


clear

use okun


** Notice that we are working now with time-series data (we are observing 
** the behavior of one or more variables over time).

** whenever working with time-series data in Stata, we have
** perform a few steps before using the data.



* Notice how the "date" column is formatted:


browse


* Since these are quarterly data, a good idea is to generate a new column with
* the date rows. 

* For quarterly data, we use the "tq" function:

* Note that we put the starting year (1978), followed by the first available quarter (in our case, q2):


gen period = tq(1978q2) +_n-1



* Quick check:

browse


* It is not ready yet. The second step is to format the new column to a quarterly frequency:


format period %tq


* Quick check:

browse


* The last step is to tell Stata that this new column is 
* of a date class.


tsset period



* If we want, we can drop the "date" column.


drop date




** Now our data are ready to go.



**---------------------------------------------------------


** For time-series data, we can use the "tsline" command:


twoway (tsline g)


* Or with both series in the same plot:


twoway (tsline g u)


**---------------------------------------------------------



** For Okun's law, we need to create the change in unemoployment rate, du.


** "du" is the difference between this period's unemployment rate (at time t)
** and last period's unemployment rate (at time t-1).

** Values of variables in previous periods are called "lagged" values,
** and are easily computed in Stata by using the "L." function.

** In Stata language:


gen lag_u = L1.u


** And du is nothing but du = u - lag_u


gen du = u - lag_u



**---------------------------------------------------------


**--- Okun's law regression model:


reg du g




** We can store its residual term, epsilon:


predict epsilon, residuals


twoway (tsline epsilon)



** From a visual perspective, it is not always straightforward to assess whether the error term is
** autocorrelated or not.

** Therefore, we need some statistical tests for a better inference.



**---------------------------------------------------------


**--- Testing for serial correlation:


** Let us first use the Stata commands for the Durbin-Watson (DW) and Breusch-Godfrey (BG) tests.



** Durbin-Watson (DW) test:

reg du g

estat dwatson

* The function gives us the "d" test statistic, which we compare with 
* upper and lower values given by the Durbin-Watson table.

* At 5% of significance, and a sample size of 152 and k = 1 slope coefficient, the table gives us lower and upper values of
* 1.72 and 1.75, respectively.

* So what is our decision?



** Breusch-Godfrey (BG) test:



estat bgodfrey, lag(1) nomiss0


** To further explore the options above

help estat bgpodfrey




**---------------------------------------------------------




**--- Now, where do these results come from?


** First, for the DW test.

** Its test statistic can be approximated by 2*(1 - rho), 
** where "rho" is the error term's autocorrelation coefficient.

** So let's estimate "rho":


reg epsilon L1.epsilon, noconstant



** We can also look at the Autocorrelation Function (ACF) plot for this residual:


ac epsilon


** Next, we just plug into the DW test statistic:

display 2 * (1 - _b[L1.epsilon])


** Is the value above close to the one given by the "estat dwatson" function?





**--- Now, to the Breusch-Godfrey test.

** It requires a more comprehensive auxiliary regression for the regression's residuals,
** also including the independent variable(s) from the original model. 


reg epsilon L1.epsilon g


** Its test statistic is given by LM = (n - q)*R2, where R2 is the coefficient of determination
** from this latter auxiliary regression. "n" is the sample size, and "q" is the
** order of autocorrelation we are testing for.


** So...


display (152 - 1) * 0.1202

** Is this test statistic close to the one given by the "estat bgodfrey" function?



*---------------------------------------------------------


** Dealing with serial correlation:


** Given that we have serial correlation in our Okun's law model,
** we cannot trust in its standard errors. Therefore, inference from this model is unreliable.


** As a solution for first-degree serial correlation, we can use the Cochrane-Orcutt (CO) estimator:



prais du g, corc


** What do we conclude?


** We can check out Stata's documentation on the function:

help prais




*---------------------------------------------------------


**--- A second example: interest rates vs. profit rates in the US (1955-2016)




** Data prep:


clear

use macro_data


** We are dealing with annual data, so we can use the "year" column as our time variables

tsset year





*--

** creating time series for the real interest
** rate and the profit rate:

gen real_int_rate = ifedfunds - infrate

gen profit_rate = (cp / k) * 100



** Visually:

twoway (tsline real_int_rate)

twoway (tsline profit_rate)


**--- Regression model:


reg real_int_rate profit_rate




**--- Testing for serial correlation:


estat dwatson


estat bgodfrey, lag(1) nomiss0




**--- Correcting for serial correlation:



prais real_int_rate profit_rate, corc
