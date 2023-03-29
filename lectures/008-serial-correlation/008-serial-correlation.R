

#== EC 339
#== Prof. Santetti 

#=============================================================================#
#                       SERIAL CORRELATION IN PRACTICE                        #
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
library(orcutt)
library(tsibble)
library(forecast)
library(patchwork)

##---------------------------------------------------------


##--- Okun's law model:

## Let us reproduce the model we saw in class, exploring Okun's law for 
## the Australian economy between 1978Q2 and 2016Q2.


okun <- read_csv('okun.csv') 


## Notice that we are working now with time-series data (we are observing the behavior of
## one or more variables over time).

## For most of our modeling purposes, nothing changes compared to working with cross-section data.
## However, for data manipulation/plotting purposes, setting our data set as a time-series one
## provides extra flexibility.

## The {tsibble} package helps us with that.


## Notice that this data set has a quarterly frequency, beginning in the second quarter of 1978.


## In case we want to convert the "date" column into a "date" class,
## we do the following:


okun <- okun %>% 
  mutate(date = yearquarter(date))            ## setting the 'date' column to an actual date column.

okun <- okun %>% 
  as_tsibble(index = date)                    ## now, setting it as a "tsibble" object.



## Plotting (notice the x-axis labels):

okun %>% 
  ggplot(aes(x = date, y = g)) +
  geom_line()


okun %>% 
  ggplot(aes(x = date, y = u)) +
  geom_line()




##--------



okun <- okun %>% 
  mutate(du = u - lag(u, n = 1))        ## creating the change in unemployment variable.



##== Regression model:


## Now we estimate a version of Okun's law:


okun_model <- lm(du ~ g, data = okun)

okun_model %>% 
  summary()



## Extracting the residual term:


okun_resid <- okun_model %>% 
  resid()





okun <- okun %>%
  add_column(okun_resid = c(NA, okun_resid))                ## we have to add an "NA" value, since we have one 
                                                            ## less observation for "du."


## And we plot the residuals:

okun %>% 
  ggplot(aes(x=date, y=okun_resid)) + 
  geom_line() + 
  geom_point()




## From a visual perspective, it is not always straightforward to assess whether the error term is
## autocorrelated or not.

## Therefore, we need some statistical tests for a better inference.



##---------------------------------------------------------------------


##--- Testing for serial correlation:


## Let us first use the R commands for the Durbin-Watson (DW) and Breusch-Godfrey (BG) tests,
## using the functions from the 'lmtest' package.



# Durbin-Watson test:


okun_model %>% 
  dwtest()                      ## what do we conclude?


# Breusch-Godfrey test:


okun_model %>% 
  bgtest(order = 1, fill = NA)   ## what do we conclude?




##--- Now, where do these results come from?


## First, for the DW test.

## Its test statistic can be approximated by 2*(1 - rho), 
## where "rho" is the error term's autocorrelation coefficient.

## So let's estimate "rho":


okun_resid_lm <- lm(okun_resid ~ 0 + lag(okun_resid, n = 1), data = okun)

okun_resid_lm %>% 
  summary()               ## what is its value?



rho <- 0.3339



## We can also look at the Autocorrelation Function (ACF) plot for this residual:

okun %>% 
  select(okun_resid) %>% 
  ggAcf() + 
  labs(title = "ACF plot for Okun's law residual term")   ## this plot gives "rho" at every lag.


## Next, we just plug into the DW test statistic:


dw_stat <- 2*(1 - rho)    ## is this test statistic close the the "dwtest()" command's?


## Given this test statistic, we simply look for lower and upper critical values in the DW table.



##--- Now, to the Breusch-Godfrey test.

## It requires a more comprehensive auxiliary regression for the regression's residuals,
## also including the independent variable(s) from the original model.



okun_resid_lm2 <- lm(okun_resid ~ lag(okun_resid, n=1) + g, data = okun)

okun_resid_lm2 %>% 
  summary()

## Its test statistic is given by LM = (n - q)*R2, where R2 is the coefficient of determination
## from this latter auxiliary regression. "n" is the sample size, and "q" is the
## order of autocorrelation we are testing for.


lm_stat <- (152 - 1)*0.1202   ## recall that the sample size is 152 because we lose one observation by using "du".

## Is this test statistic close to the one given by the "bgtest()" function?


##--- Given that we have serial correlation in our Okun's law model,
## we cannot trust in its standard errors. Therefore, inference from this model is unreliable.


## As a solution for first-degree serial correlation, we can use the Cochrane-Orcutt (CO) estimator:


co_okun_model <- okun_model %>% 
  cochrane.orcutt()

co_okun_model %>% 
  summary()    ## do we still have serial correlation?


##---------------------------------------------------------------------


##--- A second example: interest rates vs. profit rates in the US (1955-2016)


##=== Data prep:


macro_data <- read_csv('annual_data.csv')

macro_ts <- macro_data %>% 
  as_tsibble(index=year)


macro_ts <- macro_ts %>% 
  mutate(int_rate = ifedfunds - infrate,
         profit_rate = (cp/k) * 100)              ## creating time series for the real interest
                                                  ## rate and the profit rate.


## Visually:

plot3 <- macro_ts %>% 
   ggplot(aes(y=int_rate, x=year)) + 
   geom_line(size=0.7, color="blue") + 
   geom_point(color="blue") + 
   theme_minimal()

plot4 <- macro_ts %>% 
  ggplot(aes(y=profit_rate, x=year)) + 
  geom_line(size=0.7) + 
  geom_point() +
  theme_minimal()


plot3 / plot4




##--- Testing for serial correlation:


macro_model <- lm(int_rate ~ profit_rate, data = macro_ts)

macro_model %>% 
  summary()





macro_model %>% 
  dwtest()

macro_model %>% 
  bgtest(order = 1, fill = NA)     ## what do we conclude?




##--- Cochrane-Orcutt estimator:


co_macro_model <- macro_model %>% 
  cochrane.orcutt()



co_macro_model %>% 
  summary()                        ## what do we conclude?





