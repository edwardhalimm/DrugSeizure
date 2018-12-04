#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(leaflet)
library(httr)
library(dplyr)
library(readxl)
library(shiny)
library(shinydashboard)
library(graphics)
library(googleVis)
data <- suppressWarnings(read_xlsx("../data/IDSReport.xlsx", sheet = 6, col_names = TRUE))
data <- select(data, SUBREGION , COUNTRY, SEIZURE_DATE, DRUG_NAME, AMOUNT, DRUG_UNIT, 
                     DEPARTURE_COUNTRY, DESTINATION_COUNTRY)
# token <- pk.eyJ1IjoiamFuZXR0ZWN3ayIsImEiOiJjanA2ZHJwcW0wOHk3M3BvNmNlYWE2dGJ5In0.ZsZjug12tYHP1K_751NFWA
#maptile <- "https://api.mapbox.com/v4/mapbox.emerald/page.html?access_token=pk.eyJ1IjoiamFuZXR0ZWN3ayIsImEiOiJjanA2ZHJwcW0wOHk3M3BvNmNlYWE2dGJ5In0.ZsZjug12tYHP1K_751NFWA"
shinyServer(function(input, output) {


  output$seizures_map <- renderLeaflet({
    leaflet() %>% 
      addTiles() %>%
      setView() %>%
      addCircles()
    
    #Button to zoom out
    addEasyButton((easyButton(
      icon = "fa-globe", title = "Zoom to Level 1",
      onClick = JS("function(btn, map){map.setZoom(1); }")
    ))) %>%
    #Button to locate user
    addEasyButton(easyButton(
      icon = "fa-crosshairs", title = "Locate Me",
      onClick = JS("function(btn,map){ map.locate({setView:true}); }")
    )) 
    
  })
  output$relationship_map <- renderLeaflet({
    leaflet() %>%
      addTiles()
  })
  output$most_region_map <- renderLeaflet({
    leaflet() %>%
      addTiles()
  })
  output$most_country_map <- renderLeaflet({
    leaflet() %>%
      addTiles()
  })
})
