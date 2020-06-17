#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(tidyverse)
library(writexl)
library(tictoc)
library(sp)
library(rgdal)
library(geosphere)
library(shiny)
library(shinydashboard)
library(leaflet)
mylocation = "C:/Users/Byeongjun Cho/Desktop/2020-1/데이터사이언스입문/data/open_api"
setwd(mylocation)

CTPRVN_1 = readOGR(mylocation, "CTPRVN_1")

ui <- fluidPage(
    mainPanel( 
        leafletOutput(outputId = "mymap", height = "900px", width = "125%")))

bins = c(0, 4.476, 13.739, 32.531, 40.033, 84, Inf)
pal = colorBin("YlGnBu", domain = CTPRVN_1@data$score_num, bins = bins)

server <- function(input, output) {
    pal2 = colorNumeric("viridis", CTPRVN_1@data$score_num, reverse=TRUE)
    output$mymap = renderLeaflet({
        leaflet(CTPRVN_1) %>%
            setView(lng=127.7669,lat=35.90776, zoom=7.5) %>%
            addProviderTiles('CartoDB.Positron') %>%
            addPolygons(color='#444444', 
                        weight=2, opacity = 1.0, fillOpacity = 0.5, 
                        fillColor=~pal(score_num)) %>%
            addLegend(pal = pal, values = ~score_num, opacity = 0.7, title = NULL,
                      position = "bottomright")})}
shinyApp(ui, server)