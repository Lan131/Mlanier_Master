rm(list = ls())
library(randomForest)

options(scipen = 10)
Synthetic_Data=rbeta(10000,.234,4.61)*961
Synthetic_Data
mean(Synthetic_Data)
plot(Synthetic_Data)

##Find quantiles

for(i in 1:100)
{
  if(i==1)
  {Q=quantile(Synthetic_Data,.01)}
  
  Q=rbind(Q,quantile(Synthetic_Data,i/100))
if(i==100)
{print(Q)
  plot(Q)}
}
length(Q)
lines(seq(1,101, by=1),Q)
mean(Q)
Q[95]/60
Q[80]/60

Synthetic_Data_inf=rbeta(100000,.234,4.61)*961

quantile(Synthetic_Data_inf,.80) #80th precentile
quantile(Synthetic_Data_inf,.95) #95th precentile

#Using out synthetic data we will simulate a years worth of call data
for(i in 1:52)
{ 
    if(i==1)
      {
          wk=sample(Synthetic_Data,5)
          ASA=mean(wk)
          stdev=var(wk)^.5
          q= quantile(Synthetic_Data,.95)
          SNR=log(ASA/stdev)
      }
      if(i>1) 
        {
          wk=rbind(wk,sample(Synthetic_Data,5))
          ASA=rbind(ASA,mean(wk[i,]))
          stdev=rbind(stdev,var(wk[i,])^.5)
          q=rbind(q,quantile(wk[i,],.95))
          
          
      }
  
}

#We wish to see if optimizing SNR is identical to dually optimizing ASA and 95th precentile.
SNR=log(ASA/stdev)

goal=cbind(ASA,q,SNR)

#write.csv(goal,file="goal.csv")
goal=read.csv("goal.csv")
fit=lm(SNR~ASA+q,data=goal)
summary(fit)
plot(fit)


#normality violation using least squares
#Try random forest algorithm


set.seed(17)

SNR.rf=randomForest(SNR~ASA+q,importance=TRUE,data=goal, mtry=2)
SNR.rf
plot(SNR.rf)
importance(SNR.rf)
predict(SNR.rf)



