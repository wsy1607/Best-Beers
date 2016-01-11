# ui.R

shinyUI(fluidPage(
  titlePanel("Top Beers"),
  
  sidebarLayout(
    sidebarPanel(width = 3,
      helpText("A very little program to display top beers."),
      
      selectInput("col", 
                  label = "Choose a color to display:",
                  choices = c("black", "red",
                              "green", "blue"),
                  selected = "green"),
      
      sliderInput("width",
                  label = "the width of bars",
                  min = 0.1, max = 1, value = 0.5),
      
      sliderInput("k", 
                  label = "number of beers to display:",
                  min = 1, max = 10, value = 5)
      
    ),
    
    mainPanel(
      h1("Top K Beers", align="center"),
      plotOutput("simplePlot"))
  )
))