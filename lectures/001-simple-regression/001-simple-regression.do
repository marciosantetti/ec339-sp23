*-----------------------------------------------------------------------*
*																		
*																		
*                     EC 339: APPLIED ECONOMETRICS                            
*																		
*  Prof. Santetti														
*-----------------------------------------------------------------------*



*------------------------------------------------------*
* SIMPLE LINEAR REGRESSION IN PRACTICE                 *
*------------------------------------------------------*


* Whenever using Stata, your first step shoul always be
* setting your working directory (that is, where your data files)
* will come from, and where you will save your work.

* In the top left corner, simply go to "File" > "Change Working Directory" > and choose
* your desired folder. Your data files should be there as well,
* so Stata can find and import it.



*------------------------------------------



*--- The 'beauty' data set brings microeconometric data on wages, education, experience, gender, etc.

* Reference: Hamermesh, D.S. and J.E. Biddle (1994), "Beauty and the Labor Market,"
* American Economic Review 84, 1174-1194.

* The file is already in .dta format, so it is simple to import it:


use beauty


* In your own time, make sure to run some statistical analyses (as done last week) 
* for this data set. This way, you will know your data better.

** Suppose we are interested in the relationship between an individual's educational attainment
** and their hourly wages.


* A good first step is to visualize this relationship:

twoway (scatter wage educ)



*--- To run a regression model in Stata, we follow this sintax:

* reg dependent-variable independent-variable


* Given that we want to explain wages in terms of education, our model is:


reg wage educ


* Q: How can we interpret the slope and intercept coefficients?

* A: (Your answer here)


* Visually, including the estimated regression line:


twoway (scatter wage educ) (lfit wage educ)


*------------------------------------------


*--- Now, what about wages vs. years of experience in the labor market?

twoway (scatter wage exper)


*... And a regression model:


reg wage exper


* Q: How can we interpret the slope and intercept coefficients?

* A: (Your answer here)



* Visually, including the estimated regression line:



twoway (scatter wage exper) (lfit wage exper)

*------------------------------------------


*--- Let us now work with an external data set, subset of the data from 
* Tennessee's Project STAR (Student/Teacher Achievement Ratio):


clear

* Make sure to import the ""star5_small.csv" into Stata, and then we can 
* convert it to the ".dta" format:


save star5_small


* To check if it has worked...

clear

use star5_small


*------------------------------------------


*--- And let us see the relationship between a student's total score (totalscore) 
* and their math score (mathscore), for classrooms with a school aide (aide).


* Here, aide equals 1 if the classroom has a school aide, and 0 if not. 
* We need to filter the data first:


keep if (aide == 1)



* Then, some visualization:


twoway (scatter totalscore mathscore) 


* And a model:


reg totalscore mathscore


* Q: How can we interpret the slope and intercept coefficients?

* A: (Your answer here)




* Visually, including the estimated regression line:


twoway (scatter totalscore mathscore) (lfit totalscore mathscore)


*------------------------------------------


*--- Regression residuals:

* After a regression is estimated, we can inspect some of its elements.
* Let us start by the residual (error) term:


predict resid_reg3, residuals


* What about the relationship between the independent variable (x) 
* and the residual term (u)?
* Is it zero, as theoretically assumed?

correlate resid_reg3 mathscore, covariance


* And we can visualize the residual's distribution:


histogram resid_reg3


* And with a density curve:

histogram resid_reg3, kdensity


* And what about the Expected Value (i.e., mean) of the residual term?
* Is it zero, as theoretically assumed?

tabstat resid_reg3, statistics(mean)



*------------------------------------------


*--- Lastly, let us compute the slope and intercept coefficients from 
* the previous regression by hand.


* Recall the formulas: slope (beta1) = Cov(x,y)/Var(x)
*                      intercept (beta0) = y.bar - x.bar * beta1, where x.bar and y.bar are the variables' means.



correlate totalscore mathscore, covariance

tabstat mathscore totalscore, statistics(mean variance)



