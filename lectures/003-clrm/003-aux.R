library(tidyverse)
library(showtext)
library(patchwork)
library(colorblindr)

font_add_google("PT Sans Narrow", "jost")

showtext_auto()


my_theme <- theme_gray() +
  theme(text =  element_text(family = "jost"),
        plot.title = element_text(family = "jost"))


set.seed(1000)

u <- tibble(u = rnorm(10000, 0, 1))

u %>% 
  ggplot(aes(x = u)) +
  geom_density(fill = "#b00b69", color='#b00b69',  alpha = 0.1, size = 0.7) +
  labs(x = "x", y = "", title = "The residual's distribution") +
  my_theme






set.seed(123)

x1 <- rnorm(1000, 1, 5)
x2 <- rnorm(1000, 1, 10)

df2 <- tibble(
  x1 = x1,
  x2 = x2
)

df2 %>% 
  ggplot(aes(x = x1)) +
  geom_density(alpha = 0.2) +
  geom_density(aes(x=x2), alpha=0.5) +
  labs(x = "", y = "") +
  scale_fill_OkabeIto() +
  my_theme


###

set.seed(123)

error <- rep(0,100)  

for(i in 1:100){
  error[i] <- rnorm(1, 0, i/10)} 


x <- seq(1, 100, length=100)  

y <- 2 + 0.8*x + error   


df1 <- tibble(
  x = x,
  y = y)

df1 %>% 
  ggplot(aes(x=x, y=y)) + geom_point() + labs(x='x', y='y') +
  geom_smooth(method = 'lm', se=FALSE) +
  my_theme



###


set.seed(123)

x1 <- rnorm(1000, 1, 5)
x2 <- rnorm(1000, 1, 10)

df2 <- tibble(
  x1 = x1,
  x2 = x2
)

df2 %>% 
  ggplot(aes(x = x1)) +
  geom_density(fill = "#4dc1bf", colour='#4dc1bf',  alpha = 0.2) +
  geom_density(aes(x=x2), fill = "#ffc0cb", alpha=0.5, color = "#ffc0cb") +
  labs(x = expression(paste(beta^1, ", ", beta^2)), title = 'Distribution of two slopes') +
  my_theme



###


set.seed(123)

x3 <- rnorm(1000, 0, 3)
x4 <- rnorm(1000, 0, 7)
x5 <- rnorm(1000, 10, 5)


df3 <- tibble(
  x3 = x3,
  x4 = x4,
  x5 = x5
)

df3 %>% 
  ggplot(aes(x = x3)) +
  geom_density(fill = "#4dc1bf", colour='#4dc1bf',  alpha = 0.2) +
  geom_density(aes(x=x4), fill = "#ffc0cb", alpha=0.5, color = "#ffc0cb") +
  geom_density(aes(x=x5), fill = "#416600", alpha=0.2, color = "#416600") +
  labs(x = "", y = "") +
  my_theme
