library(tidyverse)
library(showtext)
library(patchwork)


library(wooldridge)
library(scales)

font_add_google("PT Sans Narrow", "jost")

showtext_auto()


my_theme <- theme_gray() +
  theme(text =  element_text(family = "jost"),
        plot.title = element_text(family = "jost"))



###


data("saving")


saving %>% as_tibble() %>% 
  filter(cons > 0) %>% 
  ggplot(aes(x = inc, y = cons)) +
  geom_point(col = "#4f6aa8", alpha = 0.4) +
  geom_smooth(method = "lm", se = F, col = "#4c535a", alpha = 0.5) +
  labs(x = "Income", y = "Tax Revenue") +
  scale_y_continuous(labels = comma) +
  scale_x_continuous(labels = comma) +
  my_theme



###


# set a seed to make the results reproducible

set.seed(321)

# simulate the data

X <- runif(50, min = 0, max = 10)
u <- rnorm(50, sd = 10)

# the true relation

Y <- X^2 + 2 * X + u


df <- tibble(
  x = X,
  y = Y,
  u = u
)

df %>% 
  ggplot(aes(x = x, y = y)) +
  geom_point(col = "#4f6aa8", alpha = 0.4) +
  geom_smooth(formula = "y ~ x", se= FALSE, method = "lm", col = "#4c535a", alpha = 0.5) +
  geom_smooth(formula = "y ~ x + I(x^2)", se= FALSE, method = "lm", col = "#c76693", alpha = 0.6) +
  labs(x = "x", y = "y") +
  my_theme


Y2 <- -X^2 + 5 * X + u


df <- df %>% 
  add_column(Y2)

df %>% 
  ggplot(aes(x = x, y = Y2)) +
  geom_point(col = "#4f6aa8", alpha = 0.4) +
  geom_smooth(formula = "Y2 ~ x", se= FALSE, method = "lm", col = "#4c535a", alpha = 0.5) +
  geom_smooth(formula = "Y2 ~ x + I(x^2)", se= FALSE, method = "lm", col = "#c76693", alpha = 0.6) +
  labs(x = "x", y = "y") +
  my_theme


###

# set a seed to make the results reproducible
set.seed(321)

# simulate the data
X1 <- runif(50, min = 0, max = 10)
X2 <- runif(50, min = 2, max = 15)
u1 <- rnorm(50, sd = 10)

# the true relation
Y1 <- 15*1/X1 + 2*X2 + u1

# second model:

Y2 <- -10*1/X1 + 2*X2 + u1


df2 <- tibble(
  x1 = X1,
  x2 = X2,
  y1 = Y1,
  y2 = Y2,
  u1 = u1
)

df2 %>% 
  ggplot(aes(x = x1, y = y1)) +
  geom_point(col = "#4f6aa8", alpha = 0.4) +
  geom_smooth(formula = "y ~ I(1/x)", se= FALSE, method = "lm", col = "#4c535a", alpha = 0.5) +
  geom_smooth(aes(x = x1, y = y2), formula = "y ~ x + I(1/x)", se= FALSE, method = "lm", col = "#c76693", alpha = 0.6) +
  labs(x = "x", y = "y") +
  geom_hline(yintercept = 18.1, linetype = 2) +
  my_theme




###


z <- seq(1:10)
t <- seq(1:10)
t1 <- seq(from = 2, to = 11, by = 1)

df3 <- tibble(
  z = z,
  t = t,
  t1 = t1
)

df3 %>% 
  ggplot(aes(x = t, y = z)) +
  geom_line(col = "#4f6aa8", alpha = 0.8, size = 0.8) +
  geom_line(aes(x = t1, y = z), col = "#c76693", alpha = 0.7, size = 0.8) +
  annotate("text", x = 8.3, y = 9, label = "D = 0") +
  annotate("text", x = 9.3, y = 7.5, label = "D = 1") +
  my_theme



###

df4 <- tibble(
  x = seq(1:10),
  x1 = 2 + 3*x,
  x2 = 12 + 5*x
)


df4 %>% 
  ggplot(aes(x = x, y = x1)) +
  geom_line(col = "#4f6aa8", alpha = 0.8, size = 0.8) +
  geom_line(aes(x = x, y = x2), col = "#c76693", alpha = 0.7, size = 0.8) +
  annotate("text", x = 4.5, y = 40, label = expression(D[i]~'= 1')) +
  annotate("text", x = 5, y = 20, label = expression(D[i]~'= 0')) +
  annotate("text", x = 6.9, y = 50, label = expression(beta[1]+beta[3])) +
  annotate("text", x = 7.5, y = 27, label = expression(beta[1])) +
  my_theme

