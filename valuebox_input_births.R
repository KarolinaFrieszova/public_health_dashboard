library(tidyverse)
library(here)


# get data
birth_weight_summary <- 
  read_csv(here("clean_data/birth_weight_summary.csv")) 

# create lists for select inputs
date_list <- unique(sort(birth_weight_summary$date_code))


# Scotland summary by date code
scotland_birth_summary <- birth_weight_summary %>% 
  filter(date_code == input$date_select) %>%
  group_by(country_name, date_code) %>%
  summarise(all_births = sum(all_births),
            low_weight_births = sum(low_weight_births),
            percent_low_birth_weight = round((100*(sum(low_weight_births)/sum(all_births))),2)) 




