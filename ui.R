library(shiny)
library(shinythemes)
library(tidyverse)
library(here)
library(sp)
library(raster) 
library(leaflet)

council_list <- read_rds("clean_data/council_list.rds")

shinyUI(fluidPage(
    
    theme = shinytheme("superhero"),
    
    titlePanel("Low Weight Births in Scottish Hospitals"),
    
    tabsetPanel(
        
        tabPanel("Health Indicators",
                 fluidRow(
                     column(12, align="center",
                            h4("General health indicators reported by females", 
                               style = "color:#feb24c")
                     ),
                     br()
                 ),
                 fluidRow(
                     column(6,
                         plotOutput("f_smoking_graph")
                     ),
                     column(6,
                         plotOutput("f_weight")
                     )
                 )
                 
        ),
        tabPanel("Over time",
                 fluidRow(
                     column(12, align="center",
                         h4("Full Term Live Single Births in Scotland from 2012 to 2019")
                     )
                 ),
                 fluidRow(column(6,
                                 h4("Has the number of births changed over time?", 
                                    style = "color:#feb24c"),
                                 plotOutput("all_births_plot")
                     
                          ),
                          column(6,
                                 h4("Does percentage of low weight births differ over time?",
                                    style = "color:#feb24c"),
                                 plotOutput("percentage_by_years")
                          )
                          
                 )
                 
        ),
        tabPanel("By Deprivation",
                 fluidRow(
                     column(3,
                            selectInput("council_select",
                                        tags$i("Select council area:"),
                                        choices = council_list
                            ),
                            br()
                     ),
                     column(9,
                            br(),
                            h4("Area deprivation and low birth weight: is there evidence of an “area effect”?",
                               style = "color:#feb24c")
                     )
                 ),
                 
                 fluidRow(
                     column(7,
                            plotOutput("deprivation_plot")
                         
                     ),
                     column(5,
                            plotOutput("correlation_graph")
                     )
                 )
            
        ),
        tabPanel("By Area",
                 fluidRow(
                     column(12, align="center",
                            h4("Does the percentage of low weight births differ 
                               across areas?", style = "color:#feb24c")
                     )
                     
                 ),
                 fluidRow(
                     column(7,
                            h4("By Council Area"),
                            leafletOutput(outputId = "map_plot")
                            
                     ),
                     column(5,
                            h4("By Health Board"),
                            plotOutput("health_board_graph")
                         
                     )
                 )
        ),
            
        tabPanel("Urban Rural",
                 fluidRow(
                     column(12, align="center",
                            h4("Is urban or rural location important?", style = "color:#feb24c"),
                            br()
                     )
                     
                 ),
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


