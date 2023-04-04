library(tidyverse)
library(wooldridge)
library(skedastic)
library(estimatr)
library(gt)
library(gtExtras)


data("hprice2")

hprice2 <- as_tibble(hprice2)

price_model <- lm(lprice ~ lnox + log(dist) + rooms + stratio, data = hprice2)

lm_robust(lprice ~ lnox + log(dist) + rooms + stratio, data = hprice2, 
          se_type="HC1") %>% 
  tidy() %>% 
  select(term, estimate, std.error, statistic, p.value) %>% 
  gt() %>% 
  gt_theme_pff() %>% 
  fmt_number(columns = c(estimate, std.error, statistic, p.value), decimals = 7) %>%
  cols_label(term = "Variable",
             estimate = "Coefficient",
             std.error = "SE",
             statistic = "t-statistic",
             p.value = "p-value")



lm_robust(lprice ~ lnox + log(dist) + rooms + stratio, data = hprice2, 
          se_type="HC2") %>% 
  tidy() %>% 
  select(term, estimate, std.error, statistic, p.value)
