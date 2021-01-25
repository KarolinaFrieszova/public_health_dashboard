library(tidyverse)
library(shiny)
library(shinythemes)
library(janitor)
library(tidyr)

# get data
birth_weight_summary <- 
  read_csv("birth_weight_summary.csv") %>% 
  clean_names()

# council and national summary by SIMD code
council_summary <- birth_weight_summary %>% 
  group_by(council_area_name, simd_code, date_code) %>%
  summarise(all_births = sum(all_births),
            low_weight_births = sum(low_weight_births),
            percent_low_birth_weight = round((100*(sum(low_weight_births)/sum(all_births))),2)) %>% 
  arrange(council_area_name, date_code) 


all_scotland_summary <- birth_weight_summary %>% 
  mutate(council_area_name = "1 - All Scotland") %>% 
  group_by(council_area_name, simd_code, date_code) %>%
  summarise(all_births = sum(all_births),
            low_weight_births = sum(low_weight_births),
            percent_low_birth_weight = round((100*(sum(low_weight_births)/sum(all_births))),2)) %>% 
  arrange(council_area_name, date_code) 

national_and_council_summary <-
  bind_rows(all_scotland_summary, council_summary)


# create lists for select inputs
council_list <- unique(sort(national_and_council_summary$council_area_name))



ui <- fluidPage(
    theme = shinytheme("paper"),
    
    titlePanel("Percentage of all births with low birth weight"),
    titlePanel(tags$h4("By SIMD deprivation category")),

    
    
    
    fluidRow(
      #Select council area 
        column(3, 
               
               selectInput("council_select",
                           tags$h5("Select Council Area"),
                           choices = council_list
               )
               
        ), #close 1st column
        

        
     
        
        
    ), # close fluidrow 1
    
    

    
   # Graph
    fluidRow(
        column(12,
               
               plotOutput("council_plot"), 
               
        ) # close 1st column
        
        
    ), # close fluidrow 2    
    
    
) #close fluidpage






server <- function(input, output) {
    

    # Data for graph
    output$council_plot <- renderPlot({
        national_and_council_summary %>%
        mutate(simd_code = paste("SIMD", simd_code, " ")) %>%
            filter(council_area_name == input$council_select) %>%
            select(council_area_name,
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
    }) #end 1st output
  
}
shinyApp(ui = ui, server = server)
