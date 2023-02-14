

#== EC 339
#== Prof. Santetti 

#=============================================================================#
#                         REGRESSION INFERENCE IN R                           #
#=============================================================================#


#== IMPORTANT: Before any operations, make sure to set your working directory.
# In other words, you have to tell R in which folder you will save your work, or
# from which folder external data sets will come from. In the lower-right pane, 
# click on 'Files.' Select your desired folder, and click on 'More', then select 
# the option 'Set as Working Directory.'

#================================================================================================#






###--- Loading the necessary packages for today:


library(tidyverse)
library(wooldridge)
library(car)


##---------------------------------------------------------



data("sleep75")


sleep75 <- sleep75 %>% 
  as_tibble()



sleep_model <- lm(sleep ~ totwrk + age + yrsmarr, data = sleep75)

sleep_model %>% 
  summary()


## The first part of a summary provides measures of relative location for the estimated
## residual term. With that, we can draw a box plot:


sleep_resid <- sleep_model %>% 
  resid()

sleep75 <- sleep75 %>% 
  add_column(sleep_resid)


sleep75 %>% 
  ggplot(aes(x = sleep_resid)) +
  geom_boxplot()


## Then, we have a table with the estimated 'beta' coefficients ('Estimate' column);
## their standard errors ('Std. Error' column); the test statistic for the coefficient's
## statistical significance ('t value' column); and this test's p-value ('Pr(>|t|') column).


## The punctuation signs indicate at which level of significance (or
## confidence) the estimated coefficients are statistically 
## significant. For example, '***' means significance at alpha =.001;
## '**', at .01, and so on.


##--- Where do these t-statistics come from?


## Let us calculate a t-test for the coefficient on "totwrk":

#-- H0: beta_totwrk = 0;      (the coefficient is not statistically significant)
#-- Ha: beta_totwrk != 0      (a two-sided/two-tailed test)


t_test_totwrk <- -0.14936 / 0.01678     ## is this value equal to the one given by the regression summary?


## After computing the t-test statistic, we look for the critical values.
## The "q" prefix functions do that for us, so there is no need to use tables.


qt(p = 0.05/2, df = 706 - 3 - 1)          ## for the lower tail value, using alpha.
qt(p = 1 - 0.05/2, df = 706 - 3 - 1)      ## for the upper tail, using 1-alpha.
                                          ## Note: this is a two-tailed test, so we divide alpha by 2.


# Based on the t-statistic and on the critical value, what is our inference from this test?


# Your answer:


##---------------------------------------------------------



##--- Repeat the same procedure for the other two slope coefficients.


##---------------------------------------------------------


##--- Finally, below the values for the R2 and the adjusted R2, we have the test statistic
## and the p-value for an F-test evaluating the joint significance of all slope coefficients.


##---------------------------------------------------------



##--- Estimating confidence intervals:


sleep_model %>% confint()                ## Interpretation?



sleep_model %>% confint(level = 0.99)    ## the default confidence level is 95%.




## Try estimating these intervals manually.


##---------------------------------------------------------



##--- Testing for linear restrictions (F-test):


## Suppose that, from our sleep model, we would like to test the following hypotheses:

# H0: beta_totwrk = beta_age = 0
# Ha: the null hypothesis is not true.


## This joint significance test requires us to use the F distribution.
## From the F-test formula, we also need to estimate a so-called "restricted" model.
## This means that we need to estimate a regression model without these two variables,
## and compare their respective goodness-of-fit measures.


sleep_model_res <- lm(sleep ~ yrsmarr, data = sleep75)

sleep_model_res %>% 
  summary()


## The R2 from the full (unrestricted model) is 0.1089,
## while the restricted's is 0.004096.

## Let us store them into R objects:

r2_restricted <- 0.004096
r2_unrestricted <- 0.1089

## We also need the DOF from the unrestricted model:

dof <- 706 - 3 - 1


## And q, the number of restrictions imposed (i.e., how many independent variables were removed from the model):

q <- 2


## Finally, we apply the F-test formula:

f_stat <- ( r2_unrestricted - r2_restricted )/( 1 - r2_unrestricted ) * (dof / q)


## F critical values:


qf(p = 0.05/2, df1 = 2, df2 = 702)         # and
qf(p = 1 - 0.05/2, df1 = 2, df2 = 702)           

## What do we conclude?




#--- A better (and easier) way is to use the command 'linearHypothesis', from the 'car' package.



sleep_model %>% linearHypothesis(c('totwrk = 0', 'age = 0'))            # Does this command give the 
                                                                        # same test statistic?





## And, as you may already have figured out, the F-statistics given in the regression summary
## is a test for joint significance for all slope coefficients. We can obtain the same value with
## the 'linearHypothesis' function:


sleep_model %>% summary()


sleep_model %>% linearHypothesis(c('totwrk = 0', 'age = 0', 'yrsmarr = 0'))  



##---------------------------------------------------------



##--- Practice:


## Go back to the models we estimated in previous applied lectures. 
## You should now be able to fully interpret all regression summaries.
