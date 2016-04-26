rm(list = ls())
setwd("C:\\Users\\m.lanier\\Desktop",)
install.packages("randomForest", repos='http://cran.us.r-project.org')
library(randomForest)




dat <- read.table(file="abalone.txt",sep=",")
dat
y=dat[,9]
for(i in 1:8)
{
 	nam=paste("X",i,sep="")
	assign(nam,dat[,i])
       
}







#Try Random Forest
set.seed(131)
RF=randomForest(y ~ .,
  data=dat, mtry=2,importance=TRUE, na.action=na.omit)


R=as.data.frame(RF$importance)
R


plot(RF)
