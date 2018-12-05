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
  
  # Drug seizures in specfic region/country with three widgets -Janette
  tabPanel("Drug Seizures Data", 
           div(class = "outer",
               leafletOutput("seizures_map", width = "100%", height = "100%"),
               absolutePanel(id = "controls", clss = "panel panel-default", fixed = TRUE,
                             draggable = TRUE, top = 70, left = "auto", right = 20, bottom = "auto",
                             width = 330, height = "auto",
                             #Widgets
                             selectInput("subregion", label = h4("Sub-Region"), 
                                        choices = distinct(data, SUBREGION), 
                                        selected = "North Africa"),
                             selectInput("drug", label = h4("Drug Names"),
                                        choices = distinct(data, DRUG_NAME),
                                        selected = "Heroin"),
                             dateInput("date",label = h4("Choose Date:"),
                                       min = as.Date("2016-01-01"),
                                       max = as.Date("2016-12-31"),
                                       value = c(as.Date("2016-01-01")))
                             
               )
           )
  ),                    
    
    
  #Relationship between countries with widgets 
  tabPanel("Relationship Between Seizure Country and Producing Country",
           div(class = "outer",
               leafletOutput("relationship_map", width = "100%", height = "100%"),
               absolutePanel(id = "controls", clss = "panel panel-default", fixed = TRUE,
                             draggable = TRUE, top = 70, left = "auto", right = 20, bottom = "auto",
                             width = 330, height = "auto",
                             #Widgets
                             selectInput("country2", label = h4("Country"),
                                         choices = c("Algeria", "Libyan Arab Jamahiriya","Morocco", "Zambia","Cuba","El Salvador","Chile","Armenia",
                                                     "Azerbaijan","Georgia", "Tajikistan","Uzbekistan","China","Macau, SAR of China","Afghanistan",
                                                     "Pakistan","Syrian Arab Republic","India","Russian Federation","Bulgaria","Croatia","Serbia",
                                                     "Austria","Cyprus","Czech Republic","Czechia","Denmark","Finland","Greece","Lithuania","Malta",
                                                     "Portugal","Slovakia","Slovenia","Spain","Switzerland", "New Zealand"), 
                                         selected = "Algeria")
                             
               ) 
           )
  ),
  
  #Most trafficked between sub-region - Edward
  tabPanel("Most trafficked between Sub-Region",
           div(class = "outer",
               leafletOutput("most_region_map", width = "100%", height = "100%"),
               absolutePanel(id = "controls", clss = "panel panel-default", fixed = TRUE,
                             draggable = TRUE, top = 70, left = "auto", right = 20, bottom = "auto",
                             width = 330, height = "auto",
                             #Widgets
                             selectInput("subregion", label = h4("Sub-Region"), 
                                         choices = distinct(data, SUBREGION), 
                                         selected = "North Africa"),
                            # dateInput("date",label = h4("Choose Date:"),
                             #          min = as.Date("2016-01-01"),
                              #         max = as.Date("2016-12-31"),
                               #        value = c(as.Date("2016-01-01"))),
                             selectInput("drugType", label = h4 ("Drug type"),
                                         choices = distinct(data, DRUG_NAME)),
                             plotOutput("testingPlot")
                             
                             
               )
           )
  ),
  
  
  
  #Most trafficked between countries - Stanley
  tabPanel("Most trafficked between Countries",
           div(class = "outer",
               leafletOutput("most_country_map", width = "100%", height = "100%")
           )
  )
)

shinyUI(ui)
