library(randomForest)
library(caret)
library(xgboost)
library(AzureML)

data=read.csv("titanic.csv")
data=na.roughfix(data)

data$Survived[data$Survived==1] <- "yes"
data$Survived[data$Survived==0] <- "no"
tc=trainControl(method="cv",number=5,search="random",classProbs = TRUE)

#ga_ctrl <- gafsControl(functions = rfGA,
#                       method = "repeatedcv",
#                       repeats = 5)
#rf_ga <- gafs(x = as.data.frame(cbind(as.factor(data$Pclass),
#                    as.factor(data$Sex),data$Age,data$SibSp,data$Fare,as.factor(as.factor(data$Embarked)))),
#              y = as.factor(data$Survived),
#              iters = 5,
#              gafsControl = ga_ctrl)
new=data[,-c(1,2,4,9,11,8)]
xgb=train(Survived~as.factor(Pclass)+as.factor(Sex)+Age+SibSp+Fare+as.factor(Embarked),data=data,method="xgbTree",
          na.action=na.omit,metric = "kappa",
          trControl=tc,preProc=c('center','scale'),tuneLength=2)
predict(newdata=new,object=xgb)

myID = "44c0e3ce99f545f1848919d25e7639d"
myAuth= "0d86dea367a64c298f60aa8587c5eb8"

XGB_function=function(data)
  
{
  return(predict(newdata=new,object=xgb))
  
}
  
ws <- workspace(id=myID,auth=myAuth)


firstWebService = publishWebService(
  ws,
  "xgbOnline",
  list("Pclass" = "string", "Sex" = "string", "Age" = "float","SibSp" = "string", "Fare" = "float",
       "Embarked" = "string" ),
  myID,
  myAuth
)
  
