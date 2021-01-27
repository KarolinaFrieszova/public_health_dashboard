library(tidyverse)
library(ggpubr)

birth_weight <- read_csv("clean_data/birth_weight_summary.csv") 


# 1. calculate the percentage of low weight births by health board
birth_weight_hb <- birth_weight %>% 
  group_by(health_board_name) %>% 
  summarise(percent_lbw_by_hb = 
              round((100*(sum(low_weight_births) / sum(all_births))), 2))

# plot data to the graph
birth_weight_hb_graph <- birth_weight_hb %>% 
  ggplot()+
  aes(x = reorder(health_board_name, percent_lbw_by_hb), y = percent_lbw_by_hb)+
  geom_col(col = "black", fill = "#1b9e77")+
  theme_linedraw()+
  coord_flip()+
  labs(x = "Health board",
       y = "\nLow birth weight (%)")+
       #title = "% of low birth weight by Health Board\n")+
  theme(plot.title = element_text(size = 20, hjust = 0.5, face="bold"),
        axis.text.x = element_text(vjust = 0.6, size = 12),
        axis.title.x = element_text(size = 15, hjust = 0.5),
        axis.text.y = element_text(vjust = 0.6, size = 12),
        axis.title.y = element_text(size = 15, hjust = 0.5))

# 2. calculate the percentage of low weight births by Urban Rural Classification over our time period
birth_weight_ur <- birth_weight %>% 
  group_by(date_code, urban_rural_2_name) %>% 
  summarise(percent_lbw_by_ur = 
              round((100*(sum(low_weight_births) / sum(all_births))), 2))

# plot data to the graph
birth_weight_ur_graph <- birth_weight_ur %>% 
  ggplot()+
  aes(x = urban_rural_2_name, y = percent_lbw_by_ur, fill = urban_rural_2_name) +
  geom_col(col = "black")+
  facet_grid(~date_code)+
  #coord_flip()+
  theme_linedraw()+
  labs(x = "\nClassification",
       y = "Low birth weight (%)\n",
       title = "% of Low birth weight by Rural Urban Classification\n")+
  theme(plot.title = element_text(size = 20, hjust = 0.5, face="bold"),
        axis.text.x = element_text(angle = 15, vjust = 0.6, size = 12),
        axis.title.x = element_text(size = 15, hjust = 0.5),
        axis.text.y = element_text(vjust = 0.6, size = 12),
        axis.title.y = element_text(size = 15, hjust = 0.5),
        strip.text = element_text(size = 12, hjust = 0.5))+
    scale_fill_manual(values = c("#d95f02", "#1b9e77"), guide = FALSE)
  

# 3. calculate the percentage low weight bights by 3 aggregate years
birth_weight_year <- birth_weight %>% 
  group_by(date_code) %>% 
  summarise(percent_lbw_by_year = 
              round((100*(sum(low_weight_births) / sum(all_births))), 2))

# plot data to the graph
birth_weight_year_graph <- birth_weight_year %>% 
  ggplot()+
  aes(x = date_code, y = percent_lbw_by_year, fill = date_code)+
  geom_col(col = "black", fill = "#d95f02")+
  theme_linedraw()+
  labs(x = "\n3 year aggregate",
       y = "Low birth weight (%)\n",
       title = "% of low birth weight\n")+
  theme(plot.title = element_text(size = 20, hjust = 0.5, face="bold"),
        axis.text.x = element_text(angle = 15, vjust = 0.6, size = 12),
        axis.title.x = element_text(size = 15, hjust = 0.5),
        axis.text.y = element_text(vjust = 0.6, size = 12),
        axis.title.y = element_text(size = 15, hjust = 0.5))
    #scale_fill_manual(values = c("#800020", "#800020", "#800020", "#800020", "#800020", "#800020"), guide = FALSE)


# 4. calculate the total number of births
total_births_by_year <- birth_weight %>% 
  group_by(date_code) %>% 
  summarise(sum_births_by_year = sum(all_births/1000))

# plot data to the graph
total_births_by_year_graph <- total_births_by_year %>% 
  ggplot()+
  aes(x = date_code, y = sum_births_by_year)+
  geom_col(col = "black", fill = "#1b9e77")+
  theme_linedraw()+
  labs(x = "\n3 year aggregate",
       y = "Births (1000 units)\n",
       title = "Total number\n")+
  theme(plot.title = element_text(size = 20, hjust = 0.5, face ="bold"),
        axis.text.x = element_text(angle = 15, vjust = 0.6, size = 12),
        axis.title.x = element_text(size = 15, hjust = 0.5),
        axis.text.y = element_text(vjust = 0.6, size = 12),
        axis.title.y = element_text(size = 15, hjust = 0.5))

# 5. correlation between SIMD and percentage of low weight births
correlation_graph <- birth_weight %>%
  group_by(simd_code) %>%
  summarise(percentage_lbw = round((100*(sum(low_weight_births) / sum(all_births))), 2)) %>%
  ggscatter(x = "simd_code", y = "percentage_lbw", 
            add = "reg.line", conf.int = TRUE, 
            cor.coef = TRUE, cor.method = "pearson",
            xlab = "\nSIMD", ylab = "Low birth weight (%)\n")+
  theme_linedraw()+
  labs(title = "Relation between low birth weight and SIMD\n")+
  theme(plot.title = element_text(size = 20, hjust = 0.5, face="bold"),
        axis.text.x = element_text(vjust = 0.6, size = 12),
        axis.title.x = element_text(size = 15, hjust = 0.5),
        axis.text.y = element_text(vjust = 0.6, size = 12),
        axis.title.y = element_text(size = 15, hjust = 0.5))


