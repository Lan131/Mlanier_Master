rm(list = ls())
getwd()
library(car)
set.seed(131)
library(randomForest)
dat=read.csv(file="Test.csv", header=TRUE)
dat
x1=dat[,1]
x2=dat[,2]
x3=dat[,3]
y=dat[,4]
OLS=lm(Y~X1 + X2 +X3 ,data=dat)
summary(OLS)


#Try Random Forest
set.seed(131)
RF=randomForest(y ~ x1 + x2 +x3,
  data=airquality, mtry=2,importance=TRUE, na.action=na.omit)
RF

plot(dat)
crPlots(OLS)
ceresPlots(OLS)
plot(RF)
pred=predict(RF,dat)
pedlm=predict.lm(OLS,dat)
plot(x1,pred,col="blue",ylim=c(0, 80),ylab="Responce")
par(new=TRUE)
plot(x1,y,col="red",ylim=c(0, 80),axis=FALSE,ylab="Responce")
par(new=TRUE)
plot(x1,pedlm,col="yellow",ylim=c(0, 80),axis=FALSE,ylab="Responce")
text(x1, pred, "RF", cex=0.6, pos=4, col="blue")
text(x1, pedlm, "OLS", cex=0.6, pos=4, col="yellow")
title(main="OLS vs Random Forest in Patient Satisfaction Data", sub="Michael Lanier")
