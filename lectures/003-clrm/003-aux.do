clear
set seed 12345
postfile buffer1 beta se_x tstat using ols, replace 
forvalues i=1/1000{
	quietly drop _all
	quietly set obs 50
	quietly gen double x=rnormal()
	quietly gen double e=rnormal(0,sqrt(1+exp(x)))
	quietly gen double y=2+1*x+e
	quietly reg y x
	post buffer1 (_b[x]) (_se[x]) ((_b[x]-1)/_se[x])
}
postclose buffer1              // Estimate beta 1000 times and store results in ols.dta 


use ols, clear                // Check for unbiasedness: t-test of the estimated slope "beta" 
ttest beta==1


clear

set seed 123

forvalues i=1/1000{
	quietly drop _all
	quietly set obs 100
	quietly gen double x = rnormal(5, 2)
	quietly gen double u = rnormal(0, x^2)
	quietly gen double y = 100 + x + u
	quietly reg y x	
}

twoway (scatter y x), yline(100)


**------------------**

* Assumption 1:

clear

set seed 1233


quietly drop _all
set obs 100
gen double x1_true = 30 + 2*runiform(20, 60)
gen double x2_true = 10/x1_true + x1_true*rnormal(0,1)
gen double y_true = 45 + 2*x1_true + 4*x2_true + rnormal(0,1)


twoway (scatter y_true x1_true), name(p1)

twoway (scatter y_true x2_true), name(p2)

graph combine p1 p2



* estimating regression without x1_true:

reg y_true x2_true

* and the true model:

reg y_true x1_true x2_true



* (students can try this with a larger sample size. Estimates will be more precise.)


**------------------**

* Assumption 2:

set seed 200
set obs 500

gen double x = 50 - runiform(-50, 50)
gen double y = 100 + 2*x + rnormal(0,1)

twoway (scatter y x)

twoway (scatter y x) (lfit y x)

reg y x

predict a2_resid, residuals


tabstat a2_resid, statistics(n mean)

summarize a2_resid, detail



**------------------**

* Assumption 3:

correlate a2_resid x


**------------------**

* Assumption 4:

gen obs = _n + 1
egen obs2 = seq()


twoway (scatter a2_resid obs2)

**

use fertil3, clear

reg gfr pe ww2 pill 

predict a5_resid, residuals

twoway (scatter a5_resid year) (line a5_resid year)


**------------------**

* Assumption 5:

set obs 200

egen z = seq()

set seed 100

gen w = 50 + rnormal(0, 0.1*z)

twoway (scatter w z)

reg w z

predict a55_resid, residuals

egen obs5 = seq()

twoway (scatter a55_resid obs5), yline(0)



**------------------**

* Assumption 6:

clear

set seed 123

set obs 100

gen double x1 = runiform(0, 100)
gen double x2 = 0.25*x1

gen double y_multi = 0.5*x1 + 0.5*x2 + rnormal(0,1)

reg y_multi x1 x2

** (look at summary, already noticing multicollinearity.)


**------------------**

* Assumption 7:


* again, data from Assumption 5

clear

set obs 200

egen z = seq()

set seed 100

gen w = 50 + rnormal(0, 0.1*z)

twoway (scatter w z)

reg w z

predict a55_resid, residuals


*---

histogram a55_resid, kdensity


* H0: variable is normally distributed.

swilk a55_resid







