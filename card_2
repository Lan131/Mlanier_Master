
rm(list = ls())

library(randomForest)
library(miscTools)
library(caret)
library(car)
library(MASS)
library(fmsb)
library(gvlma)
library(stringr)


## Regression: non 
## data(cards)
data_runs=read.csv("Data_.csv",header=TRUE)
id=data_runs[,1]
data_runs=data_runs[,14:16]
data_runs=cbind(id,data_runs)
colnames(data_runs)=c("id","reprint","newest_run","oldest_run")
str(data_runs)
data_runs=data_runs[-1,]
data=read.csv("reserve.csv",header=TRUE)

data=cbind(data[,1],data[,2],data[,10],data[,11],data[,12],data[,13],data[,26],data[,27],data[,28])

colnames(data)=c("id","price","have","wants","velocity","have_foil","trade_price","foil","reserve")

data=merge(as.data.frame(data),as.data.frame(data_runs))
data=data[,-1]

set.seed(139)

data= na.roughfix(data)


cards.lm <- lm(price ~ ., data=as.data.frame(data ))
summary(cards.lm)


save(cards.lm, file = "pretrain_non_foil.RData")



data <- data[sample(1:nrow(data)), ]
data


#plot(cards.lm  )

#crPlots(cards.lm)
# Ceres plots 
#ceresPlots(cards.lm)
#library(gvlma)
#gvmodel <- gvlma(cards.lm) 
#summary(gvmodel)
#linear model not satisfactory

#VIF(cards.lm) # variance inflation factors 
#not an issue

#pretrain on linear model
pred <- predict.lm(cards.lm,as.data.frame(data[,-1]))
datap=cbind(data,pred)




#determine best mtry
tuneRF(datap[,-1], datap[,1], stepFactor=2,  plot=TRUE)

#Random Forest
cardsp.rf <- randomForest(price ~ ., data=datap, mtry=6,
                         importance=TRUE, na.action=na.omit,ntree=200)
                         
                        
cardsp.rf
plot(cardsp.rf$rsq )
#93.25%
save(cardsp.rf, file = "price_algorithm.RData")

round(importance(cardsp.rf), 2)
varImpPlot(cardsp.rf,sort=TRUE)
write.csv(file="Example_data_non_foil.csv",data[,-1], row.names=FALSE)

plot(datap)

#cross validate
cvrsq=0
for(i in 1:5)
{
    n=nrow(datap)
    dat=datap[sample(nrow(datap), .2*n,replace=FALSE), ]
    cardspcv.rf <- randomForest(price ~ ., data=datap, mtry=4,
                         importance=FALSE, na.action=na.omit,ntree=200)

    cvrsq=cardspcv.rf$rsq[200]+cvrsq
}

 cvrsq
paste("CV error rate is ",cvrsq/5)

#Cv Error rate 93.01%

## Regression: foils
## data(cards)
data_runs=read.csv("Data_.csv",header=TRUE)
id=data_runs[,1]
data_runs=data_runs[,14:16]
data_runs=cbind(id,data_runs)
colnames(data_runs)=c("id","reprint","newest_run","oldest_run")
str(data_runs)
data_runs=data_runs[-1,]

data=read.csv("reserve.csv",header=TRUE)
data=cbind(data[,1],data[,3],data[,10],data[,11],data[,12],data[,13],data[,26],data[,27],data[,28])

colnames(data)=c("id","price_foil","have","wants","velocity","have_foil","trade_price","foil","reserve")


data=merge(as.data.frame(data),as.data.frame(data_runs))
data=data[,-1]






set.seed(131)

data= na.roughfix(data)
#remove outliers
data=data[-4365,]
data=data[-4021,]
data=data[-4017,]
data=data[-4014,]
data=data[-4013,]
data=data[-4012,]
data=data[-4011,]
data=data[-3975,]
data=data[-3974,]
data=data[-3972,]
data=data[-3947,]
data=data[-3795,]
data=data[-2682,]
data=data[-2071,]
data=data[-1875,]


cards.lm <- lm(price_foil ~ ., data=as.data.frame(data ))
summary(cards.lm)
plot(cards.lm  )


save(cards.lm, file = "pretrain_foil.RData")


crPlots(cards.lm)
# Ceres plots 
ceresPlots(cards.lm)

gvmodel <- gvlma(cards.lm) 
summary(gvmodel)
#linear model not satisfactory

VIF(cards.lm) # variance inflation factors 
#not an issue

#pretrain on linear model
pred <- predict.lm(cards.lm,as.data.frame(data[,-1]))
datap=cbind(data,pred)




#determine best mtry
tuneRF(datap[,-1], datap[,1], stepFactor=2,  plot=TRUE)

#Random Forest
cardsp.rf <- randomForest(price_foil ~ ., data=datap, mtry=3,
                         importance=TRUE,na.action=na.omit,ntree=200)
                         
                        
cardsp.rf
save(cardsp.rf, file = "price_algorithm_foil.RData")
#98.5%
round(importance(cardsp.rf), 2)
varImpPlot(cardsp.rf,sort=TRUE)




#cross validate
cvrsq=0
for(i in 1:5)
{
    n=nrow(datap)
    dat=datap[sample(nrow(datap), .2*n,replace=FALSE), ]
    cardspcv.rf <- randomForest(price_foil ~ ., data=datap, mtry=3,
                         importance=FALSE, na.action=na.omit,ntree=200)
    cvrsq=cardspcv.rf$rsq[200]+cvrsq
}
paste("CV error rate is ",cvrsq/5)

write.csv(file="Example_data_foil.csv",data[,-1], row.names=FALSE)
