##### SMUG Web App #####
library(shiny)

ui <- fluidPage(
  fluidRow(
    column(12, h1("Selected Models User Guided (SMUG)", align = "center")),
    column(12, p("Welcome to SMUG. We know what model you need! Tell us up to two variables and we'll perform basic summary and inference procedures for them.")),
    column(12, p("Before "))
  )  
)

server <- function(input,output) {
}

shinyApp(ui = ui, server = server)
