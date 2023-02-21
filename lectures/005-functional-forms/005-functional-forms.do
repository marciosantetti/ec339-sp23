*-----------------------------------------------------------------------*
*												                        *
*												                        *
*                     EC 339: APPLIED ECONOMETRICS                      *    
*												                        *
*  Prof. Santetti									                    *
*-----------------------------------------------------------------------*



*------------------------------------------------------*
*            FUNCTIONAL FORMS IN PRACTICE              *
*------------------------------------------------------*


* Whenever using Stata, your first step should always be
* setting your working directory (that is, where your data files)
* will come from, and where you will save your work.

* In the top left corner, simply go to "File" > "Change Working Directory" > and choose
* your desired folder. Your data files should be there as well,
* so Stata can find and import it.









**--------------------------------------------------------------------------------------------------------

clear

use sleep75





**--------------------------------------------------------------------------------------------------------


**--- Regression through the origin


** One may suppose that, if an individual works 0 minutes per week, they will make no earnings at all.

** Let us visually check this (also adding some plot customization):


twoway (scatter earns74 totwrk), title("Total earnings vs. Minutes worked per week") ytitle("Earnings in 1974") xtitle("Minutes worked per week")


** In case we want to estimate a regression model with no intercept term, we just do the following:


reg earns74 totwrk, noconstant




** And the two together:

* Storing y_hat (the fitted values from the regression)


predict fitted_values, xb


twoway (scatter earns74 totwrk) (line fitted totwrk)






**--------------------------------------------------------------------------------------------------------


**--- Interaction terms:


clear


use chicken_demand


twoway (scatter q p)


gen inv_p = 1/p


reg q inv_p


** Interpretation:

* Marginal effect =  [-beta_(price)/p^2 = -48.365/mean(p)^2]


mean p


* A one-unit increase in the real price index of chicken decreases per capita consumption of chicken by
* [-48.365/(1.45^2) =] 23 pounds.



**--------------------------------------------------------------------------------------------------------


**--- Using quadratic terms:


clear


use hprice2

gen ldist = log(dist)
gen rooms_sq = rooms^2


reg lprice lnox ldist rooms rooms_sq stratio


*-- How does the number of rooms relate to the price of a house?

** Interpretation: At low values (number) of rooms, an additional room has a negative 
** effect on log(price). Then, at some point, the effect becomes positive, due to the 
** positive sign on rooms^2. Quantitatively, 
** 100*[-.5451 + 2*(.0622)*(rooms)]. Since the variable 'room' remains here for the 
** marginal effect computation, a good practice is to put the average number of that
** variable. In this case, rooms.

mean rooms

** Rounding it, the average number of rooms in this sample is 6. Plugging in 6 there,
** we get the marginal effect of the number of rooms in the price of a house. Given
** that the dependent variable is in logs, we multiply it by 100 and get the result as a 
** percentage. Therefore,

** 100*[-.5451 + 2*(.0622)*(6)] = 20.13. Ceteris paribus, for a house starting with 6
** rooms, an additional room will increase its price by 20.13%.



**--------------------------------------------------------------------------------------------------------



**--- Interactions and binary (dummy) variables:


clear

use wage1


gen educ_tenure = educ * tenure


reg lwage female educ exper tenure educ_tenure



** How do we interpret the effect of education on wages?


** Let's work on this together.









**---  How to interpret the effect of gender on wages?

** When female=1 (i.e., for female workers), hourly wages are 100*[exp(beta_female) - 1] = 
** 100*[exp(-0.3045109) - 1 =] 26.25% lower for female workers, relative to male workers.

** When female=0 (i.e., for male workers), hourly wages are 100*[exp(-beta_female) - 1] = 
** 100*[exp(+0.3045109) - 1 =] 35.6% higher for male workers, relative to female workers.



** The above calculation gives the exact effect of the binary variable on the logged independent variable.
** For slope dummy variables, we can use the usual derivative approach, which will give an approximate
** marginal effect.


gen female_educ = female * educ

reg lwage female educ female_educ exper expersq tenure tenursq


** What is the estimated return to education for men?
** 100*[.082 + (-.0056)*0=] 8.2%.

**-- What is the estimated return to education for women?
** 100*[.082 + (-.0056)*1=] 7.6%.

** The gender differential for education between men and women is given by the 
** coefficient on the slope dummy variable female*educ.
** Therefore, the difference is of .56% percentage point less for women. However, this 
** coefficient is not statistically significant for this sample.


**--------------------------------------------------------------------------------------------------------



