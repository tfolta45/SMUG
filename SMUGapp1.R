##### SMUG Web App #####
library(shiny)
library(ggplot2)
library(dplyr)

#Class list for mpg dataframe
classlist <- lapply(mpg,class)

#parsing quantitative vs. categorical
c <- select_if(mpg,is.numeric)
d <- select_if(mpg,is.character)

ui <- fluidPage(
  fluidRow(
    column(12, h1("Selected Models User Guided (SMUG)", align = "center")),
    column(12, p("Welcome to SMUG. We know what model you need! Tell us up to two variables and we'll perform basic summary and inference procedures for them.")),
    column(12, selectInput('data', 'Choose a Variable Situation', c('One Quantitative', 'One Categorical', 'Two Quantitative', 'Two Categorical', 'One Categorical, One Quantitative'))),
    column(12, uiOutput("select")),
    column(12, uiOutput("select1")),
    column(12, uiOutput("radio")),
    column(12, uiOutput("final"))
  )  
)

server <- function(input,output) {
  
  output$select <- renderUI({ switch(input$data,
                                    'One Quantitative' = selectInput("QuantVar","Quantitative Variables",choices = names(c)),
                                    'One Categorical' = selectInput("CatVar","Categorical Variables",choices = names(d)),
                                    'Two Quantitative' = selectInput("QuantVar","Quantitative Variables",choices = names(c)),
                                    'Two Categorical' = selectInput("CatVar","Categorical Variables",choices = names(d)),
                                    'One Categorical, One Quantitative' = selectInput("CatVar","Categorical Variables",choices = names(d)))
  })
  
  output$select1 <- renderUI({ switch(input$data,
                                     'Two Quantitative' = selectInput("QuantVar1","Quantitative Variables", choices = names(c)),
                                     'Two Categorical' = selectInput("CatVar1","Categorical Variables",choices = names(d)),
                                     'One Categorical, One Quantitative' = selectInput("QuantVar2","Quantitative Variables",choices = names(c)))
  })
  
  output$radio <- renderUI({ switch(input$data,
                                   'One Quantitative' = radioButtons('tool', 'Choose a tool', c('Five Number Summary', 'Histogram')),
                                   'One Categorical' = radioButtons('tool1', 'Choose a tool', c('Frequency Table', 'Proportion Table')),
                                   'Two Quantitative' = radioButtons('tool2', 'Choose a tool', c('Scatterplot', 'Linear Regression')),
                                   'Two Categorical' = radioButtons('tool3', 'Choose a tool', c('Frequency Table', 'Proportion Table', 'Chi-Square Test')),
                                   'One Categorical, One Quantitative'= radioButtons('tool4', 'Choose a tool', c('Box Plot', 'ANOVA / T-test')))
  })
  
  output$onequant <- renderUI({ switch(input$tool,
                                      'Five Number Summary' = verbatimTextOutput('fivenumsum'),
                                      'Histogram' = plotOutput('Hist'))
  })
  
  output$onecat <- renderUI({ switch(input$tool1,
                                    'Frequency Table' = verbatimTextOutput('freqTab'),
                                    'Proportion Table' = verbatimTextOutput('propTab'))
  })
  
  output$twoquant <- renderUI({ switch(input$tool2,
                                      'Scatterplot' = plotOutput('scatterplot'),
                                      'Linear Regression' = verbatimTextOutput('linearmodel'))
  })
  
  output$twocat <- renderUI({ switch(input$tool3,
                                    'Frequency Table' = verbatimTextOutput('twowayfreqTab'),
                                    'Proportion Table' = verbatimTextOutput('twowaypropTab'),
                                    'Chi-Square Test' = verbatimTextOutput('chisquaretest'))
  })
  
  output$onequantonecat <- renderUI({ switch(input$tool4,
                                            'Box Plot' = plotOutput('Box'),
                                            'ANOVA / T-test' = )
  })
  
  output$final <- renderUI({ switch(input$data,
                                   'One Quantitative' = uiOutput('onequant'),
                                   'One Categorical' = uiOutput('onecat'),
                                   'Two Quantitative' = uiOutput('twoquant'),
                                   'Two Categorical' = uiOutput('twocat'),
                                   'One Categorical, One Quantitative' = uiOutput('onequantonecat'))
  })
  
  output$Hist <- renderPlot({
    ggplot(c,aes_string(input$QuantVar)) + geom_histogram(color = "black", fill = "white") + theme_bw()
  })
  
  output$fivenumsum <- renderPrint({
    c1 <- c[,input$QuantVar]
    summary(c1)
  })
  
  output$freqTab <- renderPrint({
    Frequencies <- d[,input$CatVar]
    table(Frequencies)
  })
  
  output$propTab <- renderPrint({
    Proportions <- d[,input$CatVar]
    prop.table(table(Proportions))
  })
  
  output$scatterplot <- renderPlot({
    ggplot(c,aes_string(input$QuantVar,input$QuantVar1)) + geom_point() + theme_bw()
  })
  
  output$linearmodel <- renderPrint({
    lmdata <- as.data.frame(c[,c(input$QuantVar,input$QuantVar1)])
    summary(lm(lmdata[,2] ~ lmdata[,1]))
  })
  
  output$twowayfreqTab <- renderPrint({
    Frequencies1 <- as.data.frame(d[,c(input$CatVar,input$CatVar1)])
    table(Frequencies1[,1],Frequencies1[,2])
  })
  
  output$twowaypropTab <- renderPrint({
    Proportions1 <- as.data.frame(d[,c(input$CatVar,input$CatVar1)])
    prop.table(table(Proportions1[,1],Proportions1[,2]))
  })
  
  output$chisquaretest <- renderPrint({
    Frequencies1 <- as.data.frame(d[,c(input$CatVar,input$CatVar1)])
    freq <- table(Frequencies1[,1],Frequencies1[,2])
    chisq.test(freq)
  })
  
  output$Box <- renderPlot({
    ggplot(mpg,aes_string(input$CatVar,input$QuantVar2)) + geom_boxplot(aes_string(group=input$CatVar)) + theme_bw()
  })
  
}

shinyApp(ui = ui, server = server)
