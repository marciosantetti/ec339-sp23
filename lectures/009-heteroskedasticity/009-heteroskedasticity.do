*-----------------------------------------------------------------------*
*																		
*																		
*                     EC 339: APPLIED ECONOMETRICS                            
*																		
*  Prof. Santetti														
*-----------------------------------------------------------------------*



*------------------------------------------------------*
*            HETEROSKEDASTICITY IN PRACTICE            *
*------------------------------------------------------*


* Whenever using Stata, your first step should always be
* setting your working directory (that is, where your data files)
* will come from, and where you will save your work.

* In the top left corner, simply go to "File" > "Change Working Directory" > and choose
* your desired folder. Your data files should be there as well,
* so Stata can find and import it.


**---------------------------------------------------------


**--- As a first applied example, let us use a sample from the 2018 American Community Survey (ACS), 
**--- downloaded from IPUMS (Integrated Public Use Microdata Series).


clear


use het_data


**-- Quick visual inspection:


twoway (scatter personal_income education)


** By gender:


twoway (scatter personal_income education if i_female == 1) (scatter personal_income education if i_female == 0)


**--- Estimating a regression model:


reg personal_income education i_female



** Extracting the residuals:

predict u, residuals


twoway (scatter u education)


**---------------------------------------------------------

**--- Testing for heteroskedasticity:



**-- Breusch-Pagan (BP) test:


estat hettest, iid   


**-- White test:


estat imtest, white


**---------------------------------------------------------

**--- Manually estimating the Breusch-Pagan test:


* First, we need to estimate an auxiliary regression, with the squared residual term as the
* dependent variable, and the independent variables from the original model maintained on
* this new model's right-hand-side.


gen u_sq = u^2

* Auxiliary regression:

reg u_sq education i_female


* Extracting the R-squared from this regression: 0.0158


* Calculating the test statistic: LM = n * R2

display 5000 * 0.0158


** Is the test statistic close to the one given by the Stata command?



**--- Manually estimating the White test:


* The only difference in the White test's procedure is that we take into account model misspecification.
* Therefore, similarly to the RESET test, we put the fitted values for the dependent variable
* and potential functional forms that may be contributing to heteroskedasticity.


* From the original regression:


reg personal_income education i_female


* We extract the fitted values (y_hat):


predict y_hat


gen y_hat_sq = y_hat^2


* White test's auxiliary regression:


reg u_sq y_hat y_hat_sq



* Extracting the R-squared from this regression: 0.0249


* Calculating the test statistic: LM = n * R2

display 5000 * 0.0249


**---------------------------------------------------------



**--- Robust Standard Errors:


** Using MacKinnon-White standard errors:


reg personal_income education i_female, robust


**--------------------------------------------------------




**--- Now, replicate the results from the last lecture's slides
**--- for the housing price data (hprice2.dta file).





**--------------------------------------------------------


** BONUS: Using the "estout" package to display regression output tables for publication:




* First, we need to install the package (only need to do it once):


ssc install estout, replace


* Every time we run a regression model that we want to show in our table, 
* we use "eststo: reg [variables here]"

* example:


eststo: reg personal_income education i_female


** Then, to display the table, we say


esttab

* To replace t-statistics with standard errors and add the R2 measures:

esttab, se r2 ar2 brackets


* A second model:


eststo: reg personal_income education i_female, robust


esttab, se r2 ar2 brackets



* Lastly, we can export teh table as soon as we are happy with it:


esttab using example_heteroskedasticity.rtf 






