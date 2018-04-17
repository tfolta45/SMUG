library(shiny)
ui <- fluidPage(
        titlePanel(""),
        sidebarLayout(
                
                sidebarPanel(
                        fileInput("file1", "Choose CSV File",
                                  multiple = TRUE,
                                  accept = c("text/csv",
                                             "text/comma-separated-values,text/plain",
                                             ".csv")),
                        
                        checkboxInput("header", "Header", TRUE),
                        
                        radioButtons("sep", "Separator",
                                     choices = c(Comma =",",
                                                 Semicolon = ";",
                                                 Tab = "\t"),
                                     selected = ","),
                        
                        radioButtons("disp", "Display",
                                     choices = c(Head = "head",
                                                 All = "all"),
                                     selected = "head"),
                        uiOutput('column')),
                
                mainPanel(
                        tableOutput("contents"),
                        textOutput(outputId = "result")
                )))
library(shiny)
require(randtests)
server <- function(input, output) {
        
        read_data <- reactive({
                req(input$file1)
                df <- read.csv(input$file1$datapath,
                               header = input$header,
                               sep = input$sep,
                               quote = input$quote,
                               stringsAsFactors = FALSE)
                
                if(input$disp == "head") {
                        return(head(df))
                }
                else {
                        return(df)
                }})
        
        column_names <- reactive({
                names(read_data())
        })
        
        bartels_rank <- reactive({
                x <- read_data()[[input$column]]
                bartels.rank.test(x, alternative = 'two.sided', pvalue="normal")
        })
        
        output$column = renderUI({
                selectInput("column", 
                            label = "Select column", 
                            choices = column_names(),
                            selected = column_names()[1])
        })
        
        output$contents <- renderTable({
                read_data()
        })
        
        output$result <- renderText({
                bartels_rank() %>% as.character()
        })
        
}
shinyApp(ui = ui, server = server)