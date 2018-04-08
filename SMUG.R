library(shiny)

ui <- fluidPage(
  titlePanel("Welcome to SMUG!"), 
  
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "var_typ", label = "Variable Situation:", choices = list("1 Quantitative" = 1, "1 Categorical (2 categories)"= 2, 
                  "2 Categorical (each with 2 categories)" = 3, "2 Quantitative" = 4, "1 Quantitative 1 Categorical (2 categories)"=5, "1 Categorical (3 or more categories)"=6,
                  "2 Categorical (1 with 2 categories, 1 with 3 or more) "=7, "2 Categorical (each with 3 or more categories)"=8, 
                  "1 Quantitative 1 Categorical (3 or more categories)"=9), selected = 1,)
      ),
    mainPanel( textOutput(outputId = "result"))
    )
  )


server<- function(input,output){
  output$result <- renderText({ paste("You chose: ", input$var_typ)})
}
shinyApp(ui=ui, server = server)