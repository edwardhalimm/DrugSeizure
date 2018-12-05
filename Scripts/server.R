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

#arrow_chart <- read.csv("../data/arrow_chart.csv", stringsAsFactors = FALSE)
#arrow_chart$long <- as.numeric(arrow_chart$long)
#arrow_chart$lat <- as.numeric(arrow_chart$lat)

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
  # observeEvent(input$subregion, {
  #     #Clear the map
  #     leafletProxy("seizures_map") %>% clearShapes() %>% clearPopups()
  #     #using user input
  #     position = which(data$SUBREGION == input$subregion)
  #     #Display new circles according to user input
  #     leafletProxy("seizures_map") %>% addCircles(lng = data$LNG_COUNTRY[position], 
  #                                                 lat = data$LAT_COUNTRY[position], weight = 1, 
  #                                                 radius = data$AMOUNT / 10, color = "#FFA500",
  #                                                 popup = paste("Country: ", data$COUNTRY,
  #                                                               "<br>Drug Name: ", data$DRUG_NAME,
  #                                                               "<br>Amount: ", data$AMOUNT, data$DRUG_UNIT)
  #                                                 )
  #})
  
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
        addAwesomeMarkers(lat = 2.4, lng = 1.4, icon = icon, popup="Seizure Country")
      } else {
          df %>%
          leaflet() %>%
          addTiles() %>%
          addMarkers(popup="Producing Country") %>%
          addAwesomeMarkers(lat = 2.7, lng = 3.4, icon = icon, popup="Seizure and Producing Country")
      }



  })
  
  #Subregion Data
  subregionCoords <- read.csv("../data/subregion_coords.csv", stringsAsFactors = FALSE)
  
  #Icon
  skullIcon <- iconList(
    skull = makeIcon("skull.png", "../data/skull.png", 40, 40)
  )
  
  #Amount of drug seizure each subregion
  count_subregion <- group_by(data, SUBREGION) %>% 
    summarise(count = n())
  
  #Amount of drug type each subregion
  drug_type_count <- reactive({   
    drug_in_each_subregion <- filter(data, data$SUBREGION == input$subregion)
    drug_type_in_subregion <- filter(drug_in_each_subregion, drug_in_each_subregion$DRUG_NAME == input$drugType)

    count_drug_in_subregion <- group_by(drug_type_in_subregion, DRUG_NAME) %>% 
      summarise(count = n())

    number_of_the_drug <- count_drug_in_subregion$count
    number_of_the_drug
  })

  #Number of total drug seizure in each subregion (There is this much of drug seizure in this subregion)
  content <- paste(sep = "<br/>", count_subregion$count)
  
  #Subregion Set View LATITUDE
  view_latitude <- reactive({
    finding_lat <- filter(subregionCoords, subregionCoords$subregion == "Caribbean")
    the_lat <- finding_lat$latitude
    the_lat
  })
  
  #Subregion Set View LONGITUDE
  view_longitude <- reactive({
    finding_long <- filter(subregionCoords, subregionCoords$subregion == "Caribbean")
    the_long <- finding_long$longitude
    the_long
  })
  
  #Leaflet most_region_map
  output$most_region_map <- renderLeaflet({
    drug_in_the_region <- paste("The number of ", input$drugType, " seizure in this region: ", drug_type_count(), sep="")
    num_long <- paste(view_longitude())
    num_lat <- paste(view_latitude())
 
    leaflet(data = subregionCoords[1:13,]) %>% 
      addTiles() %>% 
      setView(lng = num_long, lat = num_lat, zoom = 5) %>% 
      addMarkers(lng = subregionCoords$longitude, lat = subregionCoords$latitude, 
                 icon = ~skullIcon,
                 label = "Press Me",
                 labelOptions = labelOptions(direction = "bottom",
                                             style = list(
                                               "color" = "red",
                                               "font-family" = "serif",
                                               "font-style" = "italic",
                                               "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                                               "font-size" = "12px",
                                               "border-color" = "rgba(0,0,0,0.5)")),
                 popup = paste ("<b>", subregionCoords$subregion,"</b>", "<br>",
                          "Amount of drug seizure in this region: ", content, "<br>", 
                          drug_in_the_region)
      ) %>%
      addEasyButton((easyButton(
        icon = "fa-globe", title = "Zoom out",
        onClick = JS("function(btn, map){map.setZoom(1); }")
      ))) %>% 
      addMeasure(
        position = "bottomleft",
        primaryLengthUnit = "meters",
        primaryAreaUnit = "sqmeters",
        activeColor = "#3D535D",
        completedColor = "#7D4479")
      
  })
  

  
  output$most_country_map <- renderLeaflet({
    
  
    leaflet(data = arrow_chart[arrow_chart$drug == input$drug & arrow_chart$subregion == input$subregion,]) %>%
      addTiles() %>%
      addPolylines(lat = ~lat,
                   lng = ~long,
                   color = "red",
                   group = "current_lines")
  })
   
  
  observeEvent(input$subregion, {
    leafletProxy("most_country_map") %>%
      clearGroup("current_lines") %>%
      addPolylines(data = arrow_chart[arrow_chart$drug == input$drug & arrow_chart$subregion == input$subregion,],
                   lat = ~lat,
                   lng = ~long,
                   color = "red",
                   group = "current_lines")})

  observeEvent(input$drug, {
    leafletProxy("most_country_map") %>%
      clearGroup("current_lines") %>%
      addPolylines(data = arrow_chart[arrow_chart$drug == input$drug & arrow_chart$subregion == input$subregion,],
                   lat = ~lat,
                   lng = ~long,
                   color = "red",
                   group = "current_lines")})


    
  })
