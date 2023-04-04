

#== EC 339
#== Prof. Santetti 

#=============================================================================#
#                       HETEROSKEDASTICITY IN PRACTICE                        #
#=============================================================================#


#== IMPORTANT: Before any operations, make sure to set your working directory.
# In other words, you have to tell R in which folder you will save your work, or
# from which folder external data sets will come from. In the lower-right pane, 
# click on 'Files.' Select your desired folder, and click on 'More', then select 
# the option 'Set as Working Directory.'

#================================================================================================#






###--- Loading the necessary packages for today:


library(tidyverse)
library(lmtest)
library(wooldridge)
library(patchwork)
library(estimatr)
library(skedastic)

##---------------------------------------------------------


##--- As a first applied example, let us use a sample from the 2018 American Community Survey (ACS), 
##--- downloaded from IPUMS (Integrated Public Use Microdata Series).


ipums_data <- read_csv("het_data.csv")


## Quick visual inspection:


ipums_data %>% 
  mutate(i_female = as_factor(i_female)) %>% 
  ggplot(aes(y=personal_income, x=education, color = i_female)) +
  geom_point()


## Estimating a regression model:


ipums_model <- lm(personal_income ~ education + i_female, data = ipums_data)

ipums_model %>% 
  summary()


## Extracting the residuals:

ipums_resid <- ipums_model %>% 
  resid()

ipums_data <- ipums_data %>% 
  add_column(ipums_resid)


ipums_data %>% 
  ggplot(aes(x = education, y = ipums_resid)) + 
  geom_point(shape = 21)                                     ## do the residuals look
                                                             ## heteroskedastic?


##---------------------------------------------------------

##--- Testing for heteroskedasticity:



##-- Breusch-Pagan (BP) test:


ipums_model %>% 
  breusch_pagan()       ## from the {skedastic} package.



##-- White test:


ipums_model %>% 
  white(interactions = TRUE)


##---------------------------------------------------------


##--- Manually estimating the Breusch-Pagan test:


# First, we need to estimate an auxiliary regression, with the squared residual term as the
# dependent variable, and the independent variables from the original model maintained on
# this new model's right-hand-side.


ipums_data <- ipums_data %>% 
  mutate(ipums_resid_sq = ipums_resid^2)

bp_reg <- lm(ipums_resid_sq ~ education + i_female, data = ipums_data)

bp_reg %>% 
  summary()


# Now, we have what we need to compute the Breusch-Pagan's LM test statistic:

lm_stat_bp <- 5000 * 0.01579              ## is this test statistic the same as the one given by the
                                          ## "breusch_pagan()" function?


# Now, we compare the test statistic with a critical value from the Chi-squared distribution:


qchisq(p = .95, df = 2)         ## the test uses 2 degrees-of-freedom, since we have k = 2 independent variables in
                                ## the auxiliary regression.


## Manually estimating the White test:


# The only difference in the White test's procedure is that we take into account model misspecification.
# Therefore, similarly to the RESET test, we put the fitted values for the dependent variable
# and potential functional forms that may be contributing to heteroskedasticity.


ipums_data <- ipums_data %>% 
  mutate(y_fitted = fitted(ipums_model))


white_reg <- lm(ipums_resid_sq ~ y_fitted + I(y_fitted^2), data = ipums_data)

white_reg %>% 
  summary()


# And we compute the test statistic (same as before):

lm_stat_white <- 5000 * 0.02489    ## so what?



##---------------------------------------------------------



##--- Robust Standard Errors:



## Using MacKinnon-White standard errors (the same given by default in Stata):


ipums_model_robust <- lm_robust(personal_income ~ education + i_female, data = ipums_data, se_type = "HC1")

ipums_model_robust %>% 
  summary()



##---------------------------------------------------------




##--- Now, replicate the results from the last lecture's slides
##--- for the housing price data.


data("hprice2")   ### from the {wooldridge} package.


hprice2 <- hprice2 %>% 
  as_tibble()
