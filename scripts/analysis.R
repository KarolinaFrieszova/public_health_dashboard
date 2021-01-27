library(tidyverse)

birth_weight <- read_csv("clean_data/birth_weight_summary.csv") 

# 1. calculate the percentage of low weight births by health board
birth_weight_hb <- birth_weight %>% 
  group_by(health_board_name) %>% 
  summarise(percent_lbw_by_hb = 
              round((100*(sum(low_weight_births) / sum(all_births))), 2))

# plot data to the graph
birth_weight_hb %>% 
  ggplot()+
  aes(x = reorder(health_board_name, percent_lbw_by_hb), y = percent_lbw_by_hb)+
  geom_col(col = "white")+
  coord_flip()+
  labs(x = "Health board",
       y = "\nLow weight births (%)",
       title = "Percentage of low weight births by Health Board\n")

# 2. calculate the percentage of low weight births by Urban Rural Classification over our time period
birth_weight_ur <- birth_weight %>% 
  group_by(date_code, urban_rural_2_name) %>% 
  summarise(percent_lbw_by_ur = 
              round((100*(sum(low_weight_births) / sum(all_births))), 2))

# plot data to the graph
birth_weight_ur_graph <- birth_weight_ur %>% 
  ggplot()+
  aes(x = urban_rural_2_name, y = percent_lbw_by_ur, fill = urban_rural_2_name) +
  geom_col(col = "white")+
  facet_wrap(~date_code)+
  coord_flip()+
  labs(x = "Classification",
       y = "\nLow weight births (%)",
       title = "Percentage of low weight births \nby Rural Urban Classification\n")+
  theme(plot.title = element_text(size = 20, hjust = 0.5),
        axis.text.x = element_text(angle = 15, vjust = 0.6, size = 12),
        axis.title.x = element_text(size = 15, hjust = 0.5),
        axis.text.y = element_text(vjust = 0.6, size = 12),
        axis.title.y = element_text(size = 15, hjust = 0.5),
        strip.text = element_text(size = 12, hjust = 0.5))+
scale_fill_manual(values = c("#800020", "darkgreen"), guide = FALSE)

# 3. calculate the percentage low weight bights by 3 aggregate years
birth_weight_year <- birth_weight %>% 
  group_by(date_code) %>% 
  summarise(percent_lbw_by_year = 
              round((100*(sum(low_weight_births) / sum(all_births))), 2))

# plot data to the graph
birth_weight_year_graph <- birth_weight_year %>% 
  ggplot()+
  aes(x = date_code, y = percent_lbw_by_year, fill = date_code)+
  geom_col(col = "white")+
  labs(x = "\n3 year aggregate",
       y = "Low weight births (%)",
       title = "Percentage of low weight births\n")+
  theme(plot.title = element_text(size = 20, hjust = 0.5),
        axis.text.x = element_text(angle = 15, vjust = 0.6, size = 12),
        axis.title.x = element_text(size = 15, hjust = 0.5),
        axis.text.y = element_text(vjust = 0.6, size = 12),
        axis.title.y = element_text(size = 15, hjust = 0.5))+
scale_fill_manual(values = c("#800020", "#800020", "#800020", "#800020", "#800020", "#800020"), guide = FALSE)


# 4. calculate the total number of births
total_births_by_year <- birth_weight %>% 
  group_by(date_code) %>% 
  summarise(sum_births_by_year = sum(all_births/1000))

# plot data to the graph
total_births_by_year_graph <- total_births_by_year %>% 
  ggplot()+
  aes(x = date_code, y = sum_births_by_year)+
  geom_col(col = "white")+
  labs(x = "\n3 year aggregate",
       y = "Births (1000 units)",
       title = "Number of singleton births\n")+
  theme(plot.title = element_text(size = 20, hjust = 0.5),
        axis.text.x = element_text(angle = 15, vjust = 0.6, size = 12),
        axis.title.x = element_text(size = 15, hjust = 0.5),
        axis.text.y = element_text(vjust = 0.6, size = 12),
        axis.title.y = element_text(size = 15, hjust = 0.5))