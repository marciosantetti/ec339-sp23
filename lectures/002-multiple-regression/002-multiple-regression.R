

#== EC 339
#== Prof. Santetti 

#=============================================================================#
#                         MULTIPLE LINEAR REGRESSION IN R                     #
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
library(wooldridge) 


##---------------------------------------------------------




##--- We will start off working with data from Mroz (1987), on female labor force data. 


## Reference: Mroz, T. A. (1987) "The sensitivity of an 
## empirical model of a married woman's hours of work to economic and 
## statistical assumptions," Econometrica, 55, 765-800.


# The "mroz.csv" file is available in the course GitHub repository and on theSpring,
# as well as a .txt file describing its variables.


mroz_data <- read_csv('mroz.csv')   ## Importing the data set into R.


##---------------------------------------------------------


#---First, a bit of data visualization:


# Family income vs. wife's hours worked:

mroz_data %>% 
  ggplot(aes(x = hours, y = faminc)) + 
  geom_point()


# As we note that several individuals in the sample have not worked at all over the year, we
# may consider a data set only for individuals that have hours worked (hours > 0):


mroz_data %>% 
  filter(hours > 0) %>%                   ## using the "filter()" function.
  ggplot(aes(x = hours, y = faminc)) + 
  geom_point()


# Family income vs. years of labor market experience:


mroz_data %>%
  ggplot(aes(x = exper, y = faminc)) + 
  geom_point()


# The same goes for experience:


mroz_data %>%
  filter(exper > 0) %>% 
  ggplot(aes(x = exper, y = faminc)) + 
  geom_point()


# Family income vs. husband's education:

mroz_data %>%
  ggplot(aes(x = heduc, y = faminc)) + 
  geom_point()


##---------------------------------------------------------



##--- Now, to the model! The procedure is the same as with simple regression, and we just need to
## add '+' signs for each covariate:


mroz_data_filtered <- mroz_data %>% 
  filter(hours > 0 & exper > 0)


mult_reg1 <- lm(faminc ~ kidsl6 + hours + exper + heduc + hwage, data = mroz_data_filtered)


mult_reg1 %>% 
  summary()       ## Let us interpret each coefficient.



##---------------------------------------------------------


##--- Let us now play around with different functional forms:


## First, let us log-transform the dependent variable, faminc:


mroz_data_filtered %>% 
  ggplot(aes(x = exper, y = log(faminc))) +
  geom_point()


mroz_data_filtered %>% 
  ggplot(aes(x = hours, y = log(faminc))) +
  geom_point()


## And we run the same model as before, this time with log(faminc) as dependent variable:


mult_reg2 <- lm(log(faminc) ~ kidsl6 + hours + exper + heduc + hwage, data = mroz_data_filtered)


mult_reg2 %>% 
  summary()             ## Let us interpret each coefficient.




##--- Now, let us put both faminc and hwage in log-scale:


mroz_data_filtered %>% 
  ggplot(aes(x = log(hwage), y = log(faminc))) +
  geom_point()



## And a third (more parsimonious) model:


mult_reg3 <- lm(log(faminc) ~ log(hwage) + hours, data = mroz_data_filtered)

mult_reg3 %>% 
  summary()



## And we add a covariate for the number of the husband's siblings (hsiblings):



mult_reg4 <- lm(log(faminc) ~ log(hwage) + hours + hsiblings, data = mroz_data_filtered)

mult_reg4 %>% 
  summary()



##--- In terms of goodness-of-fit, i.e., R-squared and adjusted R-squared measures, how do you 
## evaluate models 3 and 4?




##---------------------------------------------------------


##--- Finally, let us estimate a level-log model:


mult_reg5 <- lm(faminc ~ log(taxableinc), data = mroz_data_filtered)

mult_reg5 %>% 
  summary()         ## How do we interpret the coefficient?



##---------------------------------------------------------


#--------- Practice:


#== Download the 'fast_food.csv' file (there is also a .txt file available, describing its variables). 
#== It contains data for 75 fast-food chain franchises.
#== I have included a .txt file describing the data set.
#== Set up a multiple regression model for sales, controlling for prices and advertising expenses.

#== Interpret the results, and play around with different functional form specifications, such as 
#== log-level and log-log models.


