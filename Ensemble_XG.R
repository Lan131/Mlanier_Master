
setwd("C:\\Users\\Lanier\\Desktop\\kaggle\\Houses")
library(caret)
library(randomForest)
library(RCurl)
library(darch)
library(e1071)




dat=read.csv("train.csv",header=T)
test=read.csv("test.csv",header=T)

SalePrice=dat[,81]
combined=rbind(dat[,-81],test)
combined <- data.frame(lapply(combined, as.character), stringsAsFactors=TRUE)
combined <- data.frame(lapply(combined, as.numeric))
combined=na.roughfix(combined)

dat=cbind(combined[1:1460,],SalePrice)
test=combined[1460:nrow(combined),]

nzv <- nearZeroVar(dat)
dat=dat[,-nzv]
dat=dat[,-1]
test=test[,-1]
test=test[,-nzv]


descrCor <-  cor(dat)
highlyCorDescr <- findCorrelation(descrCor, cutoff = .75)
dat <- dat[,-highlyCorDescr]
test <- test[,-highlyCorDescr]
descrCor2 <- cor(dat)
summary(descrCor2[upper.tri(descrCor2)])

#lmse=function(data,lev=NULL, model=NULL)
#  {
#     out=log(mean(data$SalePrice-data$pred))
#     out
  
#  }


fitControl <- trainControl(## 5-fold CV
  method = "cv",
  number = 3,
  search = "random"#,summaryFunction=lmse
)


fitControl2 <- trainControl(## 5-fold CV
  method = "cv",
  number = 3
)

xgbFit1 <- train(SalePrice ~ ., data = dat, #metric="lmse",maximize = FALSE,
                 method = "xgbTree", 
                 trControl = fitControl,preProc = c("center", "scale"),tuneLength = 10
                 ,na.action=na.omit)       #.85


pcaNetFit1 <- train(SalePrice ~ ., data = dat, 
                 method = "pcaNNet", 
                 trControl = fitControl,preProc = c("center", "scale"),tuneLength = 10
                 ,na.action=na.omit)             #.40

bayesFit1 <- train(SalePrice ~ ., data = dat, 
                                       method = "bayesglm", 
                                       trControl = fitControl,preProc = c("center", "scale"),tuneLength = 10
                                       ,na.action=na.omit) #.75


cart <-  train(SalePrice ~ ., data = dat,   
               method = "rpart", 
               trControl = fitControl2,preProc = c("center", "scale")
               ,na.action=na.omit)               #.43


glm <-  train(SalePrice ~ ., data = dat,   
               method = "glmStepAIC", 
               trControl = fitControl2,preProc = c("center", "scale")
               ,na.action=na.omit)               #.76



nnet <- train(SalePrice ~ ., data = dat,   
              method = "avNNet", 
              trControl = fitControl2,preProc = c("center", "scale")
              ,na.action=na.omit)     



#Use XgBoost, glm, bayes



set.seed(1234)
dat <- dat[sample(nrow(dat)),]
split <- floor(nrow(dat)/3)
ensembleData <- dat[0:split,]
blenderData <- dat[(split+1):(split*2),]
testingData <- dat[(split*2+1):nrow(dat),]





labelName <- 'SalePrice'
predictors <- names(ensembleData)[names(ensembleData) != labelName]


model_xgb <- train(ensembleData[,predictors], ensembleData[,labelName], method='xgbTree', trControl=myControl)

model_glm <- train(ensembleData[,predictors], ensembleData[,labelName], method='glmStepAIC', trControl=myControl)

model_bayes <- train(ensembleData[,predictors], ensembleData[,labelName], method='bayesglm', trControl=myControl)
summary(model_bayes)


blenderData$xgb_PROB <- predict(object=model_xgb, blenderData[,predictors])
blenderData$glm_PROB <- predict(object=model_glm, blenderData[,predictors])
blenderData$bayes_PROB <- predict(object=model_bayes, blenderData[,predictors])

testingData$xgb_PROB <- predict(object=model_xgb, testingData[,predictors])
testingData$glm_PROB <- predict(object=model_glm, testingData[,predictors])
testingData$bayes_PROB <- predict(object=model_bayes, testingData[,predictors])



predictors <- names(blenderData)[names(blenderData) != labelName]
final_blender_model <- train(blenderData[,predictors], blenderData[,labelName], method='xgbLinear', trControl=myControl)



preds <- predict(object=final_blender_model, test)
submit=read.csv("sample_submission.csv")
Submit=cbind(submit[,1],preds)
colnames(Submit)=c("Id","SalePrice")

write.csv(Submit,"Submission.csv",row.names=FALSE)

