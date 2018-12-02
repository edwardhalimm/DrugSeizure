#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
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
library(shinythemes)

# Define UI for application that draws a histogram
ui <- navbarPage("Drug Seizures Report", theme = "bootstrap.css", 
  
  # Drug seizures in specfic region/country with three widgets 
  tabPanel("Drug Seizures Data", 
           div(class = "outer",
               leafletOutput("seizures_map", width = "100%", height = "100%"),
               absolutePanel(id = "controls", clss = "panel panel-default", fixed = TRUE,
                             draggable = TRUE, top = 70, left = "auto", right = 20, bottom = "auto",
                             width = 330, height = "auto",
                             #Widgets
                             selectInput("subregion", label = h4("Sub-Region"), 
                                        choices = c("North Africa", "Southern Africa", "Caribbean", "Central America",
                                                    "South America", "Central Asia and Transcaucasian countries", "East and South-East Asia",
                                                    "Near and Middle East /South-West Asia", "South Asia", "East Europe", "Southeast Europe",
                                                    "West & Central Europe","Oceania"), 
                                        selected = "North Africa"),
                             selectInput("country", label = h4("Country"),
                                        choices = c("Algeria", "Libyan Arab Jamahiriya","Morocco", "Zambia","Cuba","El Salvador","Chile","Armenia",
                                                    "Azerbaijan","Georgia", "Tajikistan","Uzbekistan","China","Macau, SAR of China","Afghanistan",
                                                    "Pakistan","Syrian Arab Republic","India","Russian Federation","Bulgaria","Croatia","Serbia",
                                                    "Austria","Cyprus","Czech Republic","Czechia","Denmark","Finland","Greece","Lithuania","Malta",
                                                    "Portugal","Slovakia","Slovenia","Spain","Switzerland", "New Zealand",""), 
                                        selected = ""),
                             dateInput("date",label = h4("Choose Date:"),
                                       min = as.Date("2016-01-01"),
                                       max = as.Date("2016-12-31"),
                                       value = c(as.Date("2016-01-01")))
                             
               )
           )
  ),                    
    
    
  #Relationship between countries with widgets 
  tabPanel("Relationship Between Countries",
           div(class = "outer",
               leafletOutput("relationship_map", width = "100%", height = "100%"),
               absolutePanel(id = "controls", clss = "panel panel-default", fixed = TRUE,
                             draggable = TRUE, top = 70, left = "auto", right = 20, bottom = "auto",
                             width = 330, height = "auto",
                             #Widgets
                             selectInput("subregion", label = h4("Sub-Region"), 
                                         choices = c("North Africa", "Southern Africa", "Caribbean", "Central America",
                                                     "South America", "Central Asia and Transcaucasian countries", "East and South-East Asia",
                                                     "Near and Middle East /South-West Asia", "South Asia", "East Europe", "Southeast Europe",
                                                     "West & Central Europe","Oceania"), 
                                         selected = "North Africa"),
                             selectInput("country", label = h4("Country"),
                                         choices = c("Algeria", "Libyan Arab Jamahiriya","Morocco", "Zambia","Cuba","El Salvador","Chile","Armenia",
                                                     "Azerbaijan","Georgia", "Tajikistan","Uzbekistan","China","Macau, SAR of China","Afghanistan",
                                                     "Pakistan","Syrian Arab Republic","India","Russian Federation","Bulgaria","Croatia","Serbia",
                                                     "Austria","Cyprus","Czech Republic","Czechia","Denmark","Finland","Greece","Lithuania","Malta",
                                                     "Portugal","Slovakia","Slovenia","Spain","Switzerland", "New Zealand",""), 
                                         selected = ""),
                             dateInput("date",label = h4("Choose Date:"),
                                       min = as.Date("2016-01-01"),
                                       max = as.Date("2016-12-31"),
                                       value = c(as.Date("2016-01-01")))
                             
               ) 
           )
  ),
  
  #Most trafficked between sub-region
  tabPanel("Most trafficked between Sub-Region"
  ),
  
  #Most trafficked between countries
  tabPanel("Most trafficked between Countries"
  )
)
