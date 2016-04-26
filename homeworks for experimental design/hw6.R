####
rm(list = ls())

#6.11a
library(rsm)
dat=read.table("dat611.txt")
d1=dat[,1]
d2=dat[,2]
d3=dat[,3]
y=dat[,4]
d1
colnames(dat)=c("x1","x2","x3","y")
des_6.11 = as.coded.data(dat, x1 ~ (Time - (max(d1)+min(d1))/2)/((max(d1)-min(d1))/2), 
                        x2 ~ (Temp - (max(d2)+min(d2))/2)/((max(d2)-min(d2))/2), 
                        x3 ~ (Nickle - (max(d3)+min(d3))/2)/((max(d3)-min(d3))/2))


print(des_6.11, decode = FALSE)
print(des_6.11, decode = TRUE)

fit=rsm(y~SO(x1,x2,x3),data=des_6.11)
summary(fit)
#TWI insignificent

#6.12c

fitnest=rsm(y~FO(x1,x2,x3)+PQ(x1,x2,x3),data=des_6.11)

summary(fitnest)

#Ridge, contour plots will not help in locating max.

canonical.path(fitnest)
dat[14,]

#We want to run at high levels or time and tempature to maximize thickness. Specificlly in the design space about 12,24,14.

predict.6.11 = predict(fitnest,fitnest$canonical$xs, se.fit = TRUE)
predict.6.11

#SE at optimum 10.74


#6.15
dat615=read.table("dat615.txt")
dat615
colnames(dat615)=c("x1","x2","x3","y1","y2")
fit=rsm(y1~SO(x1,x2,x3),data=dat615)
summary(fit)

fitnest=rsm(y1~FO(x1,x2,x3)+TWI(x1,x2,x3),data=dat615)
summary(fitnest)


par(mfrow = c(3,3)) # plot of 2x2 panels 
contour(fitnest, ~ x3 + x2, image=TRUE, at =  data.frame(x1 = 0, x3 = 0, x1 = 0))
contour(fitnest, ~ x3 + x2, image=TRUE, at =  data.frame(x1 = 0, x3 = 0, x1 = 0, main = " at 0"))
contour(fitnest, ~ x3 + x2, image=TRUE, at =  data.frame(x1 = 0, x3 = 0, x1 = 0, main = " at 0"))
contour(fitnest, ~ x1 + x2, image=TRUE, at =  data.frame(x1 = 0, x2 = 0, x3 = 0, main = " at 0"))
contour(fitnest, ~ x1 + x2, image=TRUE, at =  data.frame(x1 = 0, x2 = 0, x3 = 0, main = " at 0"))
contour(fitnest, ~ x1 + x2, image=TRUE, at =  data.frame(x1 = 0, x2 = 0, x3 = 0, main = " at 0"))
contour(fitnest, ~ x3 + x1, image=TRUE, at =  data.frame(x1 = 0, x3 = 0, x2 = 0, main = " at 0"))
contour(fitnest, ~ x3 + x1, image=TRUE, at =  data.frame(x1 = 0, x3 = 0, x2 = (0, main = " at 0"))
contour(fitnest, ~ x3 + x1, image=TRUE, at =  data.frame(x1 = 0, x3 = 0, x2 = (0, main = " at 0"))

#Pairwise Low x3 and high x2 as well as high x1 high x2, high x3 and high x1 all produce high response values.

summary(fitnest)
canonical(fitnest)$xs
#The stationary point is  
canonical(fitnest)$xs

#This surface has a saddle point.


#6.13
dat1=read.table("mydata3.txt")
dat2=read.table("mydata2.txt")
dat3=read.table("dat611.txt")
testpt=read.table("testpts.txt")
colnames(dat1)=c("x1","x2","x3","y")
colnames(dat2)=c("x1","x2","x3","y")
colnames(dat3)=c("x1","x2","x3","y")

fit1=rsm(y~SO(x1,x2,x3),data=dat1)
fit2=rsm(y~SO(x1,x2,x3),data=dat2)
fit3=rsm(y~SO(x1,x2,x3),data=dat3)
par(mfrow = c(3,2)) # plot of 2x2 panels 

varfcn(dat1, fit1,main="SPV model 1")
varfcn(dat2, fit1,main="SPV model 2")
varfcn(dat3, fit1,main="SPV model 3")


A=varfcn(dat1, fit1,vectors=testpt, plot=FALSE)
as.data.frame(A)
A[18,] #-1,-1,-1
A[39,] #-1,1,1
A[59,] #-1,1,-1

#They are all identiclly 4.7528.
B=varfcn(dat2, fit2,vectors=testpt, plot=FALSE)
as.data.frame(B)
#They are all identiclly 3.8634.

C=varfcn(dat3, fit3,vectors=testpt, plot=FALSE)
as.data.frame(C)
#They are all identiclly 8.649

#The best design in terms of SPV is the second design which is the CCD design.