library(randomForest)
library(caret)
library(xgboost)


data=read.csv("titanic.csv")
data=na.roughfix(data)


tc=trainControl(method="cv",number=5,search="random")

xgb=train(as.factor(Survived)~as.factor(Pclass)+as.factor(Sex)+Age+SibSp+Fare+as.factor(Embarked),data=data,method="xgbTree",
          na.action=na.omit,metric = "AUC",
          trControl=tc,preProc=c('center','scale'),tuneLength=15)

xgb$results
confusionMatrix(data=predict(xgb,data),reference=data$Survived)
