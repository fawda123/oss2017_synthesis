#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(RColorBrewer)
plotdata <-read.csv("yr_mean.csv")
pal <- colorNumeric("Greens", plotdata$chla_mean, n = 5)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  filteredData <- reactive({
    plotdata<-filter(plotdata, year==input$year)
    })
#  colorpal <- reactive({
#    colorNumeric(input$colors, plotdata$chla_mean)
#  })
  output$map <- renderLeaflet({
    leaflet(plotdata) %>% 
      addTiles() %>%
      fitBounds(~min(lon),~min(lat), ~max(lon), ~max(lat)) 

  })
  
  observe({
#    pal <- colorpal()
    
    leafletProxy("map", data = filteredData()) %>%
      clearShapes() %>%
      addCircleMarkers(~lon, ~lat, 
                       radius = ~chla_mean,
                       stroke= FALSE,
                       fillColor = ~pal(chla_mean), 
                       fillOpacity = 0.7, 
                       popup = ~paste(chla_mean))%>%
      clearShapes() 
  })
    observe({
      proxy <- leafletProxy("map", data = filteredData())
      proxy %>% clearControls() %>% clearShapes()
      if (input$legend) {
#        pal <- colorpal()
        proxy %>% addLegend(position = "bottomright",
                           pal = pal, values = ~chla_mean)
      }
  })
})
