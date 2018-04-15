##### SMUG Web App #####
library(shiny)
library(ggplot2)
library(dplyr)

#Class list for mpg dataframe
classlist <- lapply(mpg,class)

#parsing continuous vs. categorical
c <- select_if(mpg,is.numeric)
d <- select_if(mpg,is.character)

ui <- fluidPage(
  fluidRow(
    column(12, h1("Selected Models User Guided (SMUG)", align = "center")),
    column(12, p("Welcome to SMUG. We know what model you need! Tell us up to two variables and we'll perform basic summary and inference procedures for them.")),
    column(12, p("Before ")),
    column(12, selectInput('data', 'Choose a Variable Situation', c('One Continuous', 'One Categorical'))),
    column(12, uiOutput("select")),
    column(12, uiOutput("radio")),
    column(12, uiOutput("onecont")),
    column(12, uiOutput("onecat"))
  )  
)

server <- function(input,output) {
  
  output$select <- renderUI({ switch(input$data,
                          'One Continuous' = selectInput("ContVar1","Continuous Variables", choices = names(c)),
                          'One Categorical' = selectInput("CatVar","Categorical Variables",choices = names(d)))
  })
  
  output$radio <- renderUI({ switch(input$data,
                          'One Continuous' = radioButtons('tool', 'Choose a tool', c('Five Number Summary', 'Histogram')),
                          'One Categorical' = radioButtons('tool1', 'Choose a tool', c('Frequency Table', 'Proportion Table')))
  })
  
  output$onecont <- renderUI({ switch(input$tool,
                            'Five Number Summary' = verbatimTextOutput('fivenumsum'),
                            'Histogram' = plotOutput('Hist'))
  })
  
  output$onecat <- renderUI({ switch(input$tool1,
                                     'Frequency Table' = ,
                                     'Proportion Table' = )
  })
  
  output$Box <- renderPlot({
    ggplot(mpg,aes_string(input$CatVar,input$ContVar)) + geom_boxplot(aes_string(group=input$CatVar)) + theme_bw()
  })
  
  output$Hist <- renderPlot({
    ggplot(c,aes_string(input$ContVar1)) + geom_histogram(color = "black", fill = "white") + theme_bw()
  })
  
  output$fivenumsum <- renderPrint({
    summary(input$ContVar1)
  })
  
}

shinyApp(ui = ui, server = server)
