# execute the app

library(shiny)
library(ggplot2)
library(maps)
library(scales)
runApp("/Users/uma/Documents/bountyme/match_score/test/shiny/testApp-2")

#deploy the app
#library(rsconnect), not available for the current version
library(shinyapps)
shinyapps::deployApp('/Users/uma/Documents/bountyme/match_score/test/shiny/salesApp')

#app address: https://wsy1607.shinyapps.io/salesApp/