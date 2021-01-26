library(tidyverse)

birth_weight <- read_csv("clean_data/birth_weight_summary.csv") 

# by council
birth_weight_council <- birth_weight %>% 
  group_by(date_code, council_area_name) %>% 
  summarise(percent_lbw_by_council = 
              round((100*(sum(low_weight_births) / sum(all_births))), 2))

birth_weight_council %>% 
  filter(date_code == "2012-2014") %>% 
  ggplot()+
  aes(x = reorder(council_area_name, percent_lbw_by_council), y = percent_lbw_by_council)+
  geom_col()+
  coord_flip()

birth_weight_council %>% 
  filter(date_code == "2013-2015") %>% 
  ggplot()+
  aes(x = reorder(council_area_name, percent_lbw_by_council), y = percent_lbw_by_council)+
  geom_col()+
  coord_flip()

# by healthboarda and year

birth_weight_hb <- birth_weight %>% 
  group_by(date_code, health_board_name) %>% 
  summarise(percent_lbw_by_hb = 
              round((100*(sum(low_weight_births) / sum(all_births))), 2))

birth_weight_hb %>% 
  #filter(date_code == "2012-2014") %>% 
  ggplot()+
  aes(x = health_board_name, y = percent_lbw_by_hb)+
  geom_col()+
  facet_wrap(~date_code)+
  coord_flip()

# the gap between the percentage of low weight births in rural areas increased over the period
birth_weight_ur <- birth_weight %>% 
  group_by(date_code, urban_rural_2_name) %>% 
  summarise(percent_lbw_by_ur = 
              round((100*(sum(low_weight_births) / sum(all_births))), 2))

birth_weight_ur %>% 
  #filter(date_code == "2012-2014") %>% 
  ggplot()+
  aes(x = urban_rural_2_name, y = percent_lbw_by_ur)+
  geom_col()+
  facet_wrap(~date_code)+
  coord_flip()

# the percentage of low weight birthshas not significantly cahanged over the years in Scotland
birth_weight_year <- birth_weight %>% 
  group_by(date_code) %>% 
  summarise(percent_lbw_by_year = 
              round((100*(sum(low_weight_births) / sum(all_births))), 2))

birth_weight_year %>% 
  #filter(date_code == "2012-2014") %>% 
  ggplot()+
  aes(x = date_code, y = percent_lbw_by_year)+
  geom_col()

# overall less babies born in Scotland
birth_weight_year <- birth_weight %>% 
  group_by(date_code) %>% 
  summarise(sum_lbw_by_year = sum(all_births))

birth_weight_year %>% 
  #filter(date_code == "2012-2014") %>% 
  ggplot()+
  aes(x = date_code, y = sum_lbw_by_year)+
  geom_col()


