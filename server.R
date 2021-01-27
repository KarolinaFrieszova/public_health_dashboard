library(shiny)
library(tidyverse)
library(here)
library(sp)
library(raster) 
source(here("scripts/graph_input_deprivation.R"))
source(here("scripts/geographic_code.R"))
source(here("scripts/analysis.R"))

shinyServer(function(input, output) {

    output$deprivation_plot <- renderPlot({
        make_deprivation_graph(input$council_select)
    })
    
    output$map_plot <- renderLeaflet({
      map_legend
    })
    
    output$health_board_graph <- renderPlot({
      birth_weight_hb_graph
    })
    
    output$all_births_plot <- renderPlot({
      total_births_by_year_graph 
    })
    
    output$percentage_by_years <- renderPlot({
      birth_weight_year_graph
    })
    
    output$percentage_ur_graph <- renderPlot({
      birth_weight_ur_graph
    })
    
    output$correlation_graph <- renderPlot({
      correlation_graph
    })

})
