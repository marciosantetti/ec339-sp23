

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




##--- We will start by working with data from Mroz (1987), on female labor force data. 


## Reference: Mroz, T. A. (1987) "The sensitivity of an 
## empirical model of a married woman's hours of work to economic and 
## statistical assumptions," Econometrica, 55, 765-800.


mroz_data <- read_csv('mroz.csv')   ## Importing the data set into R.


##---------------------------------------------------------


#---First, a bit of data visualization:


# Family income vs. wife's hours worked:

mroz_data %>% 
  ggplot(aes(x=hours, y=faminc)) + 
  geom_point()


# Family income vs. years of labor market experience:

mroz_data %>%
  ggplot(aes(x=exper, y=faminc)) + 
  geom_point()


# Family income vs. husband's education:

mroz_data %>%
  ggplot(aes(x=heduc, y=faminc)) + 
  geom_point()


##---------------------------------------------------------



##--- Now, to the model! The procedure is the same as with simple regression, and we just need to
## add '+' signs for each covariate:


mult_reg1 <- lm(faminc ~ kidsl6 + hours + exper + heduc + hwage, data = mroz_data)


mult_reg1 %>% 
  summary()