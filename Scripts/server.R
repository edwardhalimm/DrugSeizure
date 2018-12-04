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
#data <- read_xlsx("../data/IDSReport.xlsx", sheet = 6)
#data <- select(data, SUBREGION , COUNTRY, SEIZURE_DATE, DRUG_NAME, AMOUNT, DRUG_UNIT, 
#                      DEPARTURE_COUNTRY, DESTINATION_COUNTRY)

# token <- pk.eyJ1IjoiamFuZXR0ZWN3ayIsImEiOiJjanA2ZHJwcW0wOHk3M3BvNmNlYWE2dGJ5In0.ZsZjug12tYHP1K_751NFWA
#maptile <- "https://api.mapbox.com/v4/mapbox.emerald/page.html?access_token=pk.eyJ1IjoiamFuZXR0ZWN3ayIsImEiOiJjanA2ZHJwcW0wOHk3M3BvNmNlYWE2dGJ5In0.ZsZjug12tYHP1K_751NFWA"


shinyServer(function(input, output) {
  output$seizures_map <- renderLeaflet({
    leaflet() %>% 
      addTiles() 
  })
  
  
  output$relationship_map <- renderLeaflet({
    setwd('c:/Users/Stanley/Desktop/Info201/Final/final_project_info_201/')
    drug_data <- read_xlsx("data/IDSReport.xlsx", sheet = 6, col_names = TRUE)
    location_data <- read_xlsx("data/Location_longitude_latitude.xlsx", col_names = TRUE)
    val <- 0
    df <- data.frame(lat=numeric(0), lng=numeric(0), stringsAsFactors=FALSE) 
    selected_country <- filter(drug_data, input$country2 == COUNTRY)
    as.data.frame(selected_country)
    
    coordinates <- filter(location_data, input$country2 == name)
    select_lat <- coordinates$latitude[1]
    select_lng <- coordinates$longitude[1]
    
    
    for(row in 1:nrow(selected_country)) {
      if(!is.na(selected_country$PRODUCING_COUNTRY[row]) & selected_country$PRODUCING_COUNTRY[row] != "Unknown") {
        coordinates <- filter(location_data, selected_country$PRODUCING_COUNTRY[row] == name)
        df[nrow(df)+1,] <- c(coordinates$latitude[1], coordinates$longitude[1])
        if (input$country2== selected_country$PRODUCING_COUNTRY[row]) {
          val <- 1 
        }
      }
    }
    
    icon <- awesomeIcons(icon = 'flag', iconColor = 'red')
      if(val == 0) {
        na.omit(df)
        df %>%
        leaflet() %>%
        addTiles() %>%
        addMarkers(popup="Producing Country") %>%
        addAwesomeMarkers(lat = select_lat, lng = select_lng, icon = icon, popup="Seizure Country")
      } else {
          df %>%
          leaflet() %>%
          addTiles() %>%
          addMarkers(popup="Producing Country") %>%
          addAwesomeMarkers(lat = select_lat, lng = select_lng, icon = icon, popup="Seizure and Producing Country")
      }
    
    
     
  })
  
})
