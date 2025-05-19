#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

# Define server logic required to draw a histogram
function(input, output, session) {
  
  custom_theme = theme(
    title = element_text(size = 20),
    axis.title.x = element_text(size = 18),
    axis.text.x = element_text(size = 16),
    axis.title.y = element_text(size = 18))
  
  output$GPmap <- renderLeaflet({
    
    if (input$mapCheck == TRUE){
      races_df |> 
        filter(year==input$year) |> 
        leaflet() |>
        #addProviderTiles('Esri.WorldImagery') |> 
        addTiles(options = tileOptions(noWrap = TRUE)) |>
        setView(lng = 0, lat = 0, zoom =1.5) |> 
        addCircleMarkers(lng = ~lng,
                         lat = ~lat,
                         radius = 2,
                         color = "red",
                         fillOpacity = 1.0,
                         #popup = ~paste(location, ", ", country, sep=""),
                         popup = ~paste(date),
                         label = ~as.character(GPname)) |> 
        #addPolylines(lng = ~lng, lat = ~lat, group = ~raceId, color = "blue", weight = 1, opacity = 0.5)
        addArrowhead(lng = ~lng, 
                     lat = ~lat, 
                     group = ~raceId, 
                     color = "blue", 
                     weight = 1, 
                     opacity = 0.5,
                     options = arrowheadOptions(yawn = 40, 
                                                size = "5%",
                                                frequency = 50))
    }
    
    else{
      races_df |> 
        filter(year==input$year) |> 
        leaflet() |>
        #addProviderTiles('Esri.WorldImagery') |> 
        addTiles(options = tileOptions(noWrap = TRUE)) |>
        setView(lng = 0, lat = 0, zoom =1.5) |> 
        addCircleMarkers(lng = ~lng,
                         lat = ~lat,
                         radius = 2,
                         color = "red",
                         fillOpacity = 1.0,
                         #popup = ~paste(location, ", ", country, sep=""),
                         popup = ~paste(date),
                         label = ~as.character(GPname)
        )
    }
    
    
  })
  
  
  output$continentsTable <- DT::renderDT({
    races_df |> 
      filter(year==input$year) |>
      group_by(continent) |> 
      summarise(count = n()) |> 
      mutate(percent = count/sum(count)*100) |> 
      mutate(across(where(is.numeric), round, digits = 1)) |> 
      DT::datatable(
        colnames = c("Continent" = "continent", "Number of Races" = "count", "Percentage of Races" = "percent")
      )
  })
  
  
  output$GPparticipants <- renderPlot({
    nationalities |> 
      ggplot(aes(x = nationality, y = participated)) +
      geom_col() +
      scale_x_discrete(guide = guide_axis(angle = 90)) +
      labs(title = "All GP Participants by Nationality",
           x = "Nationality",
           y = "Number of Drivers") +
      custom_theme
    
  })
  
  output$GPwinners <- renderPlot({
    nationalities |> 
      filter(won > 0) |> 
      ggplot(aes(x = nationality, y = won)) +
      geom_col() +
      scale_x_discrete(guide = guide_axis(angle = 90)) +
      labs(title = "All GP Winners by Nationality",
           x = "Nationality",
           y = "Number of Drivers") +
      custom_theme
    
  })    
  
  output$GPwinpct <- renderPlot({
    nationalities |> 
      filter(win_percentage > 0) |> 
      ggplot(aes(x=nationality, y=win_percentage)) +
      geom_col()+
      scale_x_discrete(guide = guide_axis(angle = 90)) +
      labs(title = "Overall GP Win Percentage by Nationality",
           x = "Nationality",
           y = "Win Percentage") +
      custom_theme
    
  })
  
  output$reliability <- renderPlot({
    results_df |> 
      group_by(year) |> 
      summarise(finishPercentage = (sum(positionText != 'R'))/(n=n())) |> 
      ggplot(aes(x=year, y=finishPercentage)) +
      geom_line() +
      labs(title = "Reliability (as percentage of non-retirements) Over Time",
           x = "Year",
           y = "Percentage of Cars that Finished the Race") +
      custom_theme
  })
  
  output$retirements <- renderPlot({
    results_df |> 
      filter(year == input$year) |> 
      filter(!(status %in% c('107% Rule', 'Finished', 'Not classified', 'Withdrew')), !(str_detect(status, pattern = 'Lap')), !(str_detect(status, pattern = 'qual'))) |>
      #ggplot(aes(x=status)) +
      ggplot(aes(x = fct_infreq(status))) +
      geom_bar() +
      scale_x_discrete(guide = guide_axis(angle = 90)) +
      labs(title = "Non-finishing status",
           x = "Issue",
           y = "Number of Cars") +
      custom_theme
  })
  
  output$driverSelect <- renderUI({
    results_df <- results_df |> 
      filter(year == input$year)
    selectInput(inputId = "driver", 
                label = "Pick Your Fighter:", 
                choices = (results_df |> distinct(driverName) |> pull(driverName) |> sort())
    )
  })
  
  
  # output$driverPic <- renderText({
  #   c(
  #     '<img src="',
  #     "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/Lewis_Hamilton_2022_S%C3%A3o_Paulo_Grand_Prix_%2852498120773%29_%28cropped%29.jpg/100px-Lewis_Hamilton_2022_S%C3%A3o_Paulo_Grand_Prix_%2852498120773%29_%28cropped%29.jpg",
  #     '">'
  #   )
  # })
  
  output$finishResult <- renderPlot({
    results_df |> 
      filter(year == input$year) |> 
      filter(driverName == input$driver) |> 
      ggplot(aes(x=GPname, y=points)) +
      geom_col() +
      scale_x_discrete(guide = guide_axis(angle = 90)) +
      labs(title = "Points Scored Over the Course of a Season",
           x = "Grand Prix",
           y = "Points Scored") +
      custom_theme
  })
  
}