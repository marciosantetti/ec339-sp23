*-----------------------------------------------------------------------*
*												                        *
*												                        *
*                     EC 339: APPLIED ECONOMETRICS                      *    
*												                        *
*  Prof. Santetti									                    *
*-----------------------------------------------------------------------*



*------------------------------------------------------*
*           OMITTED VARIABLES BIAS IN PRACTICE         *
*------------------------------------------------------*


* Whenever using Stata, your first step should always be
* setting your working directory (that is, where your data files)
* will come from, and where you will save your work.

* In the top left corner, simply go to "File" > "Change Working Directory" > and choose
* your desired folder. Your data files should be there as well,
* so Stata can find and import it.


**---------------------------------------------------------


*-- In this applied lecture, we will practice what happens to OLS models when
*-- we omit relevant or include irrelevant variables. Furthermore, we will
*-- apply the RESET test for functional form misspecification.


**---------------------------------------------------------


**--- Omitting a relevant variable from a model:


** For this lecture, let us work once again with Mroz's (1987) data:

clear

use mroz_data



** Let's estimate a model which we consider to be the "true" one, or
** the best representing the population model for a household's
** income.


gen lfaminc = log(faminc)


** We assumed the true model is:



reg lfaminc educ wage heduc hwage kidsl6

predict resid_true, residuals



** Now, let us omit a relevant variable from this model, 'hwage'.



reg lfaminc educ wage heduc kidsl6

predict resid_omit, residuals



** How do the estimated coefficients behave when omitting a variable?


****--- Quick visual inspection:

twoway (scatter lfaminc hwage)


** Are the dependent variable and the omitted variable (hwage) closely related?


**--- Now, let us check the correlation coefficients between the omitted variable
** and both residual terms:



correlate hwage resid_omit resid_true


** What can we say?



twoway (scatter hwage resid_true), name(p1)


twoway (scatter hwage resid_omit), name(p2)


graph combine p1 p2





**---------------------------------------------------------


**--- Including irrelevant variables:


** From what we have defined as the "true" model, let us now add a 
** variable that may not have any theoretical value, the number
** of husband siblings ('hsiblings'):


reg lfaminc educ wage heduc hwage kidsl6 hsiblings



** Let us comparec these coefficients with the original regression's:


reg lfaminc educ wage heduc hwage kidsl6


**-- Moral of the story: if the addition of a variable is not supported by economic theory,
** there should be a strong and reliable reason to include it in a final model.



**---------------------------------------------------------


**--- Ramsey's Regression Equation Specification Error Test (RESET):


** Let us first run this test manually. First, we need the fitted values (y_hat) from
** our model:



reg lfaminc educ wage heduc hwage kidsl6

predict y_hat


** And we will use its square, cubed and fourh-powered functional forms:


gen y_hat_sq = y_hat^2
gen y_hat_cb = y_hat^3
gen y_hat_4 = y_hat^4



** Now, to the RESET test's auxiliary regression:


reg lfaminc educ wage heduc hwage kidsl6 y_hat_sq y_hat_cb y_hat_4


* Are these three added terms jointly significant? Let's run an F-test:


test y_hat_sq y_hat_cb y_hat_4



** The null hypothesis for the RESET test is that the model is well specified. In case
** we reject the null hypothesis that the added terms (squares, cubes, etc.) are not 
** statistically significant (equal to zero), the model suffers from some kind of
** misspecification. Unfortunately, it does not tell which specific misspecification
** it is.



** Now, with Stata's function...


reg lfaminc educ wage heduc hwage kidsl6

estat ovtest



** What do we conclude?


**-------------------------------------------------------------------------------



** We may explore a few options:



gen hwagesq = hwage^2

gen hwage_wage = hwage * wage

gen lhwage = log(hwage)

gen educsq = educ^2


reg lfaminc educ wage heduc hwage kidsl6 hwagesq


estat ovtest



reg lfaminc educ wage heduc hwage kidsl6 hwage_wage


estat ovtest


reg lfaminc educ largecity wage heduc lhwage kidsl6 lfp


estat ovtest




** What do we conclude?
