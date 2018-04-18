library(shiny)
library(ggplot2)
library(dplyr)
ui <- fluidPage(
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
                         radioButtons(inputId  = "disp", 
                                      label    = "Display",
                                      choices  = c(Head = "head", All = "all"),
                                      selected = "head")
                 ),
                 mainPanel(
                         tableOutput(outputId = "DataFrame")
                         
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
                if(input$disp == "head") {
                        return(head(df))
                } 
                else if (input$disp == "all") {
                        return(df)
                }
        })
        output$DataFrame<- renderTable(read_data())
}
shinyApp(ui = ui, server = server)
 
