library(tidyverse)
library(fpp3)

library(orcutt)
library(lubridate)
library(tsibble)
library(ggfortify)
library(dynlm)
library(lmtest)
library(patchwork)

ausmacro <- read_csv("phillips5_aus.csv")


ausmacro <- ausmacro %>% 
  mutate(period = as.Date(dateid01, format = "%m/%d/%Y"))

model1 <- lm(inf ~ du, data = ausmacro)



res <- model1 %>% 
  resid()


ausmacro <- ausmacro %>% 
  add_column(res)


ausmacro %>% 
  ggplot(aes(x = period, y = res)) +
  geom_line() +
  scale_x_date(date_breaks = "4 years", date_labels = "%Y") +
  labs(y = expression(u[t]),
       x = "",
       title = expression(u[t]))


ausmacro %>% 
  mutate(qtr = yearquarter(period)) %>% 
  as_tsibble(index = qtr) %>% 
  ACF(res) %>% 
  autoplot() +
  labs(x = "Lag (quarters)",
       y = expression(rho))




######


okun <- read_csv('okun.csv')


okun <- okun %>% as_tibble()
okun <- okun %>% mutate(date = seq(as.Date("1978/4/1"), as.Date("2016/4/1"), by="quarter"))

okun_data <- okun %>% as_tsibble(index=date)
okun_data <- okun_data %>% select(date, g, u)
okun_data <- okun_data %>% mutate(du = u - lag(u))


okun_model <- lm(du ~ g, data = okun_data)

okun_resid <- okun_model %>% 
  resid


okun_data <- okun_data %>% 
  mutate(okun_resid = c(NA, okun_resid))

okun_model %>% 
  dwtest()



co <- cochrane.orcutt(okun_model)

co_resid <- co$residuals

okun_data <- okun_data %>% 
  mutate(co_resid = c(NA, co_resid))


okun_data %>% 
  ggplot(aes(x = date, y = co_resid)) +
  geom_line()
