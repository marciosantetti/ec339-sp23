**


reg personal_income  education  i_female

reg personal_income  education  i_female, mse1

reg personal_income  education  i_female, mse

** mse1 and mce are the same thing.


reg personal_income  education  i_female, mse2

** MacKinnon-White:

reg personal_income  education  i_female, r

** same thing.

reg personal_income  education  i_female, vce(robust)





** BP test


reg personal_income  education  i_female


estat hettest


reg personal_income  education  i_female, vce(hc2)


***---------------------------------------------------------------------------


clear

use food


reg food_exp income


estat hettest, iid

**  iid causes estat hettest to compute the N*R2 version of the score test
**  that drops the normality assumption.



imtest, white


gen log_food_exp = log(food_exp)


quietly reg log_food_exp income


estat hettest, iid

estat imtest, white



***---------------------------------------------------------------------------


clear

use hprice2

gen log_dist = log(dist)

reg lprice lnox log_dist rooms stratio


estat hettest, iid

estat imtest, white
