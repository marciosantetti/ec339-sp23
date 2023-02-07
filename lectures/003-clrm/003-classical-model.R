

#== EC 339
#== Prof. Santetti 

#=============================================================================#
#        THE CLASSICAL LINEAR REGRESSIO MODEL LINEAR REGRESSION IN R          #
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
library(rstatix)      ## for a specific normality test.


##---------------------------------------------------------


##--- Assumption 1: the model is linear in parameters, well-specified, 
# and contains an additive error term.


## We will study this assumption through artificial data.


# Let us create some random numbers. The first step is to set a common "seed" for reproducibility:


set.seed(1234)


x1_true <- 30 + 2 * runif(n = 100, min = 20, max = 60)                        ## the "true" process defining x1.


x2_true <- 10 + 0.5 * x1_true * rnorm(n = 100, mean = 0, sd = 1)               ## the "true" process defining x2.


y_true <- 45 + 2 * x1_true + 4 * x2_true + rnorm(n = 100, mean = 0, sd = 1)    ## the "true" process defining y.




true_data <- cbind(x1_true, x2_true, y_true) %>%       ## joining all columns.
  as_tibble()                                          ## converting to a tibble format.



## Visualizing:

true_data %>% 
  ggplot(aes(y = x2_true, x = x1_true)) +
  geom_point()



## Estimating a model for "y_true" without "x1_true":


model_omit <- lm(y_true ~ x2_true, data = true_data)

model_omit %>% 
  tidy()                   ## Does the estimation match the "true" model?



## Now, estimating the model with all relevant variables:


model_true <- lm(y_true ~ x1_true + x2_true, data = true_data)

model_true %>% 
  tidy()                                            ## What is the difference now?




##------------------------------------------------------------------------


#--- Assumption 2: the error term has a zero population mean.



set.seed(200) 



x <- 50 - 100 * runif(n = 50, min = -50, max = 50)      ## creating an 'x' vector, whose function has an 
                                                        ## intercept of 50, and its slope multiplies 
                                                        ## a random variable uniformly
                                                        ## distributed, with 50 observations, ranging from
                                                        ## -50 and +50.


y <- 100 + 2 * x + rnorm(50)              ## 'y' is a function of x, and also of a normally 
                                          ## distributed component, with 50 observations. If we
                                          ## do not specify a mean and standard deviation to the
                                          ## 'rnorm()' command, it assumes a standard normal 
                                          ## distribution, that is, a mean of 0 and SD of 1.


data_clrm2 <- cbind(y, x) %>% 
  as_tibble()



data_clrm2 %>% 
  ggplot(aes(x = x, y = y)) + 
  geom_point()


model_clrm2 <- lm(y ~ x, data = data_clrm2)



data_clrm2 %>% 
  ggplot(aes(x = x, y = y)) + 
  geom_point() + 
  geom_smooth(method = "lm", se = FALSE)




u_term <- model_clrm2 %>% 
  resid()


data_clrm2 <- data_clrm2 %>% 
  add_column(u_term)


data_clrm2 %>% 
  summarize(mean_u = mean(u_term))



##---------------------------------------------------------


#--- Assumption 3: All explanatory variables are uncorrelated with the error term.


## To check this assumption, let us simply calculate correlation coefficients from
## our previous model:



data_clrm2 %>% 
  summarize(cor_x_u = cor(x, u_term))       ## Is there a correlation?




##---------------------------------------------------------


##--- Assumption 4: Observations of the error term are uncorrelated with each other.


## For this example, let us use some real-world data from the 'wooldridge' package:


data("fertil3")


fertil3 <- fertil3 %>% 
  as_tibble()



model_clrm4 <- lm(gfr ~ pe + ww2 + pill, data = fertil3)


resid_auto <- model_clrm4 %>% resid()                 ## extracting the residual term.


fertil3 <- fertil3 %>% 
  add_column(resid_auto)                              ## adding the residuals series to the original data set.



fertil3 %>% 
  ggplot(aes(x = year, y = resid_auto)) +       ## now, a plot. How does it look?
  geom_point() + 
  geom_line()




##---------------------------------------------------------



#--- Assumption 5: the error term has a constant variance (homoskedasticity assumption).


z <- seq(from = 1, to = 50, by = 1)                             ## creating a sequence from 1 to 50, 1 by 1.

set.seed(200)

w <- 50 + 0 * z + rnorm(n = 50, mean = 0, sd = 0.1 * z)         ## 'w' is a vector which is not 
                                                                ## linearly related to 'z,' but has a
                                                                ## random component whose standard 
                                                                ## variation is a linear 
                                                                ## function of 'z.'


data_het <- cbind(w, z) %>% 
  as_tibble()


data_het %>% 
  ggplot(aes(x = z, y = w)) + 
  geom_point()


model_het <- lm(w ~ z)


resid_het <- model_het %>% 
  resid()


data_het <- data_het %>% 
  add_column(resid_het)


data_het %>% 
  ggplot(aes(x = z, y = resid_het)) +
  geom_point()

# Question: what is the main difference between the model run in Assumption 2
# and the one for Assumption 5?


##---------------------------------------------------------

##--- Assumption 6: No explanatory variable is a perfect linear function
## of any other explanatory variable (no multicollinearity assumption).


set.seed(123)

x1 <- runif(25, 0, 100)                      ## 'x1' is a random variable uniformly distributed. 25 observations,
                                             ## ranging from 0 to 100.




x2 <- 0.25*x1                               ## we are generating a variable 'x2', which is clearly a linear 
                                            ## function of 'x1'.




y_multi <- 0.5 * x1 + 0.5 * x2 + rnorm(25)            ## 'y' is a function of x1, x2, and also has a random,
                                                      ## normally distributed component.

ols_multi <- lm(y_multi ~ x1 + x2)



ols_multi %>% 
  summary()

##---------------------------------------------------------



#--- Assumption 7: the error term is normally distributed.


## Looking at the error term from Assumption 5:

data_het %>% 
  ggplot(aes(x = resid_het)) +
  geom_density()


## The Shapiro-Wilk test for normality is a common statistical test that we can
## apply for testing CLRM Assumption 7:



resid_het %>% 
  shapiro_test()     ## using the "shapiro_test()" function from tge {rstatix} package.



# H0: the random variable is normally distributed;
# Ha: H0 is not true.


# What do you conclude?
