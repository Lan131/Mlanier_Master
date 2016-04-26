rm(list = ls())  # clear list
### Check the working directory
getwd()
### Change the working directory to 
### to where toluca.txt is located
### Load the data in R




library(xlsx) 
getwd()
#Pull in order bbo,maxhire, sendouts, tech support



b1= read.csv("Hours Worked.csv")
b1=cbind("6/8",b1)
b1
b2=read.csv("Hours Worked (1).csv") 
b2
b2=cbind("6/8",b2)
b3=read.csv("Hours Worked (2).csv")
b3
b3=cbind("6/8",b3)
b4=read.csv("Hours Worked (3).csv")
b4
b4=cbind("6/8",b4)
Monday=rbind(b1,b2,b3,b4)
Monday
date=Monday[1,1]
date
sumofavailM=sum(Monday[,6])
sumofassignM=sum(Monday[,7])
BreaksumM=sum(Monday[,8])
sumnoncallM=sum(Monday[,9])
sumnegexwM=sum(Monday[,10])
sumnegexnwM=sum(Monday[,11])
sumexehourswM=sum(Monday[,12])

newrowMonday=c(6.8,sumofavailM,sumofassignM,BreaksumM,sumnoncallM,sumnegexwM,sumnegexnwM,sumexehourswM)
newrowMonday


b5=read.csv("Hours Worked (4).csv")
b5
b5=cbind("6/9",b5)
b6=read.csv("Hours Worked (5).csv")
b6
b6=cbind("6/9",b6)
b7=read.csv("Hours Worked (6).csv")
b7
b7=cbind("6/9",b7)
b8=read.csv("Hours Worked (7).csv")
b8
b8=cbind("6/9",b8)
Tuesday=rbind(b5,b6,b7,b8)
date=Tuesday[1,1]
date
sumofavailT=sum(Tuesday[,6])        
sumofassignT=sum(Tuesday[,7])
BreaksumT=sum(Tuesday[,8])
sumnoncallT=sum(Tuesday[,9])
sumnegexwT=sum(Tuesday[,10])
sumnegexnwT=sum(Tuesday[,11])
sumexehourswT=sum(Tuesday[,12])



Tuesday
newrowTuesday=c(6.9,sumofavailT,sumofassignT,BreaksumT,sumnoncallT,sumnegexwT,sumnegexnwT,sumexehourswT)

newrowTuesday


b9=read.csv("Hours Worked (8).csv")
b9
b9=cbind("6/10",b9)
b10=read.csv("Hours Worked (9).csv")
b10
b10=cbind("6/10",b10)
b11=read.csv("Hours Worked (10).csv")
b11
b11=cbind("6/10",b11)
b12=read.csv("Hours Worked (11).csv")
b12
b12=cbind("6/10",b12)
Wednesday=rbind(b9,b10,b11,b12)
date=Wednesday[1,1]
date
sumofavailW=sum(Wednesday[,6])        
sumofassignW=sum(Wednesday[,7])
BreaksumW=sum(Wednesday[,8])
sumnoncallW=sum(Wednesday[,9])
sumnegexwW=sum(Wednesday[,10])
sumnegexnwW=sum(Wednesday[,11])
sumexehourswW=sum(Wednesday[,12])




newrowWednesday=c(6.10,sumofavailW,sumofassignW,BreaksumW,sumnoncallW,sumnegexwW,sumnegexnwW,sumexehourswW)
newrowWednesday






b13=read.csv("Hours Worked (12).csv")
b13
b13=cbind("6/11",b13)
b14=read.csv("Hours Worked (13).csv")
b14
b14=cbind("6/11",b14)
b15=read.csv("Hours Worked (14).csv")
b15
b15=cbind("6/11",b15)
b16=read.csv("Hours Worked (15).csv")
b16
b16=cbind("6/11",b16)

Thursday=rbind(b13,b14,b15,b16)

date=Thursday[1,1]
date
sumofavailTR=sum(Thursday[,6])        
sumofassignTR=sum(Thursday[,7])
BreaksumTR=sum(Thursday[,8])
sumnoncallTR=sum(Thursday[,9])
sumnegexwTR=sum(Thursday[,10])
sumnegexnwTR=sum(Thursday[,11])
sumexehourswTR=sum(Thursday[,12])




newrowThursday=c(6.11,sumofavailTR,sumofassignTR,BreaksumTR,sumnoncallTR,sumnegexwTR,sumnegexnwTR,sumexehourswTR)
newrowThursday



b17=read.csv("Hours Worked (16).csv")
b17
b17=cbind("6/12",b17)
b18=read.csv("Hours Worked (17).csv")
b18
b18=cbind("6/12",b18)
b19=read.csv("Hours Worked (18).csv")
b19
b19=cbind("6/12",b19)
b20=read.csv("Hours Worked (19).csv")
b20
b20=cbind("6/12",b20)
Friday=rbind(b17,b18,b19,b20)
Friday


date=Friday[1,1]
date
sumofavailF=sum(Friday[,6])        
sumofassignF=sum(Friday[,7])
BreaksumF=sum(Friday[,8])
sumnoncallF=sum(Friday[,9])
sumnegexwF=sum(Friday[,10])
sumnegexnwF=sum(Friday[,11])
sumexehourswF=sum(Friday[,12])



newrowFriday=c(6.12,sumofavailF,sumofassignF,BreaksumF,sumnoncallF,sumnegexwF,sumnegexnwF,sumexehourswF)
newrowFriday
names(To_be_added)=c("Sum of availble hours","Sum of assigned hours","Sum of break hours","Sum of non call hours","Sum of negative exceptions worked","Sum of negative exceptions non working","exceptions hours worked") 



To_be_added=rbind(newrowMonday,newrowTuesday,newrowWednesday,newrowThursday,newrowFriday)
numemploy=c(nrow(Monday),nrow(Tuesday),nrow(Wednesday),nrow(Thursday),nrow(Friday))
numemploy
To_be_added

sum_positive_ex=c(0,0,0,0,0)
To_be_added=cbind(To_be_added,sum_positive_ex)
To_be_added=cbind(To_be_added,numemploy)
To_be_added

library(rJava)                  # load rJava first 
library(data.table)             # then data.table 
rJava::J("java.lang.Double")

write.xlsx(To_be_added, "E:/To_be_added.xlsx",sheetName="Sheet 1")

