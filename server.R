library(quantmod)
library(lattice)

# Functions used to calculate the Fibonacci retracement lines
upperFibR <- function(x) { min(x) + ((max(x) - min(x)) * .618) }
lowerFibR <- function(x) { min(x) + ((max(x) - min(x)) * .382) }

shinyServer(function(input, output) {
    ## get the rate for the selected currency pair and assign to a reactive variable
    rate <- reactive({getFX(paste0(input$sell,'/',input$buy), 
                             from = input$dates[1],
                             to = input$dates[2],
                             auto.assign = FALSE)
                       })
    ## generate a line plot depicting exchange rate history for the pair. 
    output$plot <- renderPlot({
        chartSeries(rate(), theme = chartTheme("white"), 
            type = "line", log.scale = FALSE, name="Rate History", TA = NULL)
        ## optionally let the user choose to display the Fibonacci retracement lines or MACD plot
        if (input$aids == "showFibGuides") {
            abline(upperFibR(rate()),0,col="red")
            abline(lowerFibR(rate()),0,col="red") } else {}
        if (input$aids == "showMACD") { addMACD() } else {}
})
  
  output$plot2 <- renderPlot({
      # create a data frame containing each of the digits from the exchange rate
      # and plot the density for a user selected digit. 
      rate.df <- rate()
      a <- -5
      b <- 6
      while (a < 4) {
          a = a + 1 ; b = b - 1
          rate.df <- cbind(rate.df,
                           trunc((rate() %% 10^a) * 10^b))}
      plot(density(as.numeric(rate.df[,as.numeric(input$sigDigit)])),xlim=c(0,9),
           main="Density at Selected Digit")
      
  })
})