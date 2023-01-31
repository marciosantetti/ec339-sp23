library(tidyverse)
library(gapminder)
library(hrbrthemes)
library(ggeasy)


theme_set(theme_ipsum_rc())

gapminder %>% 
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point(alpha = 0.5) +
  scale_x_continuous("GDP per capita", label = scales::comma) +
  labs(y = "Life expectancy", title="GDP per capita vs. Life expectancy") +
  easy_x_axis_title_size(13) +
  easy_y_axis_title_size(13)



gapminder %>% 
  ggplot(aes(x = gdpPercap, y = log(lifeExp))) +
  geom_point(alpha = 0.5) +
  scale_x_continuous("GDP per capita", label = scales::comma) +
  labs(y = "Life expectancy (log)", title="GDP per capita vs. Life expectancy") +
  easy_x_axis_title_size(13) +
  easy_y_axis_title_size(13)


gapminder %>% 
  ggplot(aes(x = log(gdpPercap), y = log(lifeExp))) +
  geom_point(alpha = 0.5) +
  scale_x_continuous("GDP per capita (log)", label = scales::comma) +
  labs(y = "Life expectancy (log)", title="GDP per capita vs. Life expectancy") +
  easy_x_axis_title_size(13) +
  easy_y_axis_title_size(13)


gapminder %>% 
  ggplot(aes(x = log(gdpPercap), y = lifeExp)) +
  geom_point(alpha = 0.5) +
  scale_x_continuous("GDP per capita (log)", label = scales::comma) +
  labs(y = "Life expectancy (log)", title="GDP per capita vs. Life expectancy") +
  easy_x_axis_title_size(13) +
  easy_y_axis_title_size(13)



