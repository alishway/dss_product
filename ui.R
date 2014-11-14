library(shiny)
library(lattice)
supportedCurrencies <- c("CNY","EUR","RUB","USD", "JPY")


shinyUI(fluidPage(
  titlePanel("Visualize Rates"),
  
  sidebarLayout(
    sidebarPanel(width = 3,
      helpText("Choose a currency pair. 
        (Limited to the past 500 days.)"),
      fluidRow(
          column(width = 6,
              selectInput("sell", 
                          "Sell:", supportedCurrencies,
                          selected = "USD", width=120)),
          column(width = 6,
              selectInput("buy",
                          "Buy:", supportedCurrencies,
                          selected = "CNY", width=120))),
      dateRangeInput("dates", "Date range:", 
                     start = "2014-01-01", end = as.character(Sys.Date()))
    ),
    tabsetPanel(position="below", type="pills",
        tabPanel("Exchange Rate",
            plotOutput("plot"),
            radioButtons("aids","Aids:", 
                         c("Fibonacci Guides"="showFibGuides",
                           "Show MACD"="showMACD","None"),
                         inline = TRUE, selected="None")
            ),
        tabPanel("Round Number Bias",    
            fluidRow(
                column(width = 2, offset = 1,
                       selectInput("sigDigit", "Round to:", 
                                   c("1000" = 9, "100" = 8, "10" = 7, "1" = 6, ".1" = 5,
                                     ".01" = 4, ".001" = 3, ".0001" = 2), 
                                   selected = 3, width=90)
                       ),
                column(width = 8,
                       helpText("A density plot of a digit that is subject to rounding bias 
                                in foreign currency trading should exhibit peaks around 0, 1, 
                                and often 5, as these are selected as threshhold values for
                                purchase and sale of a currency."))
                ),
            plotOutput("plot2")
            )
    )
  )
))