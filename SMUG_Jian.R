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
                        checkboxInput(inputId  = "show_result", 
                                      label    = "Show the result",
                                      value    = TRUE),
                        selectInput('x', "Numerical Variable (X)", ""),
                        selectInput('y', "Numerical Variable (Y)", "" , selected = ""),
                        selectInput('u', "Categorical Variable (U)", "", selected = ""),
                        selectInput('v', "Categorical Variable (V)", "", selected = ""),
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
                                             tableOutput(outputId = "DataFrame")),
                                    tabPanel(title = "Plot",
                                             plotOutput(outputId = "myplot1"),
                                             br(), br(),
                                             plotOutput(outputId = "myplot2")),
                                             br(), br(),
                                             plotOutput(outputId = "myplot3"))
                        
                        
                )
        )
)
server <- function(input, output, session) {
        read_data <- reactive({
                req(input$data)
                df <- read.csv(input$data$datapath,
                               header = input$header,
                               sep    = input$dem,
                               quote  = input$quote,
                               stringsAsFactors = TRUE)
                updateSelectInput(session, inputId = 'x', label = 'Numerical Variable (X)',
                                  choices = names(df[ ,sapply(df, is.numeric)]), selected = names(df[ ,sapply(df, is.numeric)]))
                updateSelectInput(session, inputId = 'y', label = 'Numerical Variable (Y) ',
                                  choices =  names(df[ ,sapply(df, is.numeric)]), selected = names(df[ ,sapply(df, is.numeric)])[2])
                updateSelectInput(session, inputId = 'u', label = 'Categorical Variable (U)',
                                  choices =  names(df[ ,sapply(df, is.factor)]), selected = names(df[ ,sapply(df, is.factor)]))
                updateSelectInput(session, inputId = 'v', label = "Categorical Variable (V)",
                                  choices =  names(df[ ,sapply(df, is.factor)]), selected = names(df[ ,sapply(df, is.factor)])[2])
                if(input$show_result) {
                        return(df)
                } 
        })
        output$DataFrame<- renderTable(read_data())
        observeEvent(input$show_result, {
                if(input$show_result){
                        showTab(inputId = "tabspanel", target = c("Data", "Plot"), select = TRUE)
                } else {
                        hideTab(inputId = "tabspanel", target = c("Data", "Plot"))
                }
        })
        output$myplot1 <- renderPlot({
                ggplot(data = read_data(), aes_string(x = input$x)) +
                        geom_histogram() + theme_bw()
                })
        output$myplot2 <- renderPlot({
                ggplot(data = read_data(), aes_string(x = input$x, y = input$y)) +
                        geom_point() + theme_bw()
        })
        output$myplot3 <- renderPlot({
                ggplot(data = read_data(), aes_string(input$x, input$u)) + 
                        geom_boxplot(aes_string(group=input$u)) + theme_bw()
        })
}
shinyApp(ui = ui, server = server)
