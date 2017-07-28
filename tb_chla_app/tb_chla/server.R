#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggmap)
library(dplyr)
library(ggplot2)

plotdata <-read.csv("yr_mean.csv")
ext <- make_bbox(plotdata$lon, plotdata$lat, f = 0.2)
map <- get_stamenmap(ext, zoom = 12, maptype = "toner-lite")
#map <- get_googlemap('tampabay', zoom = 12, size = c(800, 600), scale = 2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$chlaPlot <- renderPlot({
    plotdata <- filter(plotdata, year==2006)
    a<-min(plotdata$chla_mean)
    b<-mean(plotdata$chla_mean)
    c<-max(plotdata$chla_mean)
    leaflet(plotdata) %>% 
      addTiles() %>%
      #  addProviderTiles(providers$CartoDB.Positron) %>% 
      addCircleMarkers(~lon, ~lat, 
                       popup = ~as.character(paste('WQ ',stat)),
                       radius = ~chla_mean,
                       color = 'green',
                       stroke = TRUE,
                       group = 'Water quality') %>% 
     addLegend(position="topright", 
               color=c("green", "green", "green"), 
               label=c(a,b,c),
               size = c(as.numeric(a), as.numeric(b), as.numeric(c))
               values=c(a,b,c))
    
  })
  
})
