rm(list = ls())
library(e1071)
dat=read.csv("train_prepro.csv",header=TRUE)
dat2=read.csv("test_prepro.csv",header=TRUE)
str(dat)
dat$Survived=as.factor(dat$Survived)
dat$Pclass=as.factor(dat$Pclass)
dat$Sex=as.factor(dat$Sex)
dat$SibSp=as.factor(dat$SibSp)

dat$Embarked=as.factor(dat$Embarked)

dat2$Pclass=as.factor(dat2$Pclass)
dat2$Sex=as.factor(dat2$Sex)
dat2$SibSp=as.factor(dat2$SibSp)

dat2$Embarked=as.factor(dat2$Embarked)
## tune `svm' for classification with RBF-kernel (default in svm),
## using one split for training/validation set
obj <- tune(svm, Survived ~.,
            data = dat,
            ranges = list(gamma = 2^(-2:2), cost = 2^(1:5),epsilon =2^(0:2)),
            tunecontrol = tune.control(sampling = "cross",best.model=TRUE)
)

obj$best.model
pred=predict(obj$best.model,newdata=dat2)

write.csv(pred,file="SCV_result.csv")
summary(obj)
plot(summary(obj))
attach(dat)

#tune.svm(x=- subset(dat, select = -Survived), y=Survived, data = dat, gamma = 2^(-2:2), 
  #       cost = 2^(1:5),epsilon =2^(0:2))
#best.svm(x, tunecontrol = tune.control(), ...)
