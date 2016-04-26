rm(list = ls())
getwd()


library(FrF2)

y1=c(94.2,124.2,142.6,126.4,96,118.8,71.8,198.6)
y2=c(151.4,127.4,103,124.8,67.4,148.2,118,152.4)
y3=c(144.8,123.2,111.8,123.4,104.8,135.6,67.4,165)
y4=c(116.2,125.2,125,127.4,120.2,152.4,60.4,139.8)
y5=c(177.8,122.8,151.4,123.4,120.2,215.4,102.6,223.8)

Y=rbind(y1,y2,y3,y4,y5)
Y

#write.csv(Y, file = "MyData1.csv")
#des=add.response(desi,y)

DATA=read.csv(file="MyexamData.csv")
DATA
ybar=DATA[,6]
lns=DATA[,7]
lnybars=DATA[,8]
logmeanerror=DATA[,9]

des=FrF2(nruns=8,nfactors=5,randomize=FALSE)

desstat1=add.response(des,ybar)
desstat1

desstat2=add.response(des,lns)
desstat2

desstat3=add.response(des,lnybars)
desstat3

desstat4=add.response(des,logmeanerror)
desstat4

fit1=lm(ybar~A*B*C,desstat1) 
fit2=lm(lns~A*B*C,desstat2) 
fit3=lm(lnybars~A*B*C,desstat3) 
fit4=lm(logmeanerror~A*B*C,desstat4) 
summary(fit1)
summary(fit2)
summary(fit3)
summary(fit4)

eff.size1 = coef(fit1)[-1]*2
eff.size2 = coef(fit2)[-1]*2
eff.size3 = coef(fit3)[-1]*2
eff.size4 = coef(fit4)[-1]*2

eff.size1 

eff.size2

eff.size3 

eff.size4 

DanielPlot(fit1)
DanielPlot(fit2)
DanielPlot(fit3)
DanielPlot(fit4)

#The log of the mean square error (option 4) is the best. A process mean close to 125 and low varience minimize the responce surface and allow 
#for a dual optimization. In this case it looks like we can jointly minimize the variance and the error from our
# target mean of 125 by increasing Aor ABC or decreasing B, C, AB, or BC.
summary(fit4)




library(plyr) # load this package to use the mapvalues function

## Be sure that you change the working directory to where to saved your data.
dat = read.csv("exam1P3.csv",header = T)
dat
names(dat)

dat$A = mapvalues(dat$volume, from = c(3,5), to = c(-1,1))
dat$B = mapvalues(dat$batch, from = c(1,2), to = c(-1,1))
dat$C = mapvalues(dat$time, from = c(6,14), to = c(-1,1))
dat$D = mapvalues(dat$speed, from = c(6650,7350), to = c(-1,1))
dat$E = mapvalues(dat$acc, from = c(5,20), to = c(-1,1))
dat$F = mapvalues(dat$cover, from = c('Off','On'), to = c(-1,1))

dat # check
## type code from here
#Verify 2 to the 6-1 design
all(dat$F == dat$A*dat$B*dat$C*dat$D*dat$E)

#I=ABCDEF, F=ABECD
VerifyDAT=FrF2(nruns=32,nfactors=6,generators="ABCDE", randomize=FALSE)
VerifyDAT
design.info(VerifyDAT)
y=dat[,7]
DAT=add.response(VerifyDAT,y)
DAT
MEPlot(DAT)
IAPlot(DAT)
#Estimate main effects and two way effects

Fitdat=lm(y~A+B+C+D+E+F+A*B+A*C+A*D+A*E+A*F+B*C+B*D+B*E+B*F+C*D+C*E+C*F+D*E+D*F+E*F,DAT)
summary(Fitdat)
DanielPlot(DAT)
eff_fr0 = coef(Fitdat)[-1]*2
eff_fr0

#Estimate main effects and two way effects and three way

Fitdatagain=lm(y~A*B*C*D*E*F,DAT)
summary(Fitdatagain)

Fitdatagain=lm(y~A+B+C+D+E+F+A*B+A*C+A*D+A*E+A*F+B*C+B*D+B*E+B*F+C*D+C*E+C*F+D*E+D*F+E*F+A*B*C+A*B*D+A*C*D+B*C*D+A*B*E+A*C*E+A*D*E+B*D*E+C*D*E,DAT)
summary(Fitdatagain)
DanielPlot(DAT)





BIC(Fitdat)


BIC(Fitdatagain)