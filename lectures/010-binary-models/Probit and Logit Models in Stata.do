* Probit and Logit Models in Stata
* Copyright 2013 by Ani Katchova

clear all
set more off

use C:\Econometrics\Data\probit_insurance

global ylist ins
global xlist retire age hstatusg hhincome educyear married hisp

describe $ylist $xlist 
summarize $ylist $xlist

tabulate $ylist 

* Regression 
reg $ylist $xlist

* Probit model
probit $ylist $xlist

* Logit model
logit $ylist $xlist


* Marginal effects (at the mean and average marginal effect)
quietly reg $ylist $xlist
margins, dydx(*) atmeans
margins, dydx(*)

quietly logit $ylist $xlist  
margins, dydx(*) atmeans
margins, dydx(*)

quietly probit $ylist $xlist 
margins, dydx(*) atmeans
margins, dydx(*)


*Logistic model gives odds ratio   
logistic $ylist $xlist 


* Predicted probabilities
quietly logit $ylist $xlist
predict plogit, pr

quietly probit $ylist $xlist 
predict pprobit, pr

quietly regress $ylist $xlist
predict pols, xb

summarize $ylist plogit pprobit pols


* Percent correctly predicted values
quietly logit $ylist $xlist
estat classification

quietly probit $ylist $xlist
estat classification

