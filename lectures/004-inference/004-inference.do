*-----------------------------------------------------------------------*
*												                        *
*												                        *
*                     EC 339: APPLIED ECONOMETRICS                      *    
*												                        *
*  Prof. Santetti									                    *
*-----------------------------------------------------------------------*



*------------------------------------------------------*
*         REGRESSION INFERENCE IN PRACTICE             *
*------------------------------------------------------*


* Whenever using Stata, your first step should always be
* setting your working directory (that is, where your data files)
* will come from, and where you will save your work.

* In the top left corner, simply go to "File" > "Change Working Directory" > and choose
* your desired folder. Your data files should be there as well,
* so Stata can find and import it.


**------------------------------------------------------------------------


* Today, we will use the "sleep75.dta" file (available on theSpring).
* Source: J.E. Biddle and D.S. Hamermesh (1990), "Sleep and the Allocation of Time," 
* Journal of Political Economy 98, 922-943.

clear

use sleep75


* And our regression model will be:


reg sleep totwrk age yrsmarr




* Let us now analyze each element from the regression output.




**------------------------------------------------------------------------


**--- Where do these t-statistics come from?


* Let us calculate a t-test for the coefficient on "totwrk":

*-- H0: beta_totwrk = 0;      (the coefficient is not statistically significant)
*-- Ha: beta_totwrk != 0      (a two-sided/two-tailed test)





* We can use the _b[variable name] and _se[variable name] keys to 
* extract the beta coefficient and standarrd error, respectively:


display _b[totwrk]  / _se[totwrk] 


* After computing the t-test statistic, we look for the t-distribution's critical values.
* the "invttail" function does that for us, so there is no need to use tables.


* For the upper tail value, using alpha/2:


display invttail(706 - 3 - 1, 0.05/2)  


* For the lower tail value, using 1 - alpha/2:


display invttail(706 - 3 - 1, 1 - 0.05/2)  


* Based on the t-statistic and on the critical value, what is our inference from this test?


* Your answer:




**------------------------------------------------------------------------



**--- Repeat the same procedure for the other two slope coefficients.


**------------------------------------------------------------------------


** p-values:

** A p-value can be used instead of a test statistic. It shows how likely we are to get a
** test statistic as extreme as the one we've obtained from our test.


** Taking the example from the previous regression, the t-statistic for "age"
** was 1.86, with a p-value of 0.064.

** Where does this p-value come from?

** For a two-tailed test, the p-value is given by:
** 2 * P(t > |t-statistic|)


display 2 * ttail(702, 1.86) 


** Do the same for the coefficient on "yrsmarr."


** Your answer:




** Bonus: function for plotting density curves and critical values in Stata.
** Notice that the three slashes "///" serve as a line break, but
** the code will continue on the next line.


twoway (function y=tden(402,x), range(-3 3)) ///
(function y=tden(402,x), range(-3 -1.86) recast(area)) ///
(function y=tden(402,x), range(1.86 3) recast(area) legend(off) xlabel(-1.86 0 1.86))



**------------------------------------------------------------------------


** Stata also provides a 95% confidence interval for each regression coefficient.

** How do we get these values?


** For "yrsmarr":

display _b[yrsmarr] + invttail(706 - 3 - 1, 0.05/2) * _se[yrsmarr]
display _b[yrsmarr] - invttail(706 - 3 - 1, 0.05/2) * _se[yrsmarr]



** Repeat the procedure for the other coefficients.



** Your answer:




**----


** In case we want to modify the level of confidence of the interval, we do the following:


reg sleep totwrk age yrsmarr, level(90)



**------------------------------------------------------------------------

** F-test (tesling linear restrictions):


** Stata regression output also reports an F-test statistic and a p-value.
** It is basically testing whether all slope coefficients are 
** jointly significant.

* H0: beta_totwrk = beta_age = beta_yrsmarr = 0
* Ha: the null hypothesis is not true.

** How do we interpret that result?


* Critical value method:


display invFtail(3, 702, 0.05/2)


* p-value method:


display 2 * Ftail(3, 702,  28.61)


**------------------------------------------------------------------------


** Suppose that, from our sleep model, we would like to test the following hypotheses:

* H0: beta_totwrk = beta_age = 0
* Ha: the null hypothesis is not true. 


test totwrk age


* Where does this test statistic come from?


* The unrestricted model is the original regression:

reg sleep totwrk age yrsmarr


* The restricted model is the one without totwrk and age:

reg sleep yrsmarr


* We have imposed q = 2 restrctions, and have n - k - 1 = 702 DOF in the unrestricted model.

* Thus,

display (0.1089 -  0.0041 ) / ( 1 - 0.1089 ) * (702 / 2)


** Is this the same?


**------------------------------------------------------------------------


**--- Practice:


** Go back to the models we estimated in previous applied lectures. 
** You should now be able to fully interpret all regression summaries.
