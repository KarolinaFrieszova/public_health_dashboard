#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)



ui <- fluidPage(
    titlePanel("Birth Weight"),
    
    fluidRow(
        column(6,
              selectInput("Birth Weight", 
                         "Choose Area?", 
                         choices = unique(birth_filter$la_name)
            ),
                        
            column(6,
                        selectInput("Birth Weight", 
                                    "Choose Ward?", 
                                    choices = unique(birth_filter$mm_ward_name)
                        
            )
        )
        )
       
    ),
    
    actionButton("update", "Search"),
    
                 tableOutput("table_output")
                 )

fluidRow(
    
    column(6,
           
           plotOutput("histogram")
           
           ),
    
    column(6,
           
           plotOutput("scatter")
           )
)


server <- function(input, output) {
    
    birth_data <- eventReactive(input$update,{
        
        birth_filter %>%
            filter(area == input$la_name) %>%
            filter(ward == input$mm_ward_name) 
        
    
    })   
    
    output$histogram <- renderPlot({
            
    ggplot(birth_filter()) +
        aes(x = la_name) +
        geom_histogram()
                
    })
    
    
    output$scatter <- renderPlot({
        
        ggplot(birth_filter()) +
            aes(x = mm_ward_name, y = value) +
            geom_point()
        
    })
    
}

shinyApp(ui = ui, server = server)

