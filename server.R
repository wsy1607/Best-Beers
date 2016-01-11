# server.R
library(ggplot2)

#generate data
bestBeers <- data.frame(
  product_title = c("Grapefruit Sculpin IPA", "Milk Stout", "Habanero Sculpin IPA", 
                    "AleSmith Speedway Stout", "Prairie BOMB Imperial Stout", 
                    "Baptist Imperial Stout", "Geek Brunch Weasel", "Dieu du Ciel", 
                    "Almanac Dogpatch Sour", "Knee Deep"),
  quantity_count = c(2128,1748,1433,1110,1035,844,724,683,632,632))
#change data types
bestBeers$product_title <- as.character(bestBeers$product_title)

# get top k best sellers (beers)
shinyServer(
  function(input, output) {
    output$simplePlot <- renderPlot({
      ggplot(data=bestBeers[1:input$k,], aes(x=product_title, y=quantity_count)) +
        geom_bar(fill = input$col, color = "black",stat="identity",width = input$width) + 
        geom_text(aes(label=quantity_count), vjust=-0.5, size=5)+
        theme_minimal()
    })
  }
)
