

#== EC 339
#== Prof. Santetti 

#=============================================================================#
#                        OMITTED VARIABLES BIAS IN R                          #
#=============================================================================#


#== IMPORTANT: Before any operations, make sure to set your working directory.
# In other words, you have to tell R in which folder you will save your work, or
# from which folder external data sets will come from. In the lower-right pane, 
# click on 'Files.' Select your desired folder, and click on 'More', then select 
# the option 'Set as Working Directory.'

#================================================================================================#






###--- Loading the necessary packages for today:


library(tidyverse)
library(broom)
library(patchwork)
library(lmtest)      ## for the RESET test.
library(car)

##---------------------------------------------------------


#-- In this applied lecture, we will practice what happens to OLS models when
#-- we omit relevant or include irrelevant variables. Furthermore, we will
#-- apply the RESET test for functional form misspecification.


##---------------------------------------------------------


##--- Omitting a relevant variable from a model:


## For this lecture, let us work once again with Mroz's (1987) data:

mroz_data <- read_csv('mroz.csv')


## Let's estimate a model which we consider to be the "true" one, or
## the best representing the population model for a household's
## income.


true_model <- lm(log(faminc) ~ educ + wage + heduc + hwage + kidsl6, data = mroz_data)

true_model %>% 
  summary()


## Now, let us omit a relevant variable from this model, 'hwage'.


omit_model <- lm(log(faminc) ~ educ + wage + heduc + kidsl6, data = mroz_data)

omit_model %>% 
  summary()           ## what happened?


## Comparing the models' coefficients:

true_model %>% 
  tidy()

omit_model %>% 
  tidy()              ## what happened?



## Quick visual inspection:

mroz_data %>% 
  ggplot(mapping = aes(x=hwage, y=log(faminc))) + 
  geom_point() 


## Let us now inspect the residuals from these two models:


resid_true <- true_model %>% 
  resid()

resid_omit <- omit_model %>% 
  resid()


## And check the correlation coefficient between the
## omitted variable, 'hwage' and both residual terms:


mroz_data %>% 
  summarize(cor_hwage_resid_true = cor(hwage, resid_true),
                        cor_hwage_resid_omit = cor(hwage, resid_omit))


## And we add the residuals to the data set:


mroz_data <- mroz_data %>% 
  add_column(resid_true, resid_omit)


p1 <- mroz_data %>% 
  ggplot(aes(x=resid_true, y=hwage)) + 
  geom_point() + 
  geom_smooth(method="lm", se=FALSE) 

p2 <- mroz_data %>% ggplot(aes(x=resid_omit, y=hwage)) + 
  geom_point() + 
  geom_smooth(method="lm", se=FALSE) 


# Using the 'patchwork' package to plot these two side by side:


p1 | p2



##---------------------------------------------------------


##--- Including irrelevant variables:


## From what we have defined as the "true" model, let us now add a 
## variable that may not have any theoretical value, the number
## of husband siblings ('hsiblings'):


irrel_model <- lm(log(faminc) ~ educ + wage + heduc + hwage + kidsl6 + hsiblings, data = mroz_data)


irrel_model %>% 
  summary()                 ## what happened?


## Comparing the model's coefficients:


true_model %>% 
  tidy() 


irrel_model %>% 
  tidy()                       ## what happened? 


## And let us compare their respective standard errors as well.



##--- Moral of the story: if the addition of a variable is not supported by economic theory,
## there should be a strong and reliable reason to include it in a final model.



##---------------------------------------------------------


##--- amsey's Regression Equation Specification Error Test (RESET):


## Let us first run this test manually. First, we need the fitted values (y_hat) from
## our model:


y_hat <- true_model %>% 
  fitted()


## And we will use its square and cubed functional forms:


y_hat_sq <- y_hat^2
y_hat_cb <- y_hat^3


## And join these columns to the original data set:


mroz_data <- mroz_data %>% 
  add_column(y_hat_sq, y_hat_cb)


#== Now, to the RESET test's auxiliary regression:

aux_reg_reset <- lm(log(faminc) ~ educ + wage + heduc + hwage + kidsl6 + 
                      y_hat_sq + y_hat_cb, data = mroz_data)


aux_reg_reset %>% 
  summary()


## Are these two added terms jointly significant? Let's run an F-test:


aux_reg_reset %>% 
  linearHypothesis(c("y_hat_sq = 0", "y_hat_cb = 0"))  ## what do we conclude?


#== The null hypothesis for the RESET test is that the model is well specified. In case
#== we reject the null hypothesis that the added terms (squares, cubes, etc.) are not 
#== statistically significant (equal to zero), the model suffers from some kind of
#== misspecification. Unfortunately, it does not tell which specific misspecification
#== it is.


## With R's function (from the 'lmtest' package):

true_model %>% 
  resettest(power = 2:3)   ## is the F-test statistic the same as above?



## We see that our "true" model still suffers from functional form misspecification.

## we can try a few things:


true_model2 <- lm(log(faminc) ~ educ + wage + heduc + hwage + kidsl6 +
                    I(hwage^2), data = mroz_data)

true_model2 %>% 
  resettest(power = 2:3)

##


true_model3 <- lm(log(faminc) ~ educ + wage + heduc + hwage + kidsl6 +
                    hwage:wage, data = mroz_data)

true_model3 %>% 
  resettest(power = 2:3)

##


true_model4 <- lm(log(faminc) ~ educ + wage + heduc + log(hwage) + kidsl6, data = mroz_data)

true_model4 %>% 
  resettest(power = 2:3)


## And compare the coefficients:


true_model %>% summary()
true_model4 %>% summary()
