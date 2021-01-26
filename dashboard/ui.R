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
      
        # Show a plot of the generated distribution
        mainPanel(
          tabsetPanel(type = "tabs",
                      tabPanel(tags$i("By Deprivation")),
                      tabPanel(tags$i("By Population Density")),
                      tabPanel(tags$i("By Geographic")),
                      tabPanel(tags$i("By Hair Colour")),
                      tabPanel(tags$i("By Religion"))
        )
    )
)
)
)


