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
                        selectInput('x', "X-axis", ""),
                        selectInput('y', "Y-axis", "" , selected = ""),
                        selectInput('z', "Color by:", "", selected = ""),
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
                                             plotOutput(outputId = "scatterplot"))
                                    
                        )
                        
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
                               stringsAsFactors = FALSE)
                updateSelectInput(session, inputId = 'x', label = 'X-axis',
                                  choices = names(df), selected = names(df))
                updateSelectInput(session, inputId = 'y', label = 'Y-axis',
                                  choices = names(df), selected = names(df)[2])
                updateSelectInput(session, inputId = 'z', label = 'Color by:',
                                  choices = names(df), selected = names(df)[3])
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
        output$scatterplot <- renderPlot({
                ggplot(data = read_data(), aes_string(x = input$x, y = input$y, color = input$z)) +
                        geom_point()
        })
}
shinyApp(ui = ui, server = server)
