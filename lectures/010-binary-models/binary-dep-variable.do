set more off

*use the wage1 data file*
use wage1

*generate a binary indicator of highwage that takes a value 1 if wage >6 and zero otherwise. Note 6 is the approximate average wage in the sample*
gen highwage = 0
replace highwage = 1 if wage > 6

*Consider the regression model where highwage is the explained variable and  "educ exper tenure female nonwhite" are the explanatory variables*

** Linear Probability Model (LPM) ***
reg highwage educ exper tenure female nonwhite
*store the estimates*
est store ols
*for various goodness of fit measures*
fitstat

** Probit **
probit highwage educ exper tenure female nonwhite
*compute marginal effect. Note: by default the marginal effect will be computed using the sample mean for each explantory variable*
eststo probitmfx: mfx compute 
**make sure you store the estimates after running the mfx command (not right after probit) otheriwse you will end up with the betas rather than marginal effects**
*for various goodness of fit measures*
fitstat

** Logit **
logit highwage educ exper tenure female nonwhite
eststo logitmfx: mfx compute 
*for various goodness of fit measures*
fitstat


margins, dydx(*)


logit highwage

*compare LPM, Probit, Logit* FITSTATS ARE JUST GOOD FOR COMPARING MODELS WITH THE SAME APPROACH, LIKE DIFFERENT LOGIT MODELS, PROBIT, ETC.
estout ols probitmfx logitmfx, cells(b(star fmt(3)) p(par fmt(3))) stats(N) legend margin 


** odds ratios for Logit ** GREATER THAN ONE, IN FAVOR OF THE NUMERATOR. EDUC: ANOTHER UNIT OF EDUC, INCREASE THE CHANCE (PROB) OF  BEING IN THE HIGHWAGE CATEGORY.
logit highwage educ exper tenure female nonwhite, or
