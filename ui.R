library(shiny)
library(shinythemes)
library(tidyverse)
library(here)
library(sp)
library(raster) 
library(leaflet)
council_list <- read_rds("clean_data/council_list.rds")

shinyUI(fluidPage(
    
    theme = shinytheme("slate"),
    
    titlePanel("Low Weight Births in Scottish Hospitals"),
    
    tabsetPanel(
        
#        tabPanel("Introduction",
                 
#        ),
        tabPanel("Over time",
                 fluidRow(
                     column(12, align="center",
                         h3("Singleton births in Scotland from 2012 to 2019"),
                         br()
                     )
                     
                 ),
                 fluidRow(column(6,
                                 plotOutput("all_births_plot")
                     
                          ),
                          column(6,
                                 plotOutput("percentage_by_years")
                          )
                          
                 )
                 
        ),
        tabPanel("By Deprivation",
                 fluidRow(
                     column(12,
                            selectInput("council_select",
                                        "Select council area:",
                                        choices = council_list
                            )
                     )
                 ),
                 
                 fluidRow(
                     column(12,
                            mainPanel(
                                plotOutput("deprivation_plot")
                            )
                         
                     )
                 )
            
        ),
        tabPanel("By Council Area",
                 fluidRow(
                     leafletOutput(outputId = "map_plot")
                        
                 )
        ),
            
        tabPanel("Urban Rural",
                 fluidRow(
                     column(12,
                            plotOutput("percentage_ur_graph")
                     )
                 )
            
        )#,
#        tabPanel("About",
                 
#        )
    )
))


