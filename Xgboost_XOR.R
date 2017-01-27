library(randomForest)
library(caret)
library(xgboost)


data=read.csv("titanic.csv")
data=na.roughfix(data)

data$Survived[data$Survived==1] <- "yes"
data$Survived[data$Survived==0] <- "no"
tc=trainControl(method="cv",number=5,search="random",classProbs = TRUE)

xgb=train(Survived~as.factor(Pclass)+as.factor(Sex)+Age+SibSp+Fare+as.factor(Embarked),data=data,method="xgbTree",
          na.action=na.omit,metric = "kappa",
          trControl=tc,preProc=c('center','scale'),tuneLength=2)

xgb$results
confusionMatrix(data=predict(xgb,data),reference=data$Survived)
multiClassSummary(xgb)
