

#== ECON 4650-001 -- Spring 2021
#== Marcio Santetti

#=============================================================================#
#                        MULTIPLE LINEAR REGRESSION                           #
#=============================================================================#


#== IMPORTANT: Before any operations, make sure to set your working directory.
# In other words, you have to tell R in which folder you will save your work, or
# from which folder external data sets will come from. In the lower-right pane, 
# click on 'Files'. Select your desired folder, and click on 'More', then select 
# the option 'Set as Working Directory'.

#==============================================================================#

# Installing and/or loading required packages:


library(tidyverse)
library(broom)
library(wooldridge)


#==============================================================================#



##== We will start by working with data from Mroz (1987), on female labor force data. 


## Reference: Mroz, T. A. (1987) "The sensitivity of an 
## empirical model of a married woman's hours of work to economic and 
## statistical assumptions," Econometrica, 55, 765-800.


mroz_data <- read_csv('mroz.csv')   ## Importing the data set into R.


## First, a bit of data visualization:


# Family income vs. wife's hours worked:

mroz_data %>% ggplot(mapping = aes(x=hours, y=faminc)) + geom_point()


# Family income vs. years of labor market experience:

mroz_data %>% ggplot(mapping = aes(x=exper, y=faminc)) + geom_point()


# Family income vs. husband's education:

mroz_data %>% ggplot(mapping = aes(x=heduc, y=faminc)) + geom_point()



## Now, to the model! The procedure is the same as with simple regression, and we just need to
## add '+' signs for each covariate:



mult_reg1 <- lm(log(faminc) ~ kidsl6 + hours + exper + heduc + hwage, data=mroz_data)

summary(mult_reg1)       ## Interpretation? 




##== A second model:


mult_reg2 <- lm(wage ~ mothereduc + fathereduc + hours + educ + exper, data=mroz_data)

summary(mult_reg2)



#=======================================================================================#


#====== 3. TSS, ESS, and RSS:


mroz_data %>% summarize(TSS = sum((wage - mean(wage))^2),
                        
                        ESS = sum((fitted(mult_reg2) - mean(wage))^2),
                        
                        RSS = sum(resid(mult_reg2)^2), 
                        
                        TSS_proof = ESS + RSS,              ## Is TSS equal to ESS and RSS?
                        
                        R_squared = ESS/TSS,                ## Is it equal to the regression's summary?
                        
                        n = nrow(mroz_data),                ## sample size.
                          
                        k = 5,                              ## number of slope coefficients.
                        
                        adj_R_squared = 1 - ( (RSS/(n-k-1) ) / (TSS/(n-1) ) ) ) ## Is it equal to the summary?




##== And how to properly interpret the R-squared and Adjusted R-squared coefficients?


#=======================================================================================#



#================ Units of Measurement & Functional Forms:


#== From the 'wooldridge' package, let us import the 'smoke' data set.


data("smoke")

smoke <- as_tibble(smoke)


smoke_reg1 <- lm(cigs ~ educ + income + age, data=smoke)

summary(smoke_reg1)


tidy(smoke_reg1)



#== Now, we create a new variable, called 'inc1000', representing income in 
#== thousands of dollars.


smoke <- smoke %>% mutate(inc1000 = income/1000)    ## now, the new variable is incorporated to the original
                                                    ## data set.


#== Now, a new regression model, with 'inc100' as an independent variable

smoke_reg2 <- lm(cigs ~ educ + inc1000 + age, data = smoke)

summary(smoke_reg2)      # What is the difference between these two models?

 
tidy(smoke_reg1)      ## to compare the coefficients.
tidy(smoke_reg2)


## Comparing the coefficients from each model, we can see that the intercept, 'educ',
## and 'age' values remain the same. Since we have divided the original variable
## 'income' by 1000, the new coefficient on 'inc1000' will be [income*1000 = 
## .000117 * 1000 =] .117. Now, on average, holding all else constant, for every 
## thousand dollar increase in income, cigarette consumption will increase by .117
## units.



#== Now, let's modify the dependent variable. Assuming that a cigarette pack
#== has 20 units, let's create a new variable, called 'cigpack':


smoke <- smoke %>% mutate(cigpack = cigs/20)


## And run a new regression model:

smoke_reg3 <- lm(cigpack ~ educ + income + age, data = smoke)

summary(smoke_reg3)


## Now, we compare this last model with 'smoke_reg1':

tidy(smoke_reg1)     
tidy(smoke_reg3)              # What is the difference between these two models?


## Since we have modified the dependent variable (y), we have changed the 
## left-hand side of the regression equation. In order to keep the right-hand side
## equal, we have to impose the same change to it. Therefore, since our 'y' variable
## has been divided by a scalar equal to 20, each coefficient on the RHS will
## also be divided by 20. Therefore, the coefficients of 'smoke_reg3' are the ones
## from 'smoke_reg1' divided by 20. Notice that all other goodness-of-fit measure remain
## the same regardless of the transformation.





#=================== Functional forms (logs):


data("wage1")



#== Log-level model:


wage1 <- as_tibble(wage1)


## Now, a quick visual inspection:

wage1 %>% ggplot(mapping = aes(x=educ, y=lwage)) + geom_point() + geom_smooth(method='lm', se=FALSE)


## Estimating the log-level model:


log.level <- lm(lwage ~ educ + exper, data = wage1)

summary(log.level)                   # Interpretation:


# On average, and holding all other factors constant, every additional year of 
# education increases wages by [.098*100=] 9.8%. Also, holding years of education
# constant, every additional year of experience increases wages by [.010*100=] 10%, on
# average.


# R-squared interpretation: the model is responsible for explaining 24.93% of the 
# variation in LOG(WAGES). 


# Adjusted R-squared interpretation: the model is responsible for explaining 24.65% 
# of the variation in LOG(WAGES), around its mean and adjusted for degrees of freedom.
# Notice that when interpreting the R-squared measures, we have to refer to the 
# dependent variable using the functional form (in this case, logs). When interpreting
# the coefficients, though, we may only consider 'wages'.




#== Log-log (elasticity) model:

data("ceosal2")





## Estimating a log-log model (aka constant elasticity model):


log.log <- lm(lsalary ~ lsales, data = ceosal2)

summary(log.log)                    # Interpretation?



# On average, for every 1% increase in sales, CEO salaries increase by .2242%.

# R-squared and adjusted R-squared interpretations follow the same logic as
# with the last log-level model.



#== Level-log model:


level.log <- lm(salary ~ lsales, data = ceosal2)

summary(level.log)                 # Interpretation? for every 1% increase in sales, the worker's salary
                                   # increases by [beta_lsales / 100] = 1.77 thousands of dollars.


# On average, for every 1% increase in sales, CEO salaries increase by [177.15/100=]
# 1.7715 US$ thousand.



#==============================================================================#


#======== Practice:


#== On Canvas, download the 'fast_food.csv' file. It contains data for 75 fast-food chain franchises.
#== I have included a .txt file describing the data set.
#== Set up a multiple regression model for sales, controlling for prices and advertising expenses.

#== Interpret the results, and play around with different functional form specifications, such as 
#== log-level and log-log.