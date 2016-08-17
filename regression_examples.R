library(xgboost)
library(caret)
library(dplyr)
library(e1071)
library(neuralnet)



data=as.data.frame(read.csv(file="example_data.csv",header=TRUE))

data2=  data[sample(nrow(data)),]


train=data2[1:80,-2]
test=data2[81:100,-2]

fit=lm(y~x,data=train)
summary(fit)
test_x=data.frame(x=test[,1])
pred=predict(fit,newdata=test_x)
test_y=data.frame(x=test[,2])
ACC=(abs(pred-test_y)/test_y)
sum(ACC)/20
#avg accuracy 20%
matrix(train)
#try xgboost
dtrain=matrix(train)
model <- xgboost(data = data.matrix(as.numeric(train[,1])),
label = train[,2],missing = NA,
                 nrounds = 2, objective = "reg:linear")
#RMSE between 63-67%
model2 <- xgboost(data = data.matrix(as.numeric(train[,1])),
label = train[,2],missing = NA, max.depth = 2,
               eta = 1,
                 nrounds = 2, objective = "reg:linear")
 #RMSE between 58-60%

#grid search

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
returnResamp = "all",     
summaryFunction = defaultSummary,
allowParallel = TRUE
)

x=data.matrix(train[,-2])
y
as.matrix(as.numeric(x))

#find best
best= xgb_train_1 = train(as.matrix(as.numeric(x)),y = as.numeric(train$y),
na.action = na.pass,
metric="RMSE", 
trControl = xgb_trcontrol_1,
tuneGrid = xgb_grid_1,objective = "reg:linear",
method = "xgbTree")


#names(xgb_train_1), examine parameters
xgb_train_1$bestTune

print(xgb_train_1$finalModel)


test_x=data.frame(x=test[,1])
pred=predict(best,data.matrix(test))
test_y=data.frame(x=test[,2])
ACC=(abs(pred-test_y)/test_y)
sum(ACC)/20
#2%better



n <- names(train)

f <- as.formula(paste("y ~", paste(n[!n %in% "y"], collapse = " + ")))

nn <- neuralnet(f,data=train,hidden=c(5,3),linear.output=T)

plot(nn)


library(HarmonicRegression)

fit_har=harmonic.regression(data.matrix(train), train[,1], Tau = 24, normalize = TRUE,
norm.pol = FALSE, norm.pol.degree = 1, trend.eliminate = FALSE,
trend.degree = 1)

plot(fit_har$fit.vals)
plot(train)
ACC=(abs(fit_har$fit.vals[,2]-train[,2])/train[,2])
mean(ACC)
