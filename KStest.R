rm(list = ls())
getwd()
Csat = read.table("CSAT.txt",header=F)
Csat
CS=Csat[,1]
length(CS)
CS=sort(CS)
CS
hist(CS)
mean=mean(CS)
mean

First=head(CS,length(CS)/2)
First
Last=tail(CS,length(CS)/2)
Last


Firstm=mean-First
Lastm=Last-mean
Lastm
hist(Firstm)

ks.test(Firstm,Lastm,alternative = "two.sided")