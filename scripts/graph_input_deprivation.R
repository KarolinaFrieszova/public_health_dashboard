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

write_rds(council_list, "clean_data/council_list.rds")

make_deprivation_graph <- function(council_select){
  deprivation_summary %>%
    filter(council_area_name == council_select) %>%
    dplyr::select(council_area_name,
                  date_code,
                  simd_code,
                  percent_low_birth_weight) %>% 
    ggplot() +
    aes(x = date_code, y = percent_low_birth_weight, group  = simd_code, colour = simd_code) +
    geom_line(size = 3) +
    theme_linedraw()+
    labs(
      title = "% of Low Weight Births by Scottish Index of Multiple Deprivation\n",
      x = "\n3 year aggregate",
      y = "Low weight births(%)\n",
      caption = "SIMD1 = most deprived, SIMD5 = least deprived",
      colour = "SIMD code")+
    theme(plot.title = element_text(size = 20, hjust = 0.5, face="bold"),
          axis.text.x = element_text(angle = 15, vjust = 0.6, size = 12),
          axis.title.x = element_text(size = 15, hjust = 0.5),
          axis.text.y = element_text(vjust = 0.6, size = 12),
          axis.title.y = element_text(size = 15, hjust = 0.5),
          plot.caption = element_text(size = 12),
          legend.title = element_text(size = 15),
          legend.text = element_text(size = 12))+
    scale_color_manual(values = c("#d95f02","#1b9e77", "#7570b3", "#1c9099", "#c51b8a"))
                                
}



