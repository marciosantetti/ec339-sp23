*-----------------------------------------------------------------------*
*																		
*																		
*                     EC 339: APPLIED ECONOMETRICS                            
*																		
*  Prof. Santetti														
*-----------------------------------------------------------------------*



*------------------------------------------------------*
*    BINARY DEPENDENT VARIABLE MODELS IN PRACTICE      *
*------------------------------------------------------*


* Whenever using Stata, your first step should always be
* setting your working directory (that is, where your data files)
* will come from, and where you will save your work.

* In the top left corner, simply go to "File" > "Change Working Directory" > and choose
* your desired folder. Your data files should be there as well,
* so Stata can find and import it.


**---------------------------------------------------------


**--- Let us start with data from the 1976 Current Population Survey (CPS), 
**--- and used in several examples from Wooldridge's "Introductory Econometrics":


clear


use wage1


** Suppose we would like to determine the factors that might help to explain someone
** receiving a higher wage per hour. For the 1970s, let us assume that
** an hourly wage of $6 is a good measure.

** Then, let us create a binary variable that equals "1" if the individual in the sample 
** has a wage higher than $6 per hour, and "0" otherwise.


** We do the following:

gen highwage = 0
replace highwage = 1 if wage > 6


** Quick check...


browse wage highwage



**--- The Linear Probability Model (LPM):


** Using OLS to estimate a model with a binary variable on the LHS is our starting point:


reg highwage educ exper tenure female


** How do we interpret these coefficients?



** A second model (adding "nonwhite"):


reg highwage educ exper tenure female nonwhite


** How do we interpret these coefficients?

** Looking at these models fitted values (or predicted probabilities):

predict pred_prob


browse 


**--- The binary logit model:


** Moving on from linear models, a first option we may adopt is
** the logit model, which uses the logistic function 
** to keep the predicted probabilities of
** success [P(y = 1 | x)] between 0 and 1:


logit highwage educ exper tenure female nonwhite


** These coefficients are not directly interpretable, since these are simply the "beta"
** values that maximize the likelihood of success across all observations in the sample.


** However, we can use Average Marginal Effects (AME) to have a direct and meaningful interpretation.
** These are simply the marginal effects for all individuals averaged out.


margins, dydx(*)


** How do we interpret these?



**--- The binary probit model:



** The probit model's procedure is exactly the same as the logit's.
** The main difference lies in in using the Standard Normal distribution's
** Cumulative Density Function (CDF) to keep the predicted probabilities of
** success [P(y = 1 | x)] between 0 and 1:


probit highwage educ exper tenure female nonwhite


** And Average Marginal Effects:


margins, dydx(*)

** How do we interpret these?



**--- USing estout:

eststo: reg highwage educ exper tenure female nonwhite

eststo: logit highwage educ exper tenure female nonwhite

eststo: probit highwage educ exper tenure female nonwhite


esttab est2 est3 est4, se r2 ar2 pr2


##---------------------------------------------------------




**--- Our second set of examples will use data from the Current Population Survey (CPS), with a 
** sample of workers from Boston and Chicago to study employment patterns by race,
** gender, education, and experience.

clear


use cps_data


** Quick adjustment to "employed" variable (a few missing observations and 
** imported as a string intially):

drop if employed == "NA"

destring employed, replace


** We can see that 'educ' is not a numeric, but a character variable. Let's adopt a 
** simple strategy and create a dummy variable that takes on 1 if the individual 
** has at least finished college, and 0 otherwise.


gen higher_ed = 0

replace higher_ed = 1 if educ == "College or Higher"


** Checking...

browse


**--- Linear Probability Model:


reg employed black female higher_ed exper


**--- Logit Model:

logit employed black female higher_ed exper

margins, dydx(*)


**--- Probit Model:

probit employed black female higher_ed exper

margins, dydx(*)












