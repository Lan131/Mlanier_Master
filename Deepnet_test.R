#install.packages("darch")
library(darch)
library(e1071)
library(MASS)
library(caret)

#regression

  data(cats)
  pp <- preProcess(cats, method=c("scale"))
  catsScaled <- predict(pp, newdata = cats)
  
  darch <- darch(Hwt ~ Bwt,
                 cats,
                 preProc.params = list(method = c("center", "scale")),
                 preProc.targets = T,
                 layers = c(1,20,50,20,1),
                 darch.batchSize =  10,
                 bp.learnRate = .01,
                 darch.isClass = F,
                 darch.numEpochs = 100,
                 darch.unitFunction = linearUnit
                 )
  
  print(darchTest(darch, newdata = cats))
  
  darch

  #XOR
  
  data(iris)
  tc <- trainControl(method = "boot", number = 5, allowParallel = F,
                     verboseIter = T)
  
  parameters <- data.frame(parameter = c("layers", "bp.learnRate", "darch.unitFunction"),
                           class = c("character", "numeric", "character"),
                           label = c("Network structure", "Learning rate", "unitFunction"))
  
  grid <- function(x, y, len = NULL, search = "grid")
  {
    df <- expand.grid(layers = c("c(0,20,0)","c(0,10,10,0)","c(0,10,5,5,0)"), bp.learnRate = c(1,2,5,10))
    
    df[["darch.unitFunction"]] <- rep(c("c(tanhUnit, softmaxUnit)", "c(tanhUnit, tanhUnit, softmaxUnit)", "c(tanhUnit, tanhUnit, tanhUnit, softmaxUnit)"), 4)
    
    df
  }
  
  darch <- train(Species ~ ., data = iris, tuneLength = 12, trControl = tc, 
                 method = darchModelInfo(parameters, grid), preProc = c("center", "scale"),
                 darch.numEpochs = 15, darch.batchSize = 6, testing = T)
  
  darch
  
plot( darch)
ggplot(darch)

#regression benchmark


train=read.csv("C:\\Users\\0019091\\Desktop\\Tableau Reports\\ground.csv")
trainIndex <- createDataPartition(train[,1], p = .7, 
                                  list = FALSE, 
                                  times = 1)
DataTrain <- train[ trainIndex,]
DataTest  <- train[-trainIndex,]

tc <- trainControl(method = "boot", number = 5, allowParallel = F,
                   verboseIter = T)

parameters <- data.frame(parameter = c("layers", "bp.learnRate", "darch.unitFunction"),
                         class = c("character", "numeric", "character"),
                         label = c("Network structure", "Learning rate", "unitFunction"))

grid <- function(x, y, len = NULL, search = "grid")
{
  df <- expand.grid(layers = c("c(0,20,0)","c(0,10,10,0)","c(0,10,5,5,0)"), bp.learnRate = c(1,2,5,10))
  
  df[["darch.unitFunction"]] <- rep(c("c(tanhUnit, linearUnit)", "c(tanhUnit, tanhUnit, linearUnit)", "c(tanhUnit, tanhUnit, tanhUnit, linearUnit)"), 4)
  
  df
}

darch <- train(Target ~ ., data = DataTrain, tuneLength = 12, trControl = tc, preProc.targets = T,
               method = darchModelInfo(parameters, grid), preProc = c("center", "scale"), darch.isClass=F,
              darch.numEpochs = 15, darch.batchSize = 30, xvalid=DataTest[,3:(ncol(DataTest)-1)],yvalid=DataTest[,2])

darch


plot( darch)
ggplot(darch)








#Kaggle Regression


#train=read.csv("C:\\Users\\0019091\\Desktop\\train.csv")
trainIndex <- createDataPartition(train[,1], p = .7, 
                                  list = FALSE, 
                                  times = 1)
DataTrain <- train[ trainIndex,]
DataTest  <- train[-trainIndex,]

tc <- trainControl(method = "boot", number = 5, allowParallel = T,
                   verboseIter = T)

parameters <- data.frame(parameter = c("layers", "bp.learnRate", "darch.unitFunction"),
                         class = c("character", "numeric", "character"),
                         label = c("Network structure", "Learning rate", "unitFunction"))

grid <- function(x, y, len = NULL, search = "grid")
{
  df <- expand.grid(layers = c("c(0,20,0)","c(0,10,10,0)","c(0,10,5,5,0)"), bp.learnRate = c(1,2,5,10))
  
  df[["darch.unitFunction"]] <- rep(c("c(tanhUnit, softmaxUnit)", "c(tanhUnit, tanhUnit, softmaxUnit)", "c(tanhUnit, tanhUnit, tanhUnit, softmaxUnit)"), 4)
  
  df
}

#darch <- train(loss ~ ., data = DataTrain, tuneLength = 12, trControl = tc,
#               method = darchModelInfo(parameters, grid), preProc = c("center", "scale"),
#               darch.numEpochs = 15, darch.batchSize = 100, xvalid=DataTest[,1:ncol(DataTest)-1],yvalid=DataTest[,ncol(DataTest)])

darch

plot( darch)
ggplot(darch)
 
  
