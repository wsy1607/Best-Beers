# server.R
library(ggplot2)
library(maps)
library(tm)
library(wordcloud)
library(memoise)
library(scales)

#generate data

#total sales
totalSales <- data.frame(
  #month = c("Aug-14","Sep-14","Oct-14","Nov-14","Dec-14","Jan-15","Feb-15","Mar-15","Apr-15","May-15","Jun-15","Jul-15"),
  month = rep(c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"),2),
  order = c(1:12,1:12),
  year = c(rep("2015",12),rep("2014",12)),
  sales = c(60832,69128,66483,68037,60596,64244,72451,64578,68823,68891,73205,77147,
            26579,30337,36986,43010,34573,34665,57251,36135,44724,46185,65288,70947))

totalSales$month <- reorder(totalSales$month,totalSales$order)
totalSales$year <- factor(totalSales$year, levels = rev(levels(totalSales$year)))

#best beers
bestBeers <- data.frame(
  product_title = c("Ballast Point Grapefruit Sculpin IPA","Prairie BOMB Imperial Stout",
                    "AleSmith Speedway Stout","Ballast Point Habanero Sculpin IPA",
                    "Russian River Pliny the Elder IPA","Epic Big Bad Baptist Imperial Stout",
                    "Mikkeller Beer Geek Brunch Weasel","Almanac Dogpatch Sour Ale",
                    "Knee Deep Simtra Triple IPA","Almanac Farmer's Reserve Pluot"),
  quantity_count = c(2128,1748,1433,1110,1035,844,724,683,632,632))

bestBeers$ordered_product <- reorder(bestBeers$product_title, bestBeers$quantity_count)

#vendor searching frequenties
vendors <- c("Stone Brewing","Ballast Point Brewing","Mikkeller","Almanac Beer","Prairie Artisan Ales",
             "AleSmith Brewing","Modern Times Beer","The Lost Abbey","Clown Shoes Beer",
             "Firestone Walker Brewing","Deschutes Brewery","Evil Twin Brewing","Knee Deep Brewing",
             "Avery Brewing","Boulevard Brewing","The Bruery","Belching Beaver Brewery","Epic Brewing",
             "Russian River Brewing","Hair of the Dog Brewing","Cascade Brewing","Ommegang",
             "Port Brewing","Midnight Sun Brewing","Bell's Brewery","Alaskan Brewing",
             "Anchorage Brewing","Allagash Brewing","Alpine Beer","Great Divide Brewing",
             "Goose Island","Crooked Stave Artisan Beer Project","New Belgium Brewing",
             "Green Flash Brewing","Sierra Nevada Brewing","Dieu du Ciel!","Lagunitas Brewing",
             "Drake's Brewing","Amager","To Ol","Dogfish Head Craft Brewery","Mother Earth Brew",
             "Coronado Brewing","De Molen","Ninkasi Brewing","Bear Republic Brewing","Logsdon Ales",
             "Pizza Port Brewing","FiftyFifty Brewing","Anderson Valley")

frequencies <- c(3181,2797,2795,2480,2066,2034,1948,1925,1856,1813,1649,1645,1615,1332,1331,1313,
                 1235,1196,1127,993,984,926,902,861,822,788,788,787,772,771,759,753,715,699,697,
                 673,670,637,611,588,581,564,564,556,554,547,527,525,512,509)

#sales map
us <- map_data("state")
beersMap <- data.frame(
  regions = c("alabama","alaska","arizona","arkansas","california","colorado","connecticut","delaware",
             "florida","georgia","hawaii","idaho","illinois","indiana","iowa","kansas","kentucky",
             "louisiana","maine","maryland","massachusetts","michigan","minnesota","mississippi",
             "missouri","montana","nebraska","nevada","new hampshire","new jersey","new mexico",
             "new york","north carolina","north dakota","ohio","oklahoma","oregon","pennsylvania",
             "rhode island","south carolina","south dakota","tennessee","texas","utah","vermont",
             "virginia","washington","west virginia","wisconsin","wyoming"),
  sales = c(7.2,10.0,8.1,8.8,22.1,7.9,3.3,5.9,12.4,10.4,5.3,2.6,10.4,7.2,2.2,6.0,9.7,11.4,2.1,8.3,
           4.4,10.1,2.7,12.1,9.0,6.0,4.3,12.2,2.1,12.4,11.4,17.1,13.0,0.8,7.3,6.6,4.9,6.3,3.4,14.4,
           3.8,10.2,12.7,3.2,2.2,8.5,14.0,5.7,2.6,6.8))

#sales by category
beersCategory <- data.frame(
  categories = c("beer","wine","cider","gift card","subscription","others"),
  percentSales = c(0.353, 0.101, 0.068, 0.213, 0.182, 0.083)
  )

#get top k best sellers (beers)
shinyServer(
  function(input, output) {
    output$barPlot <- renderPlot({
      ggplot(data=bestBeers[1:input$barNumber,], aes(x=ordered_product, y=quantity_count)) +
        geom_bar(fill = input$barColor, alpha = 0.3, color = "black",stat="identity",width = input$barWidth) + 
        geom_text(aes(label=quantity_count), vjust=0.5, hjust = 1.1, size=5)+
        theme_bw() + 
        coord_flip()
    })
    output$linePlot <- renderPlot({
      yRange <- switch(input$yRange,
                           "big"=c(0,100000),
                           "small" = c(20000,80000))
      lineColor <- switch(input$lineColor,
                           "option1"="Set1",
                           "option2" = "Set2",
                           "option3" = "Accent")
      ggplot(data=totalSales, aes(x=month, y=sales, group=year, colour=year)) +
        geom_line(linetype=input$lineStyle) +
        geom_point() +
        coord_cartesian(ylim = yRange) +
        scale_color_brewer(palette=lineColor)
    })
    output$wordPlot <- renderPlot({
      wordColors <- switch(input$wordColor,
                           "blue"="Blues",
                           "green" = "YlGn",
                           "red" = "Reds",
                           "purple" = "RdPu")
      wordcloud(vendors,
                frequencies,
                max.words=input$wordNumber,
                scale=c(2,0.5),colors=brewer.pal(8, wordColors))
    })
    output$mapPlot <- renderPlot({
      stateColor <- switch(input$stateColor,
                           "blue"="Blues",
                           "green" = "YlGn",
                           "red" = "Reds",
                           "purple" = "RdPu")
      highColor = brewer.pal(5, stateColor)[5]
      lowColor =  brewer.pal(5, stateColor)[1]
      ggplot() + geom_map(data=us,map=us,aes(x=long,y=lat,map_id=region),fill="#ffffff",color="#ffffff",size=0.15) +
        geom_map(data=beersMap,map=us,aes(fill=sales,map_id=regions),color=input$boundryColor,size=0.2) +
        scale_fill_continuous(low=lowColor, high=highColor, guide='colorbar') +
        theme(panel.border = element_blank()) +
        theme(panel.background = element_blank()) +
        theme(axis.ticks = element_blank()) +
        theme(axis.text = element_blank())
    })
    output$piePlot <- renderPlot({
      pieColor <- switch(input$pieColor,
                           "blue"="Blues",
                           "green" = "YlGn",
                           "red" = "Reds",
                           "default" = "Set1")
      blank_theme <- theme_minimal()+
        theme(
          axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          #panel.border = element_blank(),
          #panel.grid=element_blank(),
          axis.ticks = element_blank(),
          plot.title=element_text(size=14, face="bold")
        )
      ggplot(beersCategory, aes(x = "", y=percentSales, fill=categories)) +
        geom_bar(width = 1, stat = "identity") +
        coord_polar("y", start=0) + 
        blank_theme +
        theme(axis.text.x=element_blank()) +
        geom_text(aes(y = percentSales/3 + c(0, cumsum(percentSales)[-length(percentSales)]), 
                      label = percent(percentSales)), size=5, color = input$pieColor)
      
    })
  }
)
