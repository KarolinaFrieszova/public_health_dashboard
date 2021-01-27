library(tidyverse)
library(sp)
library(raster) 
library(leaflet)

# read in data and rename to match council names in from GADM
birth_weight <- read_csv("clean_data/birth_weight_summary.csv") %>% 
  mutate(council_area_name = recode(council_area_name,
                                    "Aberdeen City" = "Aberdeen",
                                    "Na h-Eileanan Siar" = "Eilean Siar",
                                    "Perth and Kinross" = "Perthshire and Kinross",
                                    "Dundee City" = "Dundee",
                                    "Glasgow City" = "Glasgow",
                                    "City of Edinburgh" = "Edinburgh"))

# Geographic data downloaded from https://gadm.org/download_country_v3.html
# download GADM data (version 3.6) select United Kingdom Geopackage
# download uk data level 2 from GADM  
uk <- getData('GADM', country = 'GBR', level = 2)

# calculate percentage of low weight births
low_birth_percentage <- birth_weight %>%
  group_by(council_area_name) %>% 
  summarise(percent_low_birth_weight = 
              round((100*(sum(low_weight_births)/sum(all_births))),2))

sort(unique(low_birth_percentage$council_area_name))

# merge Spatial Polygons Data Frame with low birth data frame containing low weight birth percentage
scotland <- merge(uk, low_birth_percentage, by.x = "NAME_2", 
                  by.y = "council_area_name", all.x = F)

# create a continuous palette function
pal <- colorNumeric("Oranges", scotland$percent_low_birth_weight)

# plot percentage of low weight births for each council
map <- leaflet(scotland) %>% 
  addProviderTiles("CartoDB.Positron", 
                   options= providerTileOptions(opacity = 0.50)) %>% 
  addPolygons(fillColor = ~pal(scotland$percent_low_birth_weight),
              stroke = FALSE,
              weight = 2,
              opacity = 1,
              color = "white",
              dashArray = "3",
              fillOpacity = 2,
              smoothFactor = 0.2,
              highlight = highlightOptions(
                weight = 2,
                color = "#666",
                dashArray = "",
                fillOpacity = 1,
                bringToFront = TRUE),
              label = ~paste(NAME_2, percent_low_birth_weight, "%"),
              labelOptions = labelOptions(textsize = "15px",
                                          direction = "auto"))

# add a legend to the map
map_legend <- map %>%
  addLegend("bottomright", pal = pal, values = ~percent_low_birth_weight,
            title = "less than 2.5kg",
            labFormat = labelFormat(suffix = " %"),
            opacity = 1)

# view the map
map_legend
