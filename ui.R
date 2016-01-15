# ui.R

shinyUI(fluidPage(
  titlePanel("Sales App Dashboard"),
  
  br(),
  
  sidebarLayout(
    sidebarPanel(width = 4,
                 
      helpText("Annual sales data is showing that we are growing our revenue in the last 2 years in
                general. But when comparing the performence of 2015 vs 2014, the growing speed is
                slowing down."),
      br(),
      selectInput("lineColor", 
                  label = "Choose a set of line colors to display:",
                  choices = c("option1", "option2",
                              "option3"),
                  selected = "option1"),
      br(),
      selectInput("lineStyle", 
                  label = "Choose a line style to display:",
                  choices = c("solid", "dashed",
                              "dotted", "dotdash"),
                  selected = "solid"),
      br(),
      radioButtons("yRange", 
                   label = "Choose a vertical range to display:",
                   choices = list("big", "small"),
                   selected = "big"),
      
      br(),br(),br(),br(),br(),
      
      helpText("The word cloud plot shows the popular breweries searched in the last year. 
               Darker terms have higher search frequencies."),
      br(),br(),
      selectInput("wordColor", 
                  label = "Choose a word color to display:",
                  choices = c("blue", "red",
                              "green", "purple"),
                  selected = "green"),
      br(),br(),
      sliderInput("wordNumber",
                  "Maximum Number of Words:",
                  min = 1,  max = 50,  value = 50),
      
      br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),
      
      helpText("Sales data in the last year is captured also by regions (states). 
               The state with darker color has more products sold."),
      br(),br(),
      selectInput("stateColor", 
                  label = "Choose a state color to display:",
                  choices = c("purple", "red",
                              "green", "blue"),
                  selected = "blue"),
      br(),br(),
      radioButtons("boundryColor", 
                   label = "Choose a boundry color to display:",
                   choices = list("black" = 1, "white" = 0),
                   selected = 0),
      
      br(),br(),br(),br(),br(),br(),br(),
      
      helpText("Among all products, Grapefruit Sculpin IPA is the best one with more than 2000 items sold. 
               Also, we list the top 10 products sold in the last year."),
      br(),br(),
      selectInput("barColor", 
                  label = "Choose a bar color to display:",
                  choices = c("black", "red",
                              "green", "blue"),
                  selected = "red"),
      br(),br(),
      sliderInput("barWidth",
                  label = "Choose the width of bars to display:",
                  min = 0.1, max = 1, value = 0.5),
      br(),br(),
      sliderInput("barNumber", 
                  label = "Choose the number of beers to display:",
                  min = 1, max = 10, value = 10),
      
      br(),br(),br(),br(),
      
      helpText("Among all product categories, beers is the most popular one. 
               Then it is followed by gift card sales, subscriptions and wines."),
      br(),br(),
      radioButtons("pieColor", 
                   label = "Choose a label color to display:",
                   choices = list("black", "white"),
                   selected = "black"),
      
      br(),br(),br(),br()
      
    ),
    
  mainPanel(
    h3("Annual Sales Trends", align="center"),
    plotOutput("linePlot"),
    br(),
    br(),
    h3("Word Cloud of Breweries Seaches",align="center"),
    plotOutput("wordPlot"),
    br(),
    br(),
    h3("Geographic Sales Info", align="center"),
    plotOutput("mapPlot"),
    br(),
    br(),
    h3("Most Popular Products Sold", align="center"),
    plotOutput("barPlot"),
    br(),
    br(),
    h3("Sales by Category", align="center"),
    plotOutput("piePlot"),
    br(),
    br(),
    br())
  )
))