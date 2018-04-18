library(shiny)
library(ggplot2)
library(dplyr)
library(shinythemes)
ui <- fluidPage(
         theme= shinytheme("superhero"),
         sidebarLayout(
                 
                 sidebarPanel(
                         fileInput(inputId  = "data", 
                                   label    = "Upload your data set",
                                   multiple = TRUE,
                                   accept = c("text/csv",
                                              "text/comma-separated-values,text/plain",
                                              ".csv")),
                         checkboxInput(inputId = "header", label = "Header", value = TRUE),
                         radioButtons(inputId  = "dem", 
                                      label    = "Delimiter",
                                      choices  = c(Comma =",", Semicolon = ";", Tab = "\t"),
                                      selected = ","),
                         checkboxInput(inputId  = "show_data", 
                                       label    = "Show data table",
                                       value    = TRUE),
                         br(), br(),
                         h5("Built with",
                            img(src = "https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png", height = "30px"),
                            "by",
                            img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png", height = "30px"),
                            ".")
                         
                 ),
                 mainPanel(
                         tabsetPanel(id   = "tabspanel",
                                     type = "tabs",
                                     tabPanel(title = "Data", 
                                              br(),
                                              tableOutput(outputId = "DataFrame")
                                              )
                                     )
                         
                 )
         )
)
server <- function(input, output) {
        read_data <- reactive({
                req(input$data)
                df <- read.csv(input$data$datapath,
                               header = input$header,
                               sep    = input$dem,
                               quote  = input$quote,
                               stringsAsFactors = FALSE)
                if(input$show_data) {
                        return(df)
                } 
        })
        output$DataFrame<- renderTable(read_data())
        observeEvent(input$show_data, {
                if(input$show_data){
                        showTab(inputId = "tabspanel", target = "Data", select = TRUE)
                } else {
                        hideTab(inputId = "tabspanel", target = "Data")
                }
        })
}
shinyApp(ui = ui, server = server)
