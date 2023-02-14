library(tidyverse)
library(showtext)
library(patchwork)
library(scales)



font_add_google("PT Sans Narrow", "jost")

showtext_auto()


my_theme <- theme_gray() +
  theme(text =  element_text(family = "jost"),
        plot.title = element_text(family = "jost"))




###


min2 <- -3.5
max2 <- 3.5

c_values <- c(-1.645, 1.645)


c_value <- 1.645

labss <- as.character(c_values)

lab1 <- as.character(c_value)


ggplot(data.frame(x = c(min2, max2)), aes(x = x)) +
  stat_function(fun = dnorm, args = list(mean = 0, sd = 1), geom = "area", fill = "#8b9dc3", alpha = 0.35) +
  stat_function(fun = dnorm, args = list(mean = 0, sd = 1), size = 1.2, alpha = 0.8) +
  geom_area(stat = "function", fun = dnorm, args = list(mean = 0, sd = 1), 
            fill = "#b70673", xlim = c(1.645, 3.5), alpha = 0.4) +
  geom_area(stat = "function", fun = dnorm, args = list(mean = 0, sd = 1), 
            fill = "#b70673", xlim = c(-1.645, -3.5), alpha = 0.4) +
  labs(x = "t", y = "") +
  scale_x_continuous(breaks = c_values, labels = labss) +
  my_theme


ggplot(data.frame(x = c(min2, max2)), aes(x = x)) +
  stat_function(fun = dnorm, args = list(mean = 0, sd = 1), geom = "area", fill = "#8b9dc3", alpha = 0.35) +
  stat_function(fun = dnorm, args = list(mean = 0, sd = 1), size = 1.2, alpha = 0.8) +
  geom_area(stat = "function", fun = dnorm, args = list(mean = 0, sd = 1), 
            fill = "#b70673", xlim = c(1.645, 3.5), alpha = 0.4) +
  labs(x = "t", y = "") +
  scale_x_continuous(breaks = c_value, labels = lab1) +
  my_theme

