#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
fluidPage(theme = shinytheme("simplex"),
  
  # Application title
  #titlePanel("Intro to F1"),
  
  navbarPage(title='F1 Project',
             #theme='style.css',
             selected="Welcome",
             
             
             tabPanel("Welcome",
                      mainPanel(
                      tags$image(src = "F1_logo.png", type = "image/png", width = "500", height = "231"),
                      tags$audio(src = "extended_F1_2018_theme_by_Brian_Tyler.mp3", type = "audio/mp3", autoplay = F, controls = F),
                      tags$h1(class="title",
                              HTML("<p>Welcome to Maria's F1 App!</p>")),
                      tags$a(href = "https://docs.google.com/forms/d/e/1FAIpQLSfBzjegyTxmIdsf6DhZYCW3vU6Nq0SB2Mu8ubRqfQR21SKXvg/viewform?usp=sharing", "Suggestion Box!")
             )),
             
             tabPanel("Grand Prix Map",
                      sidebarLayout(
                        sidebarPanel(
                          sliderInput(inputId = "year",
                                      label = "Year:",
                                      min = 1950,
                                      max = 2024,
                                      value = 2024,
                                      ticks = FALSE,
                                      sep = ""),
                          checkboxInput(inputId = "mapCheck",
                                        label = "Check to See Travel Overlay",
                                        value = FALSE)
                        ),
                        
                        
                        mainPanel(
                          leafletOutput(outputId = "GPmap"),
                          DT::DTOutput(outputId = "continentsTable")
                        )
                      )
             ),
             
             tabPanel("Driver Nationalities",
                      mainPanel(
                        plotOutput(outputId = "GPparticipants"),
                        plotOutput(outputId = "GPwinners"),
                        plotOutput(outputId = "GPwinpct")
                      )
             ),
             
             tabPanel("Car Reliability",
                      sidebarLayout(
                        sidebarPanel(
                          sliderInput("year",
                                      label = "Year:",
                                      min = 1950,
                                      max = 2024,
                                      value = 2024,
                                      ticks = FALSE,
                                      sep = ""),
                        ),
                        
                        
                        mainPanel(
                          plotOutput(outputId = "reliability"),
                          plotOutput(outputId = "retirements")
                        )
                      )
             ),

             tabPanel("Drivers",
                      sidebarLayout(
                        sidebarPanel(
                          sliderInput("year",
                                      label = "Year:",
                                      min = 1950,
                                      max = 2024,
                                      value = 2024,
                                      ticks = FALSE,
                                      sep = ""),
                          uiOutput("driverSelect"),
                          #     width=3
                        ),
                        
                        
                        mainPanel(
                          htmlOutput(outputId = "driverPic"),
                          plotOutput(outputId = "finishResult"),
                        )
                      )
             ),
             
  )
  
)
