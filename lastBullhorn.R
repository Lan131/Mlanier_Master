if (!require('devtools')) install.packages('devtools'); require('devtools')
devtools::install_github(c('droglenc/FSA','droglenc/FSAdata','droglenc/NCStats'))


library(NCStats)
rm(list = ls())  # clear list
March=read.csv("March.csv",header=TRUE)
April=read.csv("April.csv",header=TRUE)
attach(March)
attach(April)

lm.fit=lm(Tickets_Closed~Calls+HT, data = March,weights=(1/(Calls)^2))

summary(lm.fit)
plot(lm.fit)
plot(lm.fit$residuals)
df=as.data.frame(April)
df=df[,-1]
df=df[,-1]
df
# Direct Function ; Bonferroni Procedure
ci.bon=predict(lm.fit,df,interval="prediction",level=(1-.05/2))
New_April=cbind(April,ci.bon)
write.csv(New_April,"New_April.csv")
plot(ci.bon)
help(write.csv)
