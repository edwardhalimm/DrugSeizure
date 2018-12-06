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
                 
                 
                 # Drug seizures data with specific drug type  -Janette
                 tabPanel("Drug Seizures Data",
                          div(class = "outer",
                              leafletOutput("seizures_map", width = "100%", height = "100%"),
                              absolutePanel(id = "controls", clss = "panel panel-default", fixed = TRUE,
                                            draggable = TRUE, top = 70, left = "auto", right = 20, bottom = "auto",
                                            width = 330, height = "auto",
                                            #Widgets
                                            selectInput("drug", label = h4("Drug Name"),
                                                        choices = c("Heroin","Cannabis Sativa","Cocaine","Unknown","Cannabis resin","Cannabis Herb (Marijuana)","Non-specified psychotropic substances","Ecstasy","Tabacco","Edible cannabis","Pseudoephedrine","Cannabis seeds","Cannabis Plants","Opium","Crack","Methamphetamine","Coca paste","Cocaine HCL","Cocaine Base","Non-specified pharmaceuticals","Morphine","LSD","25I-NBOMe","2C-B","Coca leaf","Other","Hydrochloric Acid","Hallucinogens","Sodium Carbonate","Sulphuric Acid","DOC","Psilocybin (mushrooms)","Amphetamine","4-fluoromethcathinone","Mephedrone","Methylphenidate","Liquid cocaine","Acetone/Ethyl Ether","2C-E","Ketamine","DOB","Ephedrine","Bromazepam","Diazepam","Alprazolam (Xanax)","Methadone","Tramadol","Buprenorphine","Cannabis Oil",NA,"Brotizolam","Clonazepam","Non-specified NPS","Pregabalin","Cannabis","Opium Poppy","Poppy straw","AB-FUBINACA","Karcidone","Nitrazepam","THC","Nimetazepam","Barbiturates","Pavots","Acetic Anhydride","Captagon","Cough sirups","Spasmo proxyvon","Ammonium chloride","Methaqualone","Pentazocine","Zolpidem","MDMA & Mephedrone","Hydrocodone","Oxycodone","Lorazepam","Other precursors","Multiple drugs","N-Methylephedrone","Methylester","N-(1-carbamoil-2-methylpropyl)-1-(phenylmethyl)-1n-indazole-3-carboxamide and its derivaties","JWH-018","Alpha-pvp","3-Methylfentanyl","Phenyl-2-nitropropene","Pyrovalerone","N-(1-carbamoil-2-methylpropil)-1-pentil-1n-indazole-3-carboxamyde and its derivates","Acyl","2C-H","Dimethyltryptamine (DMT)","Desomorphine","Clobazam","Codeine","3-butenoyl-1-methylindole [1- (1-methyl-1H-indol-3-yl) butan-1-one] and derivatives","Carfentanil","Phenobarbital","Ephedrone","Phentermine","Modafinil","Oxazepam","Methyl ether","Synthetic Cannabinoid","Extract from Opium poppy","UR-144","HU-210","Cathinone","Anabolic steroids","AB-PINACA","Phenylpiperazine","Methanone","Amfepramone Hydrochloride","Dextromethorphan","Acetylated Opium","Thiopropamine","5F-APINACA, 5F-AKB-48","MDMB-CHMICA","Khat","CUMYL-5F-PINACA","AB-CHMINACA","5F-ADB","MDMB-CHMCZCA","Ethylphenidate","4-MEC","PMK-glycidate","XLR-11","APAA","Benzodiazepine","Substitol (slow release Morphine)","Synthetics","CHLORMETHCATHINON","25B-NBOMe","4-CMC","GBL","METHANDROSTENOLONE","Fentanyl","4-Fluoroamphetamine","6-MAPB","AM-2201","MDPV","1-phenethyl-4-hydroxypiperidine","bk_MDEA","4-CI-a-PVP","Amphetamine-Ketamine Mix","Ephylone","4-Chloromethcathinone","MDPA","2-MMC","para-Methoxy-N-methylamphetamine","Cannabis Pollen","Mescaline","Medazepam","MDEA","Opiates","Non-specified stimulants","Benzylpiperazine","Phenethylamines","GABA","Zopiclone","GHB/GBL","Liquid methamphetamine","Hypophosphorous Acid","MDA","Iodine","Hydromorphone","Sodium hydroxide","Phosphorous Acid","4-HO-DiPT","Tapentadol","Methylone","Fuelite","Toluene","Potassium Permanganate"),
                                                        selected = "Cannabis resin")
                              )
                          )
                 ),
                 
                 
                 #Relationship between countries with widgets - Stanley
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
                                            draggable = TRUE, top = 140, left = "auto", right = 1, bottom = "auto",
                                            width = 330, height = "auto",
                                            #Widgets
                                            selectInput("subregion", label = h4("Sub-Region"), 
                                                        choices = c("North Africa","Southern Africa","Caribbean","Central America","South America","Central Asia and Transcaucasian countries","East and South-East Asia","Near and Middle East /South-West Asia","South Asia","East Europe","Southeast Europe","West & Central Europe","Oceania"), 
                                                        selected = "All"),
                                            selectInput("drugType", label = h4 ("Drug type"),
                                                        choices = c("Heroin","Cannabis Sativa","Cocaine","Unknown","Cannabis resin","Cannabis Herb (Marijuana)","Non-specified psychotropic substances","Ecstasy","Tabacco","Edible cannabis","Pseudoephedrine","Cannabis seeds","Cannabis Plants","Opium","Crack","Methamphetamine","Coca paste","Cocaine HCL","Cocaine Base","Non-specified pharmaceuticals","Morphine","LSD","25I-NBOMe","2C-B","Coca leaf","Other","Hydrochloric Acid","Hallucinogens","Sodium Carbonate","Sulphuric Acid","DOC","Psilocybin (mushrooms)","Amphetamine","4-fluoromethcathinone","Mephedrone","Methylphenidate","Liquid cocaine","Acetone/Ethyl Ether","2C-E","Ketamine","DOB","Ephedrine","Bromazepam","Diazepam","Alprazolam (Xanax)","Methadone","Tramadol","Buprenorphine","Cannabis Oil",NA,"Brotizolam","Clonazepam","Non-specified NPS","Pregabalin","Cannabis","Opium Poppy","Poppy straw","AB-FUBINACA","Karcidone","Nitrazepam","THC","Nimetazepam","Barbiturates","Pavots","Acetic Anhydride","Captagon","Cough sirups","Spasmo proxyvon","Ammonium chloride","Methaqualone","Pentazocine","Zolpidem","MDMA & Mephedrone","Hydrocodone","Oxycodone","Lorazepam","Other precursors","Multiple drugs","N-Methylephedrone","Methylester","N-(1-carbamoil-2-methylpropyl)-1-(phenylmethyl)-1n-indazole-3-carboxamide and its derivaties","JWH-018","Alpha-pvp","3-Methylfentanyl","Phenyl-2-nitropropene","Pyrovalerone","N-(1-carbamoil-2-methylpropil)-1-pentil-1n-indazole-3-carboxamyde and its derivates","Acyl","2C-H","Dimethyltryptamine (DMT)","Desomorphine","Clobazam","Codeine","3-butenoyl-1-methylindole [1- (1-methyl-1H-indol-3-yl) butan-1-one] and derivatives","Carfentanil","Phenobarbital","Ephedrone","Phentermine","Modafinil","Oxazepam","Methyl ether","Synthetic Cannabinoid","Extract from Opium poppy","UR-144","HU-210","Cathinone","Anabolic steroids","AB-PINACA","Phenylpiperazine","Methanone","Amfepramone Hydrochloride","Dextromethorphan","Acetylated Opium","Thiopropamine","5F-APINACA, 5F-AKB-48","MDMB-CHMICA","Khat","CUMYL-5F-PINACA","AB-CHMINACA","5F-ADB","MDMB-CHMCZCA","Ethylphenidate","4-MEC","PMK-glycidate","XLR-11","APAA","Benzodiazepine","Substitol (slow release Morphine)","Synthetics","CHLORMETHCATHINON","25B-NBOMe","4-CMC","GBL","METHANDROSTENOLONE","Fentanyl","4-Fluoroamphetamine","6-MAPB","AM-2201","MDPV","1-phenethyl-4-hydroxypiperidine","bk_MDEA","4-CI-a-PVP","Amphetamine-Ketamine Mix","Ephylone","4-Chloromethcathinone","MDPA","2-MMC","para-Methoxy-N-methylamphetamine","Cannabis Pollen","Mescaline","Medazepam","MDEA","Opiates","Non-specified stimulants","Benzylpiperazine","Phenethylamines","GABA","Zopiclone","GHB/GBL","Liquid methamphetamine","Hypophosphorous Acid","MDA","Iodine","Hydromorphone","Sodium hydroxide","Phosphorous Acid","4-HO-DiPT","Tapentadol","Methylone","Fuelite","Toluene","Potassium Permanganate"),
                                                        textInput("target_zone", "Ex: Bamako")
                                                        
                                                        
                                            )
                              )
                          )
                 ),
                 
                 # Interactive plot - adrian
                 
                 tabPanel("Interactive Bar Graph",
                          div(class = "outer",
                              br(),
                              br(),
                              plotOutput("country_chart"),
                              br(),
                              h3(textOutput("summary")),
                              absolutePanel(id = "controls", clss = "panel panel-default", fixed = TRUE,
                                            draggable = TRUE, top = 70, left = "auto", right = 20, bottom = "auto",
                                            width = 330, height = "auto",
                                            #Widgets
                                            selectInput("country", label = h4("Country"),
                                                        choices = c("Algeria", "Libyan Arab Jamahiriya","Morocco", "Zambia","Cuba","El Salvador","Chile","Armenia",
                                                                    "Azerbaijan","Georgia", "Tajikistan","Uzbekistan","China","Macau, SAR of China","Afghanistan",
                                                                    "Pakistan","Syrian Arab Republic","India","Russian Federation","Bulgaria","Croatia","Serbia",
                                                                    "Austria","Cyprus","Czech Republic","Czechia","Denmark","Finland","Greece","Lithuania","Malta",
                                                                    "Portugal","Slovakia","Slovenia","Spain","Switzerland", "New Zealand"), 
                                                        selected = "India"),
                                            
                                            selectInput("drug", label = h4("Drug Names"),
                                                        choices = c("ALL", "Heroin","Cannabis Sativa","Cocaine","Unknown","Cannabis resin","Cannabis Herb (Marijuana)","Non-specified psychotropic substances","Ecstasy","Tabacco","Edible cannabis","Pseudoephedrine","Cannabis seeds","Cannabis Plants","Opium","Crack","Methamphetamine","Coca paste","Cocaine HCL","Cocaine Base","Non-specified pharmaceuticals","Morphine","LSD","25I-NBOMe","2C-B","Coca leaf","Other","Hydrochloric Acid","Hallucinogens","Sodium Carbonate","Sulphuric Acid","DOC","Psilocybin (mushrooms)","Amphetamine","4-fluoromethcathinone","Mephedrone","Methylphenidate","Liquid cocaine","Acetone/Ethyl Ether","2C-E","Ketamine","DOB","Ephedrine","Bromazepam","Diazepam","Alprazolam (Xanax)","Methadone","Tramadol","Buprenorphine","Cannabis Oil",NA,"Brotizolam","Clonazepam","Non-specified NPS","Pregabalin","Cannabis","Opium Poppy","Poppy straw","AB-FUBINACA","Karcidone","Nitrazepam","THC","Nimetazepam","Barbiturates","Pavots","Acetic Anhydride","Captagon","Cough sirups","Spasmo proxyvon","Ammonium chloride","Methaqualone","Pentazocine","Zolpidem","MDMA & Mephedrone","Hydrocodone","Oxycodone","Lorazepam","Other precursors","Multiple drugs","N-Methylephedrone","Methylester","N-(1-carbamoil-2-methylpropyl)-1-(phenylmethyl)-1n-indazole-3-carboxamide and its derivaties","JWH-018","Alpha-pvp","3-Methylfentanyl","Phenyl-2-nitropropene","Pyrovalerone","N-(1-carbamoil-2-methylpropil)-1-pentil-1n-indazole-3-carboxamyde and its derivates","Acyl","2C-H","Dimethyltryptamine (DMT)","Desomorphine","Clobazam","Codeine","3-butenoyl-1-methylindole [1- (1-methyl-1H-indol-3-yl) butan-1-one] and derivatives","Carfentanil","Phenobarbital","Ephedrone","Phentermine","Modafinil","Oxazepam","Methyl ether","Synthetic Cannabinoid","Extract from Opium poppy","UR-144","HU-210","Cathinone","Anabolic steroids","AB-PINACA","Phenylpiperazine","Methanone","Amfepramone Hydrochloride","Dextromethorphan","Acetylated Opium","Thiopropamine","5F-APINACA, 5F-AKB-48","MDMB-CHMICA","Khat","CUMYL-5F-PINACA","AB-CHMINACA","5F-ADB","MDMB-CHMCZCA","Ethylphenidate","4-MEC","PMK-glycidate","XLR-11","APAA","Benzodiazepine","Substitol (slow release Morphine)","Synthetics","CHLORMETHCATHINON","25B-NBOMe","4-CMC","GBL","METHANDROSTENOLONE","Fentanyl","4-Fluoroamphetamine","6-MAPB","AM-2201","MDPV","1-phenethyl-4-hydroxypiperidine","bk_MDEA","4-CI-a-PVP","Amphetamine-Ketamine Mix","Ephylone","4-Chloromethcathinone","MDPA","2-MMC","para-Methoxy-N-methylamphetamine","Cannabis Pollen","Mescaline","Medazepam","MDEA","Opiates","Non-specified stimulants","Benzylpiperazine","Phenethylamines","GABA","Zopiclone","GHB/GBL","Liquid methamphetamine","Hypophosphorous Acid","MDA","Iodine","Hydromorphone","Sodium hydroxide","Phosphorous Acid","4-HO-DiPT","Tapentadol","Methylone","Fuelite","Toluene","Potassium Permanganate"),
                                                        selected = "ALL"),
                                            
                                            radioButtons("relationship", "Choose relationship to seizure country:",
                                                         c("Country of Origin", "Destination Country"),
                                                         selected = "Country of Origin"),
                                            radioButtons("angle", "Choose country text orientation:",
                                                         c("Vertical", "Horizontal"),
                                                         selected = "Vertical")
                              ) 
                          )
                 )
                 
                 
                 
)


shinyUI(ui)
