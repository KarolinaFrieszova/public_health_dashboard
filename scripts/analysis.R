library(tidyverse)
library(ggpubr)
library(janitor)

birth_weight <- read_csv("clean_data/birth_weight_summary.csv") 

# source: https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fscottish-health-survey-scotland-level-data
# Scottish Health Survey-Scotland level data
health_scotland <- read_csv("raw_data/health_scotland.csv") %>% 
  clean_names()

# create a custom ggplot theme for all plots
graph_theme <- function(){
  theme(
    plot.title = element_text(size = 20, hjust = 0.5, face="bold"),
    axis.text.x = element_text(angle = 15, vjust = 0.6, size = 12),
    axis.title.x = element_text(size = 15, hjust = 0.5),
    axis.text.y = element_text(vjust = 0.6, size = 12),
    axis.title.y = element_text(size = 15, hjust = 0.5),
    legend.title = element_text(size = 15),
    legend.text = element_text(size = 12)
  )
}

# 1. calculate the percentage of low birth weight by health board
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
       y = "\nLow weight births (%)")+
  graph_theme()+
  theme(axis.text.x = element_text(angle = 0))


# 2. calculate the percentage of low birth weight by Urban Rural Classification over our time period
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
  theme_linedraw()+
  labs(x = "\nClassification",
       y = "Low weight births (%)\n",
       title = "% of Low weight births by Rural Urban Classification\n")+
  graph_theme()+
  scale_fill_manual(values = c("#d95f02", "#1b9e77"), guide = FALSE)
  

# 3. calculate the percentage low birth weight by 3 aggregate years
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
       y = "Low weight births (%)\n",
       title = "% of low weight births\n")+
  graph_theme()


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
  graph_theme()

# 5. correlation between SIMD and percentage of low weight births
correlation_graph <- birth_weight %>%
  group_by(simd_code) %>%
  summarise(percentage_lbw = round((100*(sum(low_weight_births) / sum(all_births))), 2)) %>%
  ggscatter(x = "simd_code", y = "percentage_lbw", 
            add = "reg.line", conf.int = TRUE, 
            cor.coef = TRUE, cor.method = "pearson",
            xlab = "\nSIMD", ylab = "Low weight births (%)\n",
            color = "#1c9099")+
  theme_linedraw()+
  labs(title = "Relation between low birth weight and SIMD\n")+
  graph_theme()

# 6. general health dataset - looking at percentage of female smoking

female_smoking_graph <- health_scotland %>% 
  dplyr::select(-c(units, feature_code)) %>% 
  filter(scottish_health_survey_indicator %in% c("Smoking status: Current smoker",
                                                 "Smoking status: Never smoked/Used to smoke occasionally",
                                                 "Smoking status: Used to smoke regularly")) %>% 
  mutate(scottish_health_survey_indicator = 
           recode(scottish_health_survey_indicator,
                  "Smoking status: Current smoker" = "Current smoker",
                  "Smoking status: Never smoked/Used to smoke occasionally" = "Never or occasionally smoked",
                  "Smoking status: Used to smoke regularly" = "Used to smoke regularly")) %>% 
  filter(measurement == "Percent",
         sex == "Female") %>% 
  ggplot()+
  aes(x = date_code, y = value, group = scottish_health_survey_indicator, 
      colour = scottish_health_survey_indicator)+
  geom_line(size = 3)+
  scale_x_continuous(breaks = c(2009, 2011, 2013, 2015, 2017, 2019))+
  theme_linedraw()+
  labs(
    title = "% of adult females smoking cigarettes\n",
    x = "\nyear",
    y = "(%)\n",
    colour = "Survey indicator")+
  graph_theme()+
  scale_color_manual(values = c("#7570b3", "#1c9099", "#c51b8a"))


# 7. general health dataset - looking at percentage of overweight and obese data by female
female_weight <- health_scotland %>% 
  dplyr::select(-c(units, feature_code)) %>% 
  filter(scottish_health_survey_indicator %in% c("Obesity: Obese",
                                                 "Overweight: Overweight (including obese)")) %>% 
  mutate(scottish_health_survey_indicator = 
           recode(scottish_health_survey_indicator,
                  "Obesity: Obese" = "Obese",
                  "Overweight: Overweight (including obese)" = "Overweight (including obese)")) %>%
  filter(measurement == "Percent",
         sex == "Female") %>% 
  ggplot()+
  aes(x = date_code, y = value, group = scottish_health_survey_indicator, 
      colour = scottish_health_survey_indicator)+
  geom_line(size = 3)+
  scale_x_continuous(breaks = c(2009, 2011, 2013, 2015, 2017, 2019))+
  theme_linedraw()+
  labs(
    title = "% of female reporting Obesity and Overweight\n",
    x = "\nyear",
    y = "(%)\n",
    colour = "Survey indicator")+
  graph_theme()+
  scale_color_manual(values = c("#d95f02","#1b9e77"))


