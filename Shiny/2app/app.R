library(shiny)

library(rsconnect)

setwd("G:/Files/Rfiles/Shiny")

# Define server logic required to draw a histogram
server=shinyServer(function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  output$distPlot <- renderPlot({
    x    <- faithful[, 2]  # Old Faithful Geyser data
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
})




# Define UI for application that draws a histogram
ui=shinyUI(fluidPage(
  h1("This is a thrilling page."),
  # Application title
  titlePanel("Look at this graph. Yeah this one->"),
  
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
  ,h1("Best graph you have ever seen.") 
))


shinyApp(ui=ui, server=server)

rsconnect::setAccountInfo(name='mlanier131',
                          token='5419D62A77BAA6D730CA4D58F5DE014C',
                          secret='0/17/yd5Ahm9FKEueF136icSwW4sHDzIkCYuD1Ae')

rsconnect::deployApp('2app')
