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
                           img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png", height = "30p
