

#== ECON 4650-001 -- Spring 2021
#== Marcio Santetti

#=============================================================================#
#                      BINARY DEPENDENT VARIABLE MODELS                       #
#=============================================================================#


#== IMPORTANT: Before any operations, make sure to set your working directory.
# In other words, you have to tell R in which folder you will save your work, or
# from which folder external data sets will come from. In the lower-right pane, 
# click on 'Files'. Select your desired folder, and click on 'More', then select 
# the option 'Set as Working Directory'.


#==============================================================================#



#== Installing and/or loading required packages:


library(tidyverse)
library(broom)
library(wooldridge)
library(margins)
library(ggfortify)
library(patchwork)



#==================================================================================================#


## Our first examples will use data from the Current Population Survey (CPS), with a 
## sample of workers from Boston and Chicago to study employment patterns by race,
## gender, education, and experience.


cps_data <- read_csv('cps_data.csv')

cps_data %>% count(educ)


# We can see that 'educ' is not a numeric, but a character variable. Let's adopt a 
# simple strategy and create a dummy variable that takes on 1 if the individual 
# has at least finished college, and 0 otherwise.


cps_data <- cps_data %>% mutate(higher_ed = case_when(educ == "College or Higher" ~ 1,
                                                      TRUE ~ 0))

# done.


##=== The Linear Probability Model (LPM):


## The Linear Probability Model (LPM) is simply OLS applied to models with dummy dependent variables. 
## Despite its limitations, it can still be useful for simple analyses.


lpm_cps <- lm(employed ~ black + female + higher_ed + exper + I(exper^2), data = cps_data)

lpm_cps %>% tidy()    ## how to interpret these results?


## exper: Ceteris paribus, for an individual with 21 years of job market experience, 
## she is 100*[0.0160 + 2*21*-0.000416=] .1472% less likely to be employed (P(employed=1)).

## higher_ed: Ceteris paribus, an individual with at least a college degree or higher (higher_ed=1),
## is 100*0.0874 = 8.74% more likely to be employed, relative to an individual with fewer years of
## education.


## Plotting marginal effects:



p1 <- cps_data %>% ggplot(aes(x=higher_ed, y=employed)) + geom_point(shape=21, color="red") + 
  geom_smooth(method='lm', se=F, color="deepskyblue4") +
  geom_jitter(height = 0.1, width = 0.1, color="red", alpha=0.3, shape=21) +
  theme_bw() + labs(y="P(employed = 1)")

p2 <- cps_data %>% ggplot(aes(x=black, y=employed)) + geom_point(shape=21, color="red") + 
  geom_smooth(method='lm', se=F, color="deepskyblue4") +
  geom_jitter(height = 0.1, width = 0.1, color="red", alpha=0.3, shape=21) +
  theme_bw() + labs(y="P(employed = 1)")

p3 <- cps_data %>% ggplot(aes(x=exper, y=employed)) + geom_point(shape=21, color="red") + 
  geom_smooth(formula = "y ~ x + I(x^2)", method='lm', se=F, color="deepskyblue4") +
  theme_bw() + labs(y="P(employed = 1)")

p4 <- cps_data %>% ggplot(aes(x=female, y=employed)) + geom_point(shape=21, color="red") + 
  geom_smooth(method='lm', se=F, color="deepskyblue4") +
  geom_jitter(height = 0.1, width = 0.1, color="red", alpha=0.3, shape=21) +
  theme_bw() + labs(y="P(employed = 1)")


(p1 + p2) / (p3 + p4)


#==================================================================================================#



##=== The Logit Model:


## The binomial logit model assumes the regression model as a random variable following a 
## Logistic distribution.


pdf_logis <- ggdistribution(dlogis, seq(from = -8, to = 8, by = 0.1), location = 0, scale = 1) + 
  labs(title = "Logistic Distribution - Probability Density Function (PDF)") + theme_bw()


cdf_logis <- ggdistribution(plogis, seq(from = -8, to = 8, by = 0.1), location = 0, scale = 1) + 
  labs(title = "Logistic Distribution - Cumulative Density Function (CDF)") + theme_bw()


pdf_logis / cdf_logis



## Estimating a logit model:


logit_cps <- glm(employed ~ black + female + higher_ed + exper + I(exper^2), 
                 data = cps_data,
                 family = binomial(link = "logit"))          ## note that we use the "glm" function.


logit_cps %>% tidy()    ## interpretation?



## Estimating Average Marginal Effects (AME):

# Since the coefficients from logit models are not directly interpretable, we
# must adopt another strategy for magnitude interpretation. AMEs are a great
# alternative.


# First, manual computation:


mean(dlogis(predict(logit_cps, type='link'))) * coef(logit_cps)   ## compare with the formula from 
                                                                  ## the lecture notes.

# Second, using the "margins" package:


logit_cps %>% margins() %>% summary() 



## Plotting marginal effects:

p5 <- cps_data %>% ggplot(aes(x=exper, y=employed)) + geom_point(shape=21, color="red") + 
  geom_smooth(method="glm", method.args=list(family=binomial(link="logit")), 
              se=FALSE, color="deepskyblue4", formula="y ~ x + I(x^2)") +
  theme_bw() + labs(y="P(inlf = 1)")

p6 <- cps_data %>% ggplot(aes(x=higher_ed, y=employed)) + geom_point(shape=21, color="red") + 
  geom_smooth(method="glm", method.args=list(family=binomial(link="logit")), 
              se=FALSE, color="deepskyblue4") +
  geom_jitter(width = 0.1, height = 0.1, alpha = 0.3, shape = 21, color="red") +
  theme_bw() + labs(y="P(inlf = 1)")

