*-----------------------------------------------------------------------*
*												                        *
*												                        *
*                     EC 339: APPLIED ECONOMETRICS                      *    
*												                        *
*  Prof. Santetti									                    *
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


**  We will study this assumption through artificial data.

** Let us create some random numbers. The first step is to set a common "seed" for reproducibility:


clear


set seed 1233


quietly drop _all

set obs 100

gen double x1_true = 30 + 2 * runiform(20, 60)

gen double x2_true = 10/x1_true + x1_true * rnormal(0, 1)

gen double y_true = 45 + 2 * x1_true + 4*x2_true + rnormal(0, 1)



* Then, some visuals:


twoway (scatter y_true x1_true), name(p1)

twoway (scatter y_true x2_true), name(p2)


* Combining both graphs in the same plotting space:


graph combine p1 p2


** Estimating a model for "y_true" without "x1_true":


reg y_true x2_true


* Does the estimation match the "true" model?





** Now, estimating the model with all relevant variables:


reg y_true x1_true x2_true



* What is the difference now?




**------------------------------------------------------------------------


**--- Assumption 2: the error term has a zero population mean.


set seed 200
set obs 500

gen double x = 50 - runiform(-50, 50)

gen double y = 100 + 2*x + rnormal(0,1)


** Visuals:


twoway (scatter y x)

twoway (scatter y x) (lfit y x)


** And the model:

reg y x


** Storing the residuals:



predict a2_resid, residuals


** And computing the mean:\


tabstat a2_resid, statistics(n mean)


**------------------------------------------------------------------------


**--- Assumption 3: All explanatory variables are uncorrelated with the error term.


** We can use the same artificial data from the last Assumption:\



correlate a2_resid x


** Is the assumption satisfied?


**------------------------------------------------------------------------


**--- Assumption 4: Observations of the error term are uncorrelated with each other.


** For this example, let us use some real-world data:
** More info at: https://rdrr.io/cran/wooldridge/man/fertil3.html


clear


use fertil3



reg gfr pe ww2 pill 

predict a5_resid, residuals

twoway (scatter a5_resid year) (line a5_resid year)


** How does the residual term look?


**------------------------------------------------------------------------


**--- Assumption 5: the error term has a constant variance (homoskedasticity assumption)



set obs 200

egen z = seq()


** Notice that the [egen] function was used, instead of [gen]. This link may be helpful:
** https://stackoverflow.com/questions/12993607/whats-the-difference-between-gen-and-egen-in-stata-12



set seed 100



gen w = 50 + rnormal(0, 0.1*z)



twoway (scatter w z)




reg w z


predict a55_resid, residuals

egen obs5 = seq()

twoway (scatter a55_resid obs5), yline(0)


** How do the residuals look?


**------------------------------------------------------------------------



**--- Assumption 6: No explanatory variable is a perfect linear function
** of any other explanatory variable (no multicollinearity assumption).



clear

set seed 123

set obs 100


gen double x1 = runiform(0, 100)

gen double x2 = 0.25*x1

gen double y_multi = 0.5*x1 + 0.5*x2 + rnormal(0,1)




reg y_multi x1 x2


** What is happening?



**------------------------------------------------------------------------


**--- Assumption 7: the error term is normally distributed.


* Let us use the data from Assumption 5:


clear

set obs 200

egen z = seq()

set seed 100

gen w = 50 + rnormal(0, 0.1*z)





reg w z

predict a55_resid, residuals


** Visuals:

histogram a55_resid, kdensity


** The Shapiro-Wilk test for normality is a common statistical test that we can
** apply for testing CLRM Assumption 7:



* H0: the random variable is normally distributed;
* Ha: H0 is not true.


swilk a55_resid



* What do we conclude?
