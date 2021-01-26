#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(here)
source(here("scripts/graph_input_deprivation.R"))

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$deprivation_plot <- renderPlot({

        deprivation_summary %>%
            filter(council_area_name == input$council_select) %>%
            dplyr::select(council_area_name,
                          date_code,
                          simd_code,
                          percent_low_birth_weight) %>% 
            ggplot() +
            aes(x = date_code, y = percent_low_birth_weight, group  = simd_code, colour = simd_code) +
            geom_line(size = 2) +
            theme_minimal() +
            theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
            scale_fill_brewer(palette = "Dark2") +
            labs(
                title = "SIMD1 = most deprived, SIMD5 = least deprived",
                x = "\n 3 year aggregate",
                y = "Percent of births low weight \n",
                colour = ""
            ) 

    })

})
