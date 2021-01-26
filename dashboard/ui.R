#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)


shinyUI(fluidPage(theme = shinytheme("slate"),
                   
                   
                   

    # Application title
    titlePanel(tags$h1("Scotland's Low Birth Weights")),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
      sidebarPanel(
        
       
        "59,000 Births",
        br(),
        br(),
        "2019",
        br(),
        br(),
        "5.2% Low Birth Weight"
      ),
      
        
        mainPanel(
          tabsetPanel(type = "tabs",
                      tabPanel(tags$i("By Deprivation"),
                               # create lists for select inputs
                               
                               ui <- fluidPage(
                                 titlePanel("Percentage of all births with low birth weight"),
                                 titlePanel(tags$h4("By deprivation code")),
                                 fluidRow(
                                   #Select council area 
                                   column(3, 
                                          selectInput("council_select",
                                                      tags$h5("Select Council Area"),
                                                      choices = council_list
                                          )
                                   ), #close 1st column
                                   # Graph
                                   fluidRow(
                                     column(12,
                                            plotOutput("deprivation_plot") 
                                     ) # close 1st column
                                   ) # close fluidrow 2    
                                 ) #close fluidpage
                                 
                               
                               ),
                   
                               tabPanel(tags$i("By Area"),
                                        # create lists for select inputs
                                        
                                        ui <- fluidPage(
                                          titlePanel("Percentage of all births within Local Authority Area"),
                                          titlePanel(tags$h4("By Local Authority")),

                                            fluidRow(
                                              column(12,
                                                     plotOutput("map") 
                                              ) # close 1st column
                                            ) # close fluidrow 2    
                                          ) #close fluidpage
                                          
                                          
                                        )
                      
                        
                      
                      
          ) 
                      
                      
        )
    )
)
)
)
)


