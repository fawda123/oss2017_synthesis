#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Tampa Bay Chlorophyll-a Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       sliderInput("year",
                   "Year:",
                   min = 1974,
                   max = 2016,
                   value = 1974,
                   step = 1)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("chlaPlot")
    )
  )
))
