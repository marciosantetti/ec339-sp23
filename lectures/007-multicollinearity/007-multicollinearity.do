*-----------------------------------------------------------------------*
*												                        *
*												                        *
*                     EC 339: APPLIED ECONOMETRICS                      *    
*												                        *
*  Prof. Santetti									                    *
*-----------------------------------------------------------------------*



*------------------------------------------------------*
*   PERFECT/IMPREFECT MULTICOLLINEARITY IN PRACTICE    *
*------------------------------------------------------*


* Whenever using Stata, your first step should always be
* setting your working directory (that is, where your data files)
* will come from, and where you will save your work.

* In the top left corner, simply go to "File" > "Change Working Directory" > and choose
* your desired folder. Your data files should be there as well,
* so Stata can find and import it.


**---------------------------------------------------------


*-- We will a subset of the Penn World Tables (PWT 9.1).
*-- Official page: https://www.rug.nl/ggdc/productivity/pwt/pwt-releases/pwt9.1?lang=en
*-- Data description: https://www.rdocumentation.org/packages/pwt9/versions/9.1-0/topics/pwt9.1


**---------------------------------------------------------


clear

use pwt_select.dta


**---------------------------------------------------------



**-- Verifying pairwise correlation coefficients among selected variables:



correlate pop emp ccon ck



**-- Some visual checks:


twoway (scatter emp pop)


twoway (scatter ck ccon)


**---------------------------------------------------------


**-- Estimating regression models:


reg lrgdpna pop emp ck ccon


**-- And let's calculate this model's Variance Inflation Factors (VIFs),
**-- with the "vif" command right after the regression has been estimated:


vif


**-- What do we conclude?

** Your answer:




**---------------------------------------------------------


**-- Where do these values come from?


** pop:


reg pop emp ck ccon

** And grab its R-squared coefficient.


display 1/(1 - 0.9766)



** emp:


reg emp pop ck ccon

** And grab its R-squared coefficient.


display 1/(1 - 0.9794)


** ck:


reg ck pop emp ccon

** And grab its R-squared coefficient.


display 1/(1 - 0.9671)



** ccon:


reg ccon pop emp ck

** And grab its R-squared coefficient.


display 1/(1 - 0.9634)


**--- Are these values close to the ones given by the 'vif()' function?



**--------------------------------------------------------


**-- Since our VIFs are not very exciting, we estimate a new model:


reg lrgdpna lemp lccon ck


** And compute the VIFs:


vif


** What do we conclude?


** Your answer:
