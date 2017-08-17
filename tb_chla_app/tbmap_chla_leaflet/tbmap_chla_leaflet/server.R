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
qpal <- colorNumeric("Greens", as.integer(plotdata$chla_mean), n = 5)

shinyServer(function(input, output, session) {
  filteredData <- reactive({
    plotdata <- plotdata[plotdata$yr==input$year , ]
    })
#  colorpal <- reactive({
#    colorNumeric(input$colors, plotdata$chla_mean)
#  })
  output$map <- renderLeaflet({
    leaflet(plotdata) %>% 
      #addTiles() %>% 
      addProviderTiles(providers$Esri.WorldImagery) %>%
      fitBounds(~min(lon), ~min(lat), ~max(lon), ~max(lat))
  })
  observe({
  leafletProxy("map", data = filteredData()) %>%
    clearMarkers() %>%
  
    addCircleMarkers(~lon, ~lat, 
                       popup = ~as.character(paste('WQ ',stat, ' = ', chla_mean, ' ug/L')),
                       radius = ~chla_mean,
                       color = ~qpal(chla_mean),
                       stroke = FALSE,
                       fillOpacity = 0.6,
                       group = 'Water quality')

  })
  observe({
          proxy <- leafletProxy("map", data = filteredData())
          proxy %>% clearControls()
          if (input$legend) {
            proxy %>%       addLegend(title="Chlorophyll-a", 
                                      pal = qpal, 
                                      values = ~chla_mean, 
                                      labFormat = labelFormat(suffix = " ug/L"), 
                                      opacity = 1,
                                      position = "bottomright")
          }
      })
})
