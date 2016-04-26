rm(list = ls())
library(shiny)
library(randomForest)



iris.rf <- randomForest(Species ~ ., data=iris, importance=TRUE,
                        proximity=TRUE)
summary(iris.rf)

set.seed(17)
iris.urf <- randomForest(iris[, -5])
MDSplot(iris.urf, iris$Species)



ui=fluidPage(


headerPanel("Hello Shiny! This is an example of a random forest!"),

              renderPlot(MDSplot(iris.urf, iris$Species)),

renderText(iris.rf )


            )

server=function(input,output){
  
  

  
  
  }


  
  


shinyApp(ui=ui, server=server)