library(tidyverse)
library(janitor)
library(tidyr)


# get area names look-up table
# source: https://statistics.gov.scot/data/data-zone-lookup
datazone_2011 <- 
  read_csv("raw_data/datazone_2011_lookup.csv") %>% 
  clean_names()


# get SIMD code look-up table
# source: https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fscottish-index-of-multiple-deprivation
simd <- 
  read_csv("raw_data/SIMD.csv") %>% 
  clean_names()
# filter SIMD for quintile
simd <- simd %>% 
  filter(measurement == "Quintile",
         simd_domain == "SIMD")


# get birth weight data 
# source: https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Flow-birthweight
birth_weight <- 
  read_csv("raw_data/birth_weight.csv") %>% 
  clean_names()


# create feature name & SIMD code look-up table
feature_simd_lookup <- 
  inner_join(datazone_2011, simd, by = c("dz2011_code" = "feature_code")) %>%
  group_by(dz2011_code, dz2011_name, la_name, ur2_name, ur3_name, ur6_name, hb_name, country_name, value) %>% 
  summarise()
# rename columns in this table
feature_simd_lookup <- feature_simd_lookup %>% 
  rename("data_zone_code" = "dz2011_code") %>%
  rename("data_zone_name" = "dz2011_name") %>%
  rename("council_area_name" = "la_name") %>%
  rename("health_board_name" = "hb_name") %>%
  rename("urban_rural_2_name" = "ur2_name") %>%
  rename("simd_code" = "value")



# get birth weight summary
birth_weight_summary <- 
  inner_join(birth_weight, feature_simd_lookup, by = c("feature_code" = "data_zone_code")) %>% 
  filter(units == "Births",
         measurement == "Count") %>% 
  mutate(date_code_copy = date_code) %>% 
  # rename councils to match council names in from GADM dataset used geographic_code.R
  mutate(council_area_name = recode(council_area_name,
                                    "Aberdeen City" = "Aberdeen",
                                    "Na h-Eileanan Siar" = "Eilean Siar",
                                    "Perth and Kinross" = "Perthshire and Kinross",
                                    "Dundee City" = "Dundee",
                                    "Glasgow City" = "Glasgow",
                                    "City of Edinburgh" = "Edinburgh")) %>% 
  rename("data_zone_code" = "feature_code") %>%
  dplyr::select(
         health_board_name,
         council_area_name,
         urban_rural_2_name,
         date_code,
         simd_code,
         birth_weight,
         value) %>% 
  #add columns for all births and low_weight births - these can be used to calculate ratio for app:
  pivot_wider(names_from = birth_weight, values_from = value) %>% 
  rename("all_births" = "Live Singleton Births") %>% 
  rename("low_weight_births" = "Low Weight Births") %>% 
  arrange(health_board_name, date_code)

# drop the original large table:
rm(birth_weight)


# write output to csv file
write_csv(birth_weight_summary, "clean_data/birth_weight_summary.csv")

