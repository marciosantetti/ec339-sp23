library(wooldridge)
library(tidyverse)
library(margins)

data("wage1")


wage <- wage1 %>% 
  as_tibble()


wage <- wage %>% 
  mutate(highwage = case_when(wage > 6 ~ 1,
                              TRUE ~ 0))


ols <- lm(highwage ~ educ + exper + tenure + female + nonwhite, data = wage)

summary(ols)


logit <- glm(highwage ~ educ + exper + tenure + female + nonwhite, 
             data = wage,
             family = binomial(link = "logit"))

summary(logit)


logit %>% 
  margins() %>% 
  summary() 


dlogis(predict(logit, type='link')) %>% 
  as_tibble() %>% 
  ggplot(aes(x = value)) +
  geom_density()


mean(dlogis(predict(logit, type='link'))) * coef(logit)


logit_0 <- glm(highwage ~ 1, 
                   data = wage,
                   family = binomial(link = "logit"))   ## a model with only an intercept term.



logit_pseudo <- 1 - as.vector(logLik(logit)/logLik(logit_0))  ## Interpretation?

logLik(logit)
logLik(logit_0)

1 - (-259.1359/-342.3171)
