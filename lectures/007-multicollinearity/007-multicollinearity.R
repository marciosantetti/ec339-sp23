

#== EC 339
#== Prof. Santetti 

#=============================================================================#
#              PERFECT/IMPREFECT MULTICOLLINEARITY IN PRACTICE                #
#=============================================================================#


#== IMPORTANT: Before any operations, make sure to set your working directory.
# In other words, you have to tell R in which folder you will save your work, or
# from which folder external data sets will come from. In the lower-right pane, 
# click on 'Files.' Select your desired folder, and click on 'More', then select 
# the option 'Set as Working Directory.'

#================================================================================================#






###--- Loading the necessary packages for today:


library(tidyverse)
library(car)
library(corrr)      ## for correlation matrices.

##---------------------------------------------------------



##-- We will a subset of the Penn World Tables (PWT 9.1).

## Official page: https://www.rug.nl/ggdc/productivity/pwt/pwt-releases/pwt9.1?lang=en
## Data description: https://www.rdocumentation.org/packages/pwt9/versions/9.1-0/topics/pwt9.1


pwt_data <- read_csv("pwt_select.csv")



##---------------------------------------------------------


##-- Verifying pairwise correlation coefficients among selected variables:


pwt_data %>% 
  select(pop, emp, ccon, ck) %>% 
  orrelate()                              ## What do we conclude?



##-- Some visual checks:


pwt_data %>% 
  ggplot(aes(x = pop, y = emp)) +
  geom_point()


pwt_data %>% 
  ggplot(aes(x = ccon, y = ck)) +
  geom_point()


##---------------------------------------------------------


##-- Estimating regression models:


multi_ols <- lm(log(rgdpna) ~ pop + emp + ck + ccon, data = pwt_data)

multi_ols %>% 
  summary()


##-- And let's calculate this model's Variance Inflation Factors (VIFs),
##-- with the 'vif()' function from the 'car' package:

multi_ols %>% 
  vif()                   ## What do we conclude?


## Where do these values come from?


# pop:

aux_pop <- lm(pop ~ emp + ccon + ck, data = pwt_data)

aux_pop %>% summary()

vif_pop <- 1/(1 - 0.9766)


# emp:

aux_emp <- lm(emp ~ pop + ccon + ck, data = pwt_data)

aux_emp %>% summary()

vif_emp <- 1/(1 - 0.9794)


# ccon:

aux_ccon <- lm(ccon ~ pop + emp + ck, data = pwt_data)

aux_ccon %>% summary()

vif_ccon <- 1/(1 - 0.9634)


# ck:

aux_ck <- lm(ck ~ pop + emp + ccon, data = pwt_data)

aux_ck %>% summary()

vif_ck <- 1/(1 - 0.9671)     ## are these values close to the ones given by the 'vif()' function?



##---------------------------------------------------------


##-- Since our VIFs are not very exciting, we estimate a new model:


multi_ols2 <- lm(log(rgdpna) ~ log(emp) + log(ccon) + ck, data = pwt_data)

multi_ols2 %>% 
  summary()


## And check the VIFs:

multi_ols2 %>% 
  vif()                           ## what do we conclude?
