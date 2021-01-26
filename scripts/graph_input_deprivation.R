library(tidyverse)
library(here)


# get data
birth_weight_summary <- 
  read_csv(here("clean_data/birth_weight_summary.csv"))

# council summary by SIMD code
council_summary <- birth_weight_summary %>% 
  group_by(council_area_name, simd_code, date_code) %>%
  summarise(all_births = sum(all_births),
            low_weight_births = sum(low_weight_births),
            percent_low_birth_weight = round((100*(sum(low_weight_births)/sum(all_births))),2)) %>% 
  arrange(council_area_name, date_code) 

# scotland summary by SIMD code
all_scotland_summary <- birth_weight_summary %>% 
  mutate(council_area_name = "1 - All Scotland") %>% 
  group_by(council_area_name, simd_code, date_code) %>%
  summarise(all_births = sum(all_births),
            low_weight_births = sum(low_weight_births),
            percent_low_birth_weight = round((100*(sum(low_weight_births)/sum(all_births))),2)) %>% 
  arrange(council_area_name, date_code) 

# Combine the council and Scotland summaries into one table
deprivation_summary <-
  bind_rows(all_scotland_summary, council_summary) %>% 
  mutate(simd_code = paste("SIMD", simd_code, " ")) 

# remove the separate council and scotland tables
rm(all_scotland_summary, council_summary)


# create lists for select inputs
council_list <- unique(sort(deprivation_summary$council_area_name))