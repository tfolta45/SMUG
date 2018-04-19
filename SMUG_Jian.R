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
                        selectInput('z', "Categorical Variable (Z)", ""),
                        
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
                                    tabPanel(title = "Plots",
                                             plotOutput(outputId = "histogram"),
                                             br(), br(),
                                             plotOutput(outputId = "scatter_plot"),
                                             br(), br(),
                                             plotOutput(outputId = "box_plot"))
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
                               stringsAsFactors = TRUE)
                updateSelectInput(session, inputId = 'x', label = 'Numerical Variable (X)',
                                  choices = names(df[ ,sapply(df, is.numeric)]), selected = names(df[ ,sapply(df, is.numeric)]))
                updateSelectInput(session, inputId = 'y', label = 'Numerical Variable (Y)',
                                  choices =  names(df[ ,sapply(df, is.numeric)]), selected = names(df[ ,sapply(df, is.numeric)])[2])
                updateSelectInput(session, inputId = 'z', label = 'Categorical Variable (Z) ',
                                       choices = names(which(sapply(df, is.factor))), selected = names(which(sapply(df, is.factor))))
                
                if(input$show_result) {
                        return(df)
                }
})
        output$DataFrame<- renderTable(read_data())
        observeEvent(input$show_result, {
                if(input$show_result){
                        showTab(inputId = "tabspanel", target = c("Data", "Plots"), select = TRUE)
                } else {
                        hideTab(inputId = "tabspanel", target = c("Data", "Plots"))
                }
        })
        output$histogram <- renderPlot({
                ggplot(data = read_data(), aes_string(x = input$x)) +
                        geom_histogram()
                })
        output$scatter_plot <- renderPlot({
                ggplot(data = read_data(), aes_string(x = input$x, y = input$y)) +
                        geom_point()
        })
        output$box_plot <- renderPlot({
                ggplot(data = read_data( ), aes_string(x=input$z, y=input$x)) + 
                        geom_boxplot()
        })
}
shinyApp(ui = ui, server = server)
