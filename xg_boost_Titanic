#load libraries
require(xgboost)
library(DiagrammeR)
library(Ckmeans.1d.dp)
library(caret)
library(dplyr)





#load data
train=read.csv(file="train.csv",header=TRUE)
test=read.csv(file="test.csv",header=TRUE)
train[,1]=as.numeric(train[,1])
train[,1]
train<-na.omit(train)
#create 1st model 
model <- xgboost(data = data.matrix(train[,-1]), label = train[,1],missing = NA,
                 nrounds = 2, objective = "binary:logistic")
                 
cv.res <- xgb.cv(data = data.matrix(train[,-1]), label = train[,1], nfold = 10,missing = NA,
                 nrounds = 10, objective = "binary:logistic")
                 
                 
#custom objective
loglossobj <- function(preds, dtrain) {
  # dtrain is the internal format of the training data
  # We extract the labels from the training data
  labels <- getinfo(dtrain, "label")
  # We compute the 1st and 2nd gradient, as grad and hess
  preds <- 1/(1 + exp(-preds))
  grad <- preds - labels
  hess <- preds * (1 - preds)
  # Return the result as a list
  return(list(grad = grad, hess = hess))
}


#cross validate
model <- xgboost(data = data.matrix(train[,-1]), label = train[,1],missing = NA,
                 nrounds = 2, objective = loglossobj, eval_metric = "error",verbose=1)
                 
bst <- xgb.cv(data = data.matrix(train[,-1]),label = train[,1],missing = NA,nfold=10,
              nrounds = 20, objective = "binary:logistic",
              early.stop.round = 3, maximize = FALSE)
              
             
#two tree graph 
bst <- xgboost(data =  data.matrix(train[,-1]),  label = train[,1], max.depth = 2,missing = NA,
               eta = 1, nthread = 2, nround = 2, objective = "binary:logistic")
xgb.plot.tree(feature_names = colnames(train[,-1]), model = bst)

#importance matrix
bst <- xgboost(data = data.matrix(train[-1]),  label = train[,1], max.depth = 2,
               eta = 1, nround = 2,objective = "binary:logistic")
importance_matrix <- xgb.importance(colnames(train[,-2]), model = bst)
xgb.plot.importance(importance_matrix)

#ensambled tree graph


bst <- xgboost(data = data.matrix(train[,-1]),label = train[,1], max.depth = 15,missing = NA,
                 eta = 1, nthread = 2, nround = 30, objective = "binary:logistic",
                 min_child_weight = 50)
xgb.plot.multi.trees(model = bst, feature_names = colnames(train[,-1]), features.keep = 3)



#set up Grid Serch for hyperparams in xgboost
# set up the cross-validated hyper-parameter search
xgb_grid_1 = expand.grid(
nrounds = 100,
eta = c(0.01, 0.001, 0.0001),
max_depth = c(2, 4, 6, 8, 10),
  gamma = c(0,1) ,              
  colsample_bytree = c(1,5) ,   
  min_child_weight = c(1,50)  
)
 
# pack the training control parameters
xgb_trcontrol_1 = trainControl(
method = "cv",
number = 10,
verboseIter = TRUE,
returnData = FALSE,
returnResamp = "all",                      # save losses across all models
classProbs = TRUE,                         # set to TRUE for AUC to be computed
summaryFunction = twoClassSummary,
allowParallel = TRUE
)


x=data.matrix(train[,-1])

y =  is.factor(train[,1])
# train the model for each parameter combination in the grid,
# using CV to evaluate


#Perform grid search
best= xgb_train_1 = train(as.data.frame(x),y = make.names(train$Survived),
na.action = na.pass,
metric = "ROC",
trControl = xgb_trcontrol_1,
tuneGrid = xgb_grid_1,objective = "binary:logistic",
method = "xgbTree")

#names(xgb_train_1), examine parameters
xgb_train_1$bestTune

print(xgb_train_1$finalModel)

# scatter plot of the AUC against max_depth and eta
ggplot(xgb_train_1$results, aes(x = as.factor(eta), y = max_depth, size = ROC, color = ROC)) +
geom_point() +
theme_bw() +
scale_size_continuous(guide = "none")

#make predictions
test=read.csv(file="test.csv",header=TRUE)
test=test[,-1] #remove id collumn,Not removing row id will result in terrible preformance
 
submission.pred <- predict(best,data.matrix(test))
submission.pred
write.csv(submission.pred,"submit_xgboost.csv")
#use Excel to conditionally format X0 -> 0, X1->1
