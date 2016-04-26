rm(list = ls())
getwd()

dat = read.csv("exam1P3.csv",header = T)
dat

library(FrF2)
library(pid)


#I=ABCDEF, F=ABECD
VerifyDAT=FrF2(nruns=32,nfactors=6,generators="ABCDE", randomize=FALSE)
VerifyDAT
y=dat[,7]
DAT=add.response(VerifyDAT,y)
DAT


Fitdatagain=lm(y~A+B+C+D+E+F+A*B+A*C+A*D+A*E+A*F+B*C+B*D+B*E+B*F+C*D+C*E+C*F+D*E+D*F+E*F+A*B*C+A*B*D+A*C*D+B*C*D+A*B*E+A*C*E+A*D*E+B*D*E+C*D*E,DAT)
summary(Fitdatagain)


names(Fitdatagain)

contourPlot(Fitdatagain)
#Error here^^

Fitdatagain$model
contourPlot(Fitdatagain$model)
#Error here^^

image(data.matrix(DAT))


