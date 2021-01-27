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
    
    output$all_births_plot <- renderPlot({
      total_births_by_year_graph 
    })

})
