library(tidyverse)
library(pwt9)

data("pwt9.1")


pwt <- pwt9.1 %>% 
  as_tibble()


pwt_select <- pwt %>% 
  filter(year == 2010) %>% 
  filter(pop < 1000) %>% 
  drop_na(emp, pop, ck, ccon)

pwt_select %>% 
  write_csv("pwt_select.csv")


pwt_select %>% 
  ggplot(aes(x=pop, y=emp)) +
  geom_point(size = 2, 
             colour = purple, 
             fill = purple, shape=24) +
  labs(y="Employed persons (millions)", 
       x="Population (millions)") +
  easy_x_axis_title_size(13) +
  easy_y_axis_title_size(13)



pwt_select %>% 
  summarize(correlation_pop_emp = cor(pop, emp),
                         correlation_emp_ccon = cor(ccon, ck))


pwt_select %>% 
  summarize(correlation_emp_ccon = cor(log(ccon), ck))
