*-----------------------------------------------------------------------*
*																		*
*																		*
*                     EC 339: APPLIED ECONOMETRICS                      *      
*																		*
*  Prof. Santetti														*
*-----------------------------------------------------------------------*



*------------------------------------------------------*
* MULTIPLE LINEAR REGRESSION IN PRACTICE		       *
*------------------------------------------------------*


* Whenever using Stata, your first step shoul always be
* setting your working directory (that is, where your data files)
* will come from, and where you will save your work.

* In the top left corner, simply go to "File" > "Change Working Directory" > and choose
* your desired folder. Your data files should be there as well,
* so Stata can find and import it.



*------------------------------------------


*--- We will start off working with data from Mroz (1987), on female labor force data. 


* Reference: Mroz, T. A. (1987) "The sensitivity of an 
* empirical model of a married woman's hours of work to economic and 
* statistical assumptions," Econometrica, 55, 765-800.


* The "mroz.csv" file is available in the course GitHub repository and on theSpring,
* as well as a .txt file describing its variables.



* After you have imported it, you may save it to a .dta format.


save mroz.dta



*------------------------------------------



*--- First, a bit of data visualization:


** Family income vs. wife's hours worked:


twoway (scatter faminc hours)


* As we note that several individuals in the sample have not worked at all over the year, we
* may consider a data set only for individuals that have hours worked (hours > 0):

keep if (hours > 0)


twoway (scatter faminc hours)


** Family income vs. years of labor market experience:


twoway (scatter faminc exper)


* The same goes for experience:


keep if (exper > 0)


* We can save this "filtered" data set:


save mroz_filtered.dta


** Family income vs. husband's education:


twoway (scatter faminc heduc)



*------------------------------------------


*--- Now, to the model! The procedure is the same as with simple regression, and we just need to
* keep adding covariates:


reg faminc kidsl6 hours exper heduc hwage


** Let us interpret each coefficient.


* Your answer:


*------------------------------------------


*--- Let us now play around with different functional forms:

** First, let us log-transform the dependent variable, faminc:


gen lfaminc = log(faminc)



twoway (scatter lfaminc exper)

twoway (scatter lfaminc hours)



** And we run the same model as before, this time with log(faminc) as dependent variable:


reg lfaminc kidsl6 hours exper heduc hwage


* Let us interpret each coefficient.

* Your answer:




*--- Now, let us put both faminc and hwage in log-scale:

gen lhwage = log(hwage)


twoway (scatter lfaminc lhwage)


** And a third (more parsimonious) model:


reg lfaminc lhwage hours


* Let us interpret each coefficient.

* Your answer:


** And we add a covariate for the number of the husband's siblings (hsiblings):


reg lfaminc lhwage hours hsiblings


*---  In terms of goodness-of-fit, i.e., R-squared and adjusted R-squared measures, 
* how do you evaluate models 3 and 4?


* Your answer:


*------------------------------------------

*--- Finally, let us estimate a level-log model:


gen ltaxableinc = log(taxableinc)


reg faminc ltaxableinc 


** How do we interpret the coefficient?

* Your answer:

*------------------------------------------

*--- Practice:


* Download the 'fast_food.csv' file (there is also a .txt file available, describing its variables). 
* It contains data for 75 fast-food chain franchises.
* I have included a .txt file describing the data set.
* Set up a multiple regression model for sales, controlling for prices and advertising expenses.

* Interpret the results, and play around with different functional form specifications, such as 
* log-level and log-log models.

