#install.packages("darch")
library(darch)
library(e1071)
library(MASS)
library(caret)

#autoencoder
data(iris)
summary(iris)

darch <- darch(iris[,1:4], iris[,1:4], c(4,100,2,100,4), darch.dropout = .5,darch.isClass = F,
               preProc.params = list(method = c("center", "scale")), preProc.targets = T,
               darch.numEpochs = 100, darch.batchSize = 3,
               darch.unitFunction = softplusUnit, bp.learnRate = .1,
               darch.fineTuneFunction = "backpropagation")

abs(iris[,1:4]-predict(darch, newdata = iris[,1:4]))

df=as.data.frame(rowSums(abs(iris[,1:4]-predict(darch, newdata = iris[,1:4]))/iris[,1:4]))

ggplot(df, aes(df[,1])) +geom_histogram(aes(y = ..density..),bins=25) + geom_density()


ind=rowSums(abs(iris[,1:4]-predict(darch, newdata = iris[,1:4]))/iris[,1:4])
dat=as.data.frame(cbind(iris,ind))
data=dat[which(ind<quantile(df[,1],.9)),]
dat=data[,-6]



  #XOR

 

  tc <- trainControl(method = "repeatedcv", number = 5, allowParallel = T,
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
  
  darch <- train(Species ~ ., data = dat, tuneLength = 10, trControl = tc, 
                 method = darchModelInfo(parameters, grid), preProc = c("center", "scale"),
                 darch.numEpochs = 15, darch.batchSize = 10, testing = T)
  
  darch
  
plot( darch$finalModel)
ggplot(darch)
darch$finalModel





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


plot( darch)








#regression benchmark


train=read.csv("C:\\Users\\0019091\\Desktop\\Tableau Reports\\ground.csv")


tc <- trainControl(method = "repeatedcv", number = 5, allowParallel = T,
                   verboseIter = T)

parameters <- data.frame(parameter = c("layers", "bp.learnRate", "darch.unitFunction"),
                         
                         label = c("Network structure", "Learning rate", "unitFunction"))

grid <- function(x, y, len = NULL, search = "grid")
{
  df <- expand.grid(layers = c("c(0,20,0)","c(0,10,10,0)","c(0,10,5,5,0)"), bp.learnRate = c(1,2,5,10))
  
  df[["darch.unitFunction"]] <- rep(c("c(tanhUnit, linearUnit)", "c(tanhUnit, tanhUnit, linearUnit)", "c(tanhUnit, tanhUnit, tanhUnit, linearUnit)"), 4)
  
  df
}
attach(train)
darch <- train(Target ~ Cat1+Cat2+Cont1, data = train, tuneLength = 12, trControl = tc,
               method = darchModelInfo(parameters, grid), preProc = c("center", "scale"), darch.isClass=F,
              darch.numEpochs = 15, darch.batchSize = 10)

darch


plot( darch)
ggplot(darch)

  