p7 <- cps_data %>% ggplot(aes(x=female, y=employed)) + geom_point(shape=21, color="red") + 
  geom_smooth(method="glm", method.args=list(family=binomial(link="logit")), 
              se=FALSE, color="deepskyblue4") +
  geom_jitter(width = 0.1, height = 0.1, alpha = 0.3, shape = 21, color="red") +
  theme_bw() + labs(y="P(inlf = 1)")

p8 <- cps_data %>% ggplot(aes(x=black, y=employed)) + geom_point(shape=21, color="red") + 
  geom_smooth(method="glm", method.args=list(family=binomial(link="logit")), 
              se=FALSE, color="deepskyblue4") +
  geom_jitter(width = 0.1, height = 0.1, alpha = 0.3, shape = 21, color="red") +
  theme_bw() + labs(y="P(inlf = 1)")



(p5 + p6) / (p7 + p8)



## Goodness-of-fit (pseudo-R2):

logit_cps_0 <- glm(employed ~ 1, 
                   data = cps_data,
                   family = binomial(link = "logit"))   ## a model with only an intercept term.



logit_cps_pseudo <- 1 - as.vector(logLik(logit_cps)/logLik(logit_cps_0))  ## Interpretation?

logLik(logit_cps)
logLik(logit_cps_0)

1- (-4336.745/-4662.488)


#==================================================================================================#



##=== The Probit Model:


## The binomial probit model assumes the regression model as a random variable following a 
## variant of the Standard Normal distribution.


pdf_normal <- ggdistribution(dnorm, seq(-3.5, 3.5, 0.1), mean = 0, sd = 1) + 
  labs(title = "Standard Normal Distribution - Probability Density Function (PDF)") + theme_bw()

cdf_normal <- ggdistribution(pnorm, seq(-3.5, 3.5, 0.1), mean = 0, sd = 1) + 
  labs(title = "Standard Normal Distribution - Cumulative Density Function (CDF)") + theme_bw()



pdf_normal / cdf_normal


## Estimating a probit model:


probit_cps <- glm(employed ~ black + female + higher_ed + exper + I(exper^2), 
                 data = cps_data,
                 family = binomial(link = "probit"))          ## note that we use the "glm" function.


probit_cps %>% tidy()    ## interpretation?


## Estimating Average Marginal Effects (AME):


# First, manual computation:


mean(dnorm(predict(probit_cps, type='link'))) * coef(probit_cps)   ## compare with the formula from 
                                                                   ## the lecture notes.

# Second, using the "margins" package:


probit_cps %>% margins() %>% summary() 


## Plotting marginal effects:


p9 <- cps_data %>% ggplot(aes(x=exper, y=employed)) + geom_point(shape=21, color="red") + 
  geom_smooth(method="glm", method.args=list(family=binomial(link="probit")), 
              se=FALSE, color="deepskyblue4", formula="y ~ x + I(x^2)") +
  theme_bw() + labs(y="P(inlf = 1)")

p10 <- cps_data %>% ggplot(aes(x=higher_ed, y=employed)) + geom_point(shape=21, color="red") + 
  geom_smooth(method="glm", method.args=list(family=binomial(link="probit")), 
              se=FALSE, color="deepskyblue4") +
  geom_jitter(width = 0.1, height = 0.1, alpha = 0.3, shape = 21, color="red") +
  theme_bw() + labs(y="P(inlf = 1)")

p11 <- cps_data %>% ggplot(aes(x=female, y=employed)) + geom_point(shape=21, color="red") + 
  geom_smooth(method="glm", method.args=list(family=binomial(link="probit")), 
              se=FALSE, color="deepskyblue4") +
  geom_jitter(width = 0.1, height = 0.1, alpha = 0.3, shape = 21, color="red") +
  theme_bw() + labs(y="P(inlf = 1)")

p12 <- cps_data %>% ggplot(aes(x=black, y=employed)) + geom_point(shape=21, color="red") + 
  geom_smooth(method="glm", method.args=list(family=binomial(link="probit")), 
              se=FALSE, color="deepskyblue4") +
  geom_jitter(width = 0.1, height = 0.1, alpha = 0.3, shape = 21, color="red") +
  theme_bw() + labs(y="P(inlf = 1)")



(p9 + p10) / (p11 + p12)



## Goodness-of-fit (pseudo-R2):



probit_cps_0 <- glm(employed ~ 1, 
                   data = cps_data,
                   family = binomial(link = "probit"))



probit_cps_pseudo <- 1 - as.vector(logLik(probit_cps)/logLik(probit_cps_0))  ## Interpretation?



## Coefficient comparison:

lpm_cps %>% tidy() %>% select(term, estimate)

logit_cps %>% margins() %>% summary()

probit_cps %>% margins() %>% summary()



#==================================================================================================#



##=== A second example: determinants of loan application approvals.


data("loanapp")

loanapp <- loanapp %>% as_tibble()



## Linear Probability Model:


loan_lpm <- lm(approve ~ white + hrat + obrat, data = loanapp)

loan_lpm %>% summary()


loanapp %>% ggplot(aes(x=obrat, y=approve)) + geom_point(shape=21) + 
  geom_smooth(method="lm", se=FALSE) + theme_bw()




## Logit model:


loan_logit <- glm(approve ~ white + hrat + obrat, data = loanapp,
                  family = binomial(link = "logit"))

loan_logit %>% tidy()


# AME:


loan_logit %>% margins() %>% summary()



## Probit model:


loan_probit <- glm(approve ~ white + hrat + obrat, data = loanapp,
                   family = binomial(link = "probit"))

loan_probit %>% tidy()



# AME:


loan_probit %>% margins() %>% summary()
