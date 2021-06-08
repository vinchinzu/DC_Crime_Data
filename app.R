
library(shiny)
library(tidyverse)
library(leaflet)
library(readxl)
library(DT)
library(lubridate)
library(shinyWidgets)
# read in CSV file

load("data/crime_flat.rda")

d$lng <- d$XBLOCK
d$lat <- d$YBLOCK
# d$date =  dmy(d$date)
d <- d %>%  mutate(year_date = floor_date(date, "month"))


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("DC Crime Data"),
  
        leafletOutput("map", width = "100%"),
    hr(),
    fluidRow(
        column(3,
    
               dateRangeInput('dateRange',
                              label = 'Date range input: yyyy-mm-dd',
                              start = as.Date("2008-01-01"), end = as.Date("2019-06-06")
               ),
            pickerInput(input="offense",label = "Choose Crime", 
            choices=unique(d$OFFENSE),
            selected = "HOMICIDE",
            options = list(`actions-box` = TRUE),
            multiple = T)
               # 
               # selectInput(input="offense",
               #             label="Choose Crime:",
               #             selected = "HOMICIDE",
               #             choices = unique(d$OFFENSE))
        ),
        column(3, 
               verbatimTextOutput("totalCount"),
               downloadButton("DownloadData", "Download")
               ),
        column(6,
               plotOutput("demoplot", height="200px"))
    ), 
    hr(),
    dataTableOutput("datatable", width="100%")
 )

# Define server logic required to draw a histogram
server <- function(input, output) {

    hom <- reactive({ 
        req(input$dateRange[1])
        req(input$dateRange[2])
        d %>% filter(OFFENSE == input$offense, #year == input$year, 
                     date >= input$dateRange[1] & date <= input$dateRange[2])
        })

    output$map <- renderLeaflet({
       
        leaflet(data = hom()) %>% addTiles() %>%
            #addMarkers(~XBLOCK, ~YBLOCK, popup = ~as.character(hom$REPORT_DAT))
            addMarkers(popup = ~as.character(REPORT_DAT), clusterOptions = markerClusterOptions())
    })
    
    output$datatable <- renderDataTable({
      DT::datatable(hom())
    })
    
    output$downloadData <- downloadHandler(
        filename = function() {
          paste("data-", Sys.Date(), ".csv", sep="")
        },
        
        content = function(file) {
          write.csv(hom(), file)
        }
    )
    output$totalCount <- renderText({
      r = count(hom())
      paste0("Total incidents: ", r)
      })
    
    output$demoplot <- renderPlot({
      p_data <- hom() %>% group_by(year_date) %>% tally()
      ggplot(p_data, aes(year_date,  n)) + geom_col(alpha=0.2) + geom_smooth() + theme_minimal()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
