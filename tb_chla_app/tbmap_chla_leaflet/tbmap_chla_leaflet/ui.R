#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(RColorBrewer)
plotdata <-read.csv("yr_mean.csv")

# Define UI for application that draws a histogram
shinyUI(bootstrapPage(
  title = "Tampa Bay Chlorophyll-a Data",
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(top = 10, right = 10,
                div(style="background: white"),
                sliderInput("year", "Year",
                            min = 1974, 
                            max = 2016,
                            value = 1974, 
                            step = 1,
                            sep = ""
                ),
                #selectInput("colors", "Color Scheme",
                #            rownames(subset(brewer.pal.info, category %in% c("seq", "div")))
                #),
                checkboxInput("legend", "Show legend", TRUE),
                style = "background-color: rgba(255,255,255,0.85); 
                         border-radius: 5px;
                         padding: 5px 5px;"
  )
)
)
