library(tidyverse)
library(showtext)
library(patchwork)
library(skedastic)
library(lmtest)

font_add_google("PT Sans Narrow", "jost")

showtext_auto()


my_theme <- theme_gray() +
  theme(text =  element_text(family = "jost"),
        plot.title = element_text(family = "jost"))



dat <- read_csv("chicken_demand.csv")

reg1 <- lm(q ~ p + y + pb, data = dat)

reg1 %>% 
  summary()


reg1 %>% 
  breusch_pagan()

reg1 %>% 
  bgtest()
  

resid1 <- reg1 %>% 
  resid()

dat <- dat %>% 
  add_column(resid1)

dat %>% 
  ggplot(aes(y = resid1, x = year)) +
  geom_point() +
  geom_line()


reg3 <- lm(q ~ I(1/p), data = dat)


reg3 %>% 
  summary()


dat %>% 
  ggplot(aes(y = q, x = p)) +
  geom_point()


###-----


truf <- read_csv("truffles.csv")

reg2 <- lm(q ~ p + ps + di, data = truf)

reg2 %>% 
  summary()

reg2 %>% 
  breusch_pagan()


truf %>% 
  ggplot(aes(y = q, x = p)) +
  geom_point()



###----


fish <- read_csv("fultonfish.csv")

fish 
