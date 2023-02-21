library(tidyverse)
library(ggeasy)

cps <- read_csv("cps5_small.csv")

cps %>% 
  mutate(gender = as_factor(female)) %>% 
  ggplot(aes(x = educ, y = wage)) +
  geom_point(aes(color = gender, shape = gender), size = 2.5, alpha = 0.6) +
  geom_smooth(aes(color=gender), method='lm', se=FALSE) + 
  scale_color_manual(values = c("0" = "#f15025", "1" = "#318ce7")) +
  easy_move_legend(to = "bottom") +
  labs(x='Years of schooling', 
       y='Hourly earnings', title='Hourly wages vs. years of education (by gender)',
       subtitle='Female=1, Non-female=0') +
  easy_y_axis_title_size(13) +
  easy_x_axis_title_size(13) + 
  easy_add_legend_title("Gender")
  
