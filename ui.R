library(shiny)
library(shinythemes)
library(tidyverse)
library(here)
library(sp)
library(raster) 
council_list <- read_rds("clean_data/council_list.rds")

shinyUI(fluidPage(
    
    theme = shinytheme("slate"),
    
    titlePanel("Low Weight Births in Scottish Hospitals"),
    
    tabsetPanel(
        
#        tabPanel("Introduction",
                 
#        ),
        tabPanel("Over time",
                 fluidRow(column(12,
                                 plotOutput("all_births_plot")
                     
                          )
                 )
                 
        ),
        tabPanel("By Deprivation",
                 sidebarLayout(
                     sidebarPanel(
                         selectInput("council_select",
                                     "Select council area:",
                                     choices = council_list
                         )
                     ),
                    
                     mainPanel(
                         plotOutput("deprivation_plot")
                     )
                 )
            
        ),
        tabPanel("By Council Area",
                 fluidRow(leafletOutput(outputId = "map_plot")
                        
                 )
        )#,
            
#        tabPanel("Findings",
            
#        ),
#        tabPanel("About",
                 
#        )
    )
))


