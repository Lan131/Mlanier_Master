rm(list = ls())

library(randomForest)
library(leaps)
library(bestglm)
library(car)


## Classification:
##data(iris)
iris
plot(iris)
set.seed(71)
iris.rf <- randomForest(Species ~ ., data=iris, importance=TRUE,
                        proximity=TRUE)
iris.rf
summary(iris.rf)

## Look at variable importance: (higher is better)
round(importance(iris.rf), 2)
## Do MDS on 1 - proximity:
iris.mds <- cmdscale(1 - iris.rf$proximity, eig=TRUE)
op <- par(pty="s")
pairs(cbind(iris[,1:4], iris.mds$points), cex=0.6, gap=0,
      col=c("red", "green", "blue")[as.numeric(iris$Species)],
      main="Iris Data: Predictors and MDS of Proximity Based on RandomForest")
par(op)
print(iris.mds$GOF)
 
## The `unsupervised' case: (No responce, this looks for clustering)
set.seed(17)
iris.urf <- randomForest(iris[, -5])
MDSplot(iris.urf, iris$Species)
 
## stratified sampling: draw 20, 30, and 20 of the species to grow each tree.
(iris.rf2 <- randomForest(iris[1:4], iris$Species, 
                          sampsize=c(20, 30, 20)))
 
## Regression:
## data(airquality)
airquality
set.seed(131)
ozone.rf <- randomForest(Ozone ~ ., data=airquality, mtry=2,
                         importance=TRUE, na.action=na.omit)
ozone.rf
importance(ozone.rf)
?importance
summary(ozone.rf)
## Show "importance" of variables: higher value mean more important:
round(importance(ozone.rf), 2)

##Variance explained 72.44% 
#Compare to OLS
fit=lm(Ozone ~ .,data=airquality)
summary(fit)
anova(fit)

#Which predictors to use for OLS
leaps=regsubsets(Ozone~., data=airquality, nbest=10)
summary(leaps) ##Use all predictors
subsets(leaps, statistic="rsq") ##Use all predictors

##adj r sq .62


?predict
predict(c(1,1,1,1),ozone.rf)
