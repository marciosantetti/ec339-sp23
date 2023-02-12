*-----------------------------------------------------------------------*
*																		
*																		
*                     EC 339: APPLIED ECONOMETRICS                            
*																		
*  Prof. Santetti														
*-----------------------------------------------------------------------*



*------------------------------------------------------*
* THE CLASSICAL LINEAR REGRESSION MODEL IN PRACTICE    *
*------------------------------------------------------*


* Whenever using Stata, your first step should always be
* setting your working directory (that is, where your data files)
* will come from, and where you will save your work.

* In the top left corner, simply go to "File" > "Change Working Directory" > and choose
* your desired folder. Your data files should be there as well,
* so Stata can find and import it.


**------------------------------------------------------------------------



** Assumption 1: the model is linear in parameters, well-specified, 
** and contains an additive error term.



* Stata (and any other statistical software already takes care of the first and
* third points of this assumption. The hard part, however, is having
* a wel-specified model).

use chicken_demand


* make sure to check out the "chicken_demand.txt" file with all variable descriptions.


* Let us estimate a model for the demand for chicken, according to economic theory:

reg q p y pb


** Is this model well specified?

** Your answer:


**------------------------------------------------------------------------


**--- Assumption 2: the error term has a zero population mean.


* We can use the previous regression's residual term:

predict resid_chicken, residuals


mean resid_chicken


* Is this assumption verified?

* Your answer:

**------------------------------------------------------------------------


**--- Assumption 3: All explanatory variables are uncorrelated with the error term.


correlate resid_chicken p y pb



* Is this assumption verified?

* Your answer:


**------------------------------------------------------------------------


**--- Assumption 4: Observations of the error term are uncorrelated with each other.



twoway (scatter resid_chicken year) (line resid_chicken year)


* Is this assumption verified?

* Your answer:


**------------------------------------------------------------------------


**--- Assumption 5: the error term has a constant variance (homoskedasticity assumption)


** Now, we use a different data set:

clear


use food

gen lfood_exp = log(food_exp)
gen lincome = log(income)


reg food_exp income



predict resid_food, residuals


twoway (scatter resid_food income), yline(0)


* What is happening to the variance of the residual term as one's income increases?


* Your answer:


**------------------------------------------------------------------------


**--- Assumption 6: No explanatory variable is a perfect linear function
** of any other explanatory variable (no multicollinearity assumption).


clear

use chicken_demand



correlate p y pb


* Is this assumption verified?

* Your answer:


**------------------------------------------------------------------------


**--- Assumption 7: the error term is normally distributed.


** The Shapiro-Wilk test for normality is a common statistical test that we can
** apply for testing CLRM Assumption 7:



* H0: the random variable is normally distributed;
* Ha: H0 is not true.


swilk resid_chicken


* Is this assumption verified?

* Your answer:
