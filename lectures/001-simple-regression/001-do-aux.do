* Import data:

import delimited "/Users/marciosantetti/Documents/Skidmore College/teaching/applied-metrics/fall-22/lectures/001-simple-regression/ipums_data.csv"



* Summary statistics:

summarize

summarize hh_size



* Scatter plots (y x):

twoway scatter (hh_income time_commuting)

twoway scatter (cost_housing hh_size)



* Simple regression:

reg time_commuting hh_income

twoway (scatter time_commuting hh_income, mcolor(%30)) (lfit time_commuting hh_income)


covariance time_commuting hh_income


* Extract y-hat:

predict time_hat

* look at first 10 values:

list time_hat in 1/10

predict time_resid, residuals

summarize time_resid

histogram time_resid, kdensity















