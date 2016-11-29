setwd('C:\\Users\\0019091\\Desktop')
data=read.csv('rate_forest.csv',header=T)
head(data)
library(randomForest)
data=na.roughfix(data)
fit=randomForest(x=data[,2:5],y=data[,1])
fit
library(plyr)
library(dplyr)

library(caret)
library(RCurl)
library(e1071)

fitControl <- trainControl(## 5-fold CV
  method = "cv",
  number = 5,
  
  search = "random"
)


xgbFit1 <- train(Rate ~ ., data = data, 
                 method = "xgbTree"
                 ,preProc = c("center", "scale")
                 ,na.action=na.omit,metric='RMSE',maximize=F,trControl = fitControl
                 ,tuneLength = 15)     



bayesFit1 <- train(Rate ~ ., data = data, 
                   method = "bayesglm", 
                   trControl = fitControl,preProc = c("center", "scale")
                   ,na.action=na.omit,metric='RMSE',maximize=F) 


cart <-  train(Rate ~ ., data = data,   
               method = "rpart", 
               trControl = fitControl,preProc = c("center", "scale")
               ,na.action=na.omit,metric='RMSE',maximize=F)               

glm <-  train(Rate ~ ., data = data,   
              method = "glmStepAIC", 
              trControl = fitControl,preProc = c("center", "scale")
              ,na.action=na.omit,metric='RMSE',maximize=F)               



qt <- train(Rate ~ ., data = data,   
              method = "qrf", 
              trControl = fitControl,preProc = c("center", "scale")
              ,na.action=na.omit,metric='RMSE',maximize=F)     

evtree <- train(Rate ~ ., data = data,   
            method = "evtree", 
            trControl = fitControl,preProc = c("center", "scale")
            ,na.action=na.omit,metric='RMSE',maximize=F)     

el=train(Rate ~ ., data = data,   
           method = "elm", 
           trControl = fitControl,preProc = c("center", "scale")
           ,na.action=na.omit,metric='RMSE',maximize=F)  


lasso=train(Rate ~ ., data = data,   
         method = "lasso", 
         trControl = fitControl,preProc = c("center", "scale")
         ,na.action=na.omit,metric='RMSE',maximize=F) 


svmL=train(Rate ~ ., data = data,   
            method = "svmLinear", 
            trControl = fitControl,preProc = c("center", "scale")
            ,na.action=na.omit,metric='RMSE',maximize=F) 


map=train(Rate ~ ., data = data,   
           method = "bdk", 
           trControl = fitControl,preProc = c("center", "scale")
           ,na.action=na.omit,metric='RMSE',maximize=F) 


RL=train(Rate ~ ., data = data,   
          method = "rlm", 
          trControl = fitControl,preProc = c("center", "scale")
          ,na.action=na.omit,metric='RMSE',maximize=F) 

dnn=train(Rate ~ ., data = data,   
         method = "dnn", 
         trControl = fitControl,preProc = c("range")
         ,na.action=na.omit,metric='RMSE',maximize=F) 


ridge=train(Rate ~ ., data = data,   
          method = "ridge", 
          trControl = fitControl,preProc = c("range")
          ,na.action=na.omit,metric='RMSE',maximize=F) 

Radial_LS=train(Rate ~ ., data = data,   
            method = "krlsRadial", 
            trControl = fitControl,preProc = c("range")
            ,na.action=na.omit,metric='RMSE',maximize=F) 

part_LS=train(Rate ~ ., data = data,   
                method = "simpls", 
                trControl = fitControl,preProc = c("range")
                ,na.action=na.omit,metric='RMSE',maximize=F) 
names(part_LS)
names(part_LS$finalModel)
F=part_LS$finalModel
plot(F)
F$coefficients
plot(F$scores)
summary(F)


lar=train(Rate ~ ., data = data,   
              method = "lars", 
              trControl = fitControl,preProc = c("range")
              ,na.action=na.omit) 


avNNet=train(Rate ~ ., data = data,   
          method = "avNNet", 
          trControl = fitControl,preProc = c("range")
          ,na.action=na.omit) 

tcart=train(Rate ~ ., data = data,   
             method = "treebag", 
             trControl = fitControl,preProc = c("range")
             ,na.action=na.omit) 
