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


#Read in original data set and set useful columns
data <- suppressWarnings(read_xlsx("../data/IDSReport.xlsx", sheet = 6, col_names = TRUE))
data <- select(data, SUBREGION , COUNTRY, SEIZURE_DATE, DRUG_NAME, AMOUNT, DRUG_UNIT, PRODUCING_COUNTRY, 
                      DEPARTURE_COUNTRY, DESTINATION_COUNTRY)

#Read in coordinates data sets
coords <- read.csv("../data/coords.csv", stringsAsFactors = FALSE)
names(coords) <- c("iso2c", "lat", "lng", "name")
match_table <- read.csv("../data/country_codes.csv", stringsAsFactors = FALSE)
match_table <- select(match_table,country_name,iso2c)

#Join coordinate columns to data
#loses a few that do not exist in both(useful)
match_and_coords <- inner_join(coords, match_table, by = "iso2c") %>% select(country_name, lat, lng)

names(match_and_coords) <- c("COUNTRY","LAT_COUNTRY","LNG_COUNTRY")
data <- left_join(data, match_and_coords, by = c("COUNTRY"))

names(match_and_coords) <- c("COUNTRY","LAT_PRODUCING","LNG_PRODUCING")
data <- left_join(data, match_and_coords, by = c("PRODUCING_COUNTRY" = "COUNTRY"))

names(match_and_coords) <- c("COUNTRY","LAT_DEPARTURE","LNG_DEPARTURE")
data <- left_join(data, match_and_coords, by = c("DEPARTURE_COUNTRY" = "COUNTRY"))

names(match_and_coords) <- c("COUNTRY","LAT_DESTINATION","LNG_DESTINATION")
data <- left_join(data, match_and_coords, by = c("DESTINATION_COUNTRY" = "COUNTRY"))

names(match_and_coords) <- c("country", "lat", "long")
coords <- match_and_coords

# token <- pk.eyJ1IjoiamFuZXR0ZWN3ayIsImEiOiJjanA2ZHJwcW0wOHk3M3BvNmNlYWE2dGJ5In0.ZsZjug12tYHP1K_751NFWA
#maptile <- "https://api.mapbox.com/v4/mapbox.emerald/page.html?access_token=pk.eyJ1IjoiamFuZXR0ZWN3ayIsImEiOiJjanA2ZHJwcW0wOHk3M3BvNmNlYWE2dGJ5In0.ZsZjug12tYHP1K_751NFWA"



shinyServer(function(input, output) {

  output$seizures_map <- renderLeaflet({
    leaflet() %>% 
      addTiles() %>%
      setView(lat = 49.81749 ,lng = 15.47296,zoom = 6) %>%
      addCircles( lng = data$LNG_COUNTRY, lat = data$LAT_COUNTRY,
                   weight = 1, 
                   radius = data$AMOUNT / 10,
                   color = "#FFA500",
                   popup = paste("Country: ", data$COUNTRY,
                                "<br>Drug Name: ", data$DRUG_NAME,
                                "<br>Amount: ", data$AMOUNT, data$DRUG_UNIT)) %>%
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
  #Action on selectInput
  observeEvent(input$subregion, {
      leafletProxy("seizures_map") %>% clearShapes() %>% clearPopups()
      position = which(data$SUBREGION == input$subregion)
      leafletProxy("seizures_map") %>% addCircles(lng = data$LNG_COUNTRY[position], 
                                                  lat = data$LAT_COUNTRY[position], weight = 1, 
                                                  radius = data$AMOUNT / 10, color = "#FFA500") %>%
        addPopups(lng = data$LNG_COUNTRY[position], lat =data$LAT_COUNTRY[position], 
                  popup = paste("Country: ", data$COUNTRY,
                                "<br>Drug Name: ", data$DRUG_NAME,
                                "<br>Amount: ", data$AMOUNT, data$DRUG_UNIT))
  })
  
  output$relationship_map <- renderLeaflet({
    leaflet() %>%
      addTiles()
  })
  
  
  output$relationship_map <- renderLeaflet({
    drug_data <- read_xlsx("../data/IDSReport.xlsx", sheet = 6, col_names = TRUE)
    location_data <- read_xlsx("../data/Location_longitude_latitude.xlsx", col_names = TRUE)
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
  output$most_region_map <- renderLeaflet({
    # test
    leaflet(data = coords[1:20,]) %>% addTiles() %>%
      addMarkers(~long, ~lat)
  })
  output$most_country_map <- renderLeaflet({
    leaflet() %>%
      addTiles()
  })
})
