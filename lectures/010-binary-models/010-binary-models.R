

#== EC 339
#== Prof. Santetti 

#=============================================================================#
#                   BINARY DEPENDENT VARIABLE MODELS IN PRACTICE              #
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
library(jtools)
library(huxtable)
library(margins)


##---------------------------------------------------------


##--- Let us start with data from the 1976 Current Population Survey (CPS),
## and used in several examples from Wooldridge's "Introductory Econometrics":

data("wage1")

wage1 <- wage1 %>% 
  as_tibble()


## Suppose we would like to determine the factors that might help to explain someone
## receiving a higher wage per hour. For the 1970s, let us assume that
## an hourly wage of $6 is a good measure.

## Then, let us create a binary variable that equals "1" if the individual in the sample 
## has a wage higher than $6 per hour, and "0" otherwise.


## We do the following:

wage1 <- wage1 %>% 
  mutate(highwage = if_else(condition = wage > 6, true = 1, false = 0))


## Quick check...


wage1 %>% 
  select(wage, highwage)



##--- The Linear Probability Model (LPM):


## Using OLS to estimate a model with a binary variable on the LHS is our starting point:


lpm_1 <- lm(highwage ~ educ + exper + tenure + female, data = wage1)


lpm_1 %>% 
  summary()


## How do we interpret these coefficients?



## A second model (adding "nonwhite"):


lpm_2 <- lm(highwage ~ educ + exper + tenure + female + nonwhite, data = wage1)


lpm_2 %>% 
  summary()


## How do we interpret these coefficients?



## Looking at these models fitted values (or predicted probabilities):

pred_prob <- lpm_2 %>% 
  fitted() %>% 
  as_tibble()




##--- The binary logit model:


## Moving on from linear models, a first option we may adopt is
## the logit model, which uses the logistic function 
## to keep the predicted probabilities of
## success [P(y = 1 | x)] between 0 and 1:


logit_2 <- glm(highwage ~ educ + exper + tenure + female + nonwhite, 
              data = wage1,
              family = binomial(link = "logit"))


logit_2 %>% 
  summary()


## These coefficients are not directly interpretable, since these are simply the "beta"
## values that maximize the likelihood of success across all observations in the sample.


## However, we can use Average Marginal Effects (AME) to have a direct and meaningful interpretation.
## These are simply the marginal effects for all individuals averaged out.

## We use the {margins} package:

logit_2_ame <- logit_2 %>% 
  margins()

logit_2_ame %>% 
  summary()


## How do we interpret these?



##--- The binary probit model:



## The probit model's procedure is exactly the same as the logit's.
## The main difference lies in in using the Standard Normal distribution's
## Cumulative Density Function (CDF) to keep the predicted probabilities of
## success [P(y = 1 | x)] between 0 and 1:


probit_2 <- glm(highwage ~ educ + exper + tenure + female + nonwhite, 
                data = wage1,
                family = binomial(link = "probit"))


probit_2 %>% 
  summary()


## And Average Marginal Effects:


probit_2_ame <- probit_2 %>% 
  margins()

probit_2_ame %>% 
  summary()


## How do we interpret these?



##--- Let us compare the three models by using the "export_summs()" function from the
## {jtools} package:


export_summs(lpm_2, logit_2_ame, probit_2_ame,
             model.names = c("LPM", "Logit", "Probit"))

##---------------------------------------------------------


## Our second set of examples will use data from the Current Population Survey (CPS), with a 
## sample of workers from Boston and Chicago to study employment patterns by race,
## gender, education, and experience.


cps_data <- read_csv('cps_data.csv')

cps_data %>% 
  count(educ)


# We can see that 'educ' is not a numeric, but a character variable. Let's adopt a 
# simple strategy and create a dummy variable that takes on 1 if the individual 
# has at least finished college, and 0 otherwise.


cps_data <- cps_data %>% 
  mutate(higher_ed = if_else(educ == "College or Higher", true = 1, false = 0))


##--- Linear Probability Model:


lpm_cps <- lm(employed ~ black + female + higher_ed + exper, data = cps_data)

lpm_cps %>% 
  summary() 



##--- Logit Model:

logit_cps <- glm(employed ~ black + female + higher_ed + exper, 
    data = cps_data,
    family = binomial(link = "logit"))          ## note that we use the "glm" function.


logit_cps_ame <- logit_cps %>%
  margins()


logit_cps_ame %>% 
  summary()




##--- Probit Model:

probit_cps <- glm(employed ~ black + female + higher_ed + exper, 
                 data = cps_data,
                 family = binomial(link = "probit"))          ## note that we use the "glm" function.


probit_cps_ame <- probit_cps %>%
  margins()


probit_cps_ame %>% 
  summary()



##--- Comparison:

export_summs(probit_cps_ame, logit_cps_ame,
             model.names = c("Probit", "Logit"))
