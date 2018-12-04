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

function()

data <- suppressWarnings(read_xlsx("../data/IDSReport.xlsx", sheet = 6, col_names = TRUE))
data <- select(data, SUBREGION , COUNTRY, SEIZURE_DATE, DRUG_NAME, AMOUNT, DRUG_UNIT, PRODUCING_COUNTRY, 
                      DEPARTURE_COUNTRY, DESTINATION_COUNTRY)



coords <- read.csv("../data/coords.csv", stringsAsFactors = FALSE)
names(coords) <- c("iso2c", "lat", "lng", "name")
match_table <- read.csv("../data/country_codes.csv", stringsAsFactors = FALSE)
match_table <- select(match_table,country_name,iso2c)


# loses a few that do not exist in both
match_and_coords <- inner_join(coords, match_table, by = "iso2c") %>% select(country_name, lat, lng)

names(match_and_coords) <- c("COUNTRY","LAT_COUNTRY","LNG_COUNTRY")
data <- left_join(data, match_and_coords, by = c("COUNTRY"))

names(match_and_coords) <- c("COUNTRY","LAT_PRODUCING","LNG_PRODUCING")
data <- left_join(data, match_and_coords, by = c("PRODUCING_COUNTRY" = "COUNTRY"))

names(match_and_coords) <- c("COUNTRY","LAT_DEPARTURE","LNG_DEPARTURE")
data <- left_join(data, match_and_coords, by = c("DEPARTURE_COUNTRY" = "COUNTRY"))

names(match_and_coords) <- c("COUNTRY","LAT_DESTINATION","LNG_DESTINATION")
data <- left_join(data, match_and_coords, by = c("DESTINATION_COUNTRY" = "COUNTRY"))
# token <- pk.eyJ1IjoiamFuZXR0ZWN3ayIsImEiOiJjanA2ZHJwcW0wOHk3M3BvNmNlYWE2dGJ5In0.ZsZjug12tYHP1K_751NFWA
#maptile <- "https://api.mapbox.com/v4/mapbox.emerald/page.html?access_token=pk.eyJ1IjoiamFuZXR0ZWN3ayIsImEiOiJjanA2ZHJwcW0wOHk3M3BvNmNlYWE2dGJ5In0.ZsZjug12tYHP1K_751NFWA"

shinyServer(function(input, output) {
  output$seizures_map <- renderLeaflet({
    leaflet() %>% 
      addTiles() 
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
