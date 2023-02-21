

#== EC 339
#== Prof. Santetti 

#=============================================================================#
#                            FUNCTIONAL FORMS IN R                            #
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

##--- Regression through the origin:


data("sleep75")


sleep75 <- sleep75 %>% 
  as_tibble()



## One may suppose that, if an individual works 0 minutes per week, they will make no earnings at all.

## Let us visually check this:



sleep75 %>% 
  ggplot(aes(y = earns74, x = totwrk)) +
  geom_point()


## In case we want to estimate a regression model with no intercept term, we just do the following:


model_origin <- lm(earns74 ~ 0 + totwrk, data = sleep75)    ## we just need to put a '0' after the '~' symbol.


model_origin %>%
  summary()



## And we can check the regression fit:


sleep75 %>% 
  ggplot(aes(y = earns74, x = totwrk)) +
  geom_point() +
  geom_smooth(formula = "y ~ 0 + x", method = "lm", se = FALSE)



##---------------------------------------------------------



##--- Inverse forms:


chicken_data <- read_csv('chicken_demand.csv')


inverse_model <- lm(q ~ I(1/p), data = chicken_data)    ## notice the use of the 'I()' function for
                                                            ## the inverse term. It is necessary, since
                                                            ## this function tells R to read the term
                                                            ## "as it is."

inverse_model %>% 
  summary()



## And we can check the regression fit:


chicken_data %>% 
  ggplot(mapping = aes(x=p, y=q)) + 
  geom_point() + 
  geom_smooth(method="lm", se=FALSE, formula = "y ~ I(1/x)")



## Interpretation:

# Marginal effect =  [-beta_(price)/p^2 = -48.365/mean(p)^2]

chicken_data %>% 
  summarize(mean(p))

# A one-unit increase in the real price index of chicken decreases per capita consumption of chicken by
# [-48.365/(1.45^2) =] 23 pounds.



##---------------------------------------------------------


###--- Using quadratic terms:


data("hprice2")

hprice2 <- hprice2 %>% 
  as_tibble()


model_quad <- lm(lprice ~ lnox + log(dist) + rooms + 
                   I(rooms^2) + stratio, data = hprice2)                ## notice the use of the 'I()' function for
                                                                        ## the squared term.


model_quad %>% 
  summary()

hprice2 %>% 
  ggplot(aes(x=nox, y=lprice)) + 
  geom_point() + 
  geom_smooth(method="lm", se=FALSE, formula = "y ~ x + I(x^2)")



#-- How does the number of rooms relate to the price of a house?

## Interpretation: At low values (number) of rooms, an additional room has a negative 
## effect on log(price). Then, at some point, the effect becomes positive, due to the 
## positive sign on rooms^2. Quantitatively, 
## 100*[-.5451 + 2*(.0622)*(rooms)]. Since the variable 'room' remains here for the 
## marginal effect computation, a good practice is to put the average number of that
## variable. In this case, rooms.

hprice2 %>% 
  summarize(mean(rooms))

## Rounding it, the average number of rooms in this sample is 6. Plugging in 6 there,
## we get the marginal effect of the number of rooms in the price of a house. Given
## that the dependent variable is in logs, we multiply it by 100 and get the result as a 
## percentage. Therefore,

## 100*[-.5451 + 2*(.0622)*(6)] = 20.13. Ceteris paribus, for a house starting with 6
## rooms, an additional room will increase its price by 20.13%.


##---------------------------------------------------------


###--- Interactions and binary (dummy) variables:


data("wage1")


wage1 <- wage1 %>% 
  as_tibble()


model_interaction <- lm(lwage ~ female + educ + exper + tenure + educ:tenure, data = wage1)   ## for interactions,
                                                                                              ## use ":".

model_interaction %>% 
  summary()



## How do we interpret the effect of education on wages?


## Let's work on this together.


##---  How to interpret the effect of gender on wages?

# When female=1 (i.e., for female workers), hourly wages are 100*[exp(beta_female) - 1] = 
# 100*[exp(-0.3045109) - 1 =] 26.25% lower for female workers, relative to male workers.

# When female=0 (i.e., for male workers), hourly wages are 100*[exp(-beta_female) - 1] = 
# 100*[exp(+0.3045109) - 1 =] 35.6% higher for male workers, relative to female workers.



## The above calculation gives the exact effect of the binary variable on the logged independent variable.
## For slope dummy variables, we can use the usual derivative approach, which will give an approximate
## marginal effect.



model_dummy5 <- lm(lwage ~ female + educ + female:educ + exper + I(exper^2) +
                     tenure + I(tenure^2), data = wage1)

model_dummy5 %>% summary()


#== What is the estimated return to education for men?
## 100*[.082 + (-.0056)*0=] 8.2%.

#== What is the estimated return to education for women?
## 100*[.082 + (-.0056)*1=] 7.6%.

## The gender differential for education between men and women is given by the 
## coefficient on the slope dummy variable female*educ.
## Therefore, the difference is of .56% percentage point less for women. However, this 
## coefficient is not statistically significant for this sample.


