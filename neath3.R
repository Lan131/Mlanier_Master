rm(list = ls())
getwd()
dat=read.csv(file='Datatest.csv', header=TRUE)
dat
names(dat)=c("X1","X2","X3","Y")
fit=lm(Y~X1+X2+X3,data=dat)

new=data.frame(X1=46,X2=45,X3=2)
predict.lm(fit, new, interval="confidence",level=.95)


new=data.frame(X1=46,X2=45,X3=2)
predict.lm(fit, new, interval="prediction",level=.95)
