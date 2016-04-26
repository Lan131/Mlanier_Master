rm(list = ls())
library(MASS)
library(FrF2)
library(DoE.wrapper)
library(rsm)
library(faraway)
library(pid)
library(car)
library(gplots)

des=ccd.design(nfactors=2,default.levels=c(-1,1),ncenter=4, alpha=2, blocks= 1,
               randomize=FALSE,nruns=16,seed=c(4,2),replications=1)
des

y=c(65,53,79,55,67,59,96,50,90,33,55,68,70,85,63,99)

desy=cbind(des,y)
desy





fitd2=lm(y~X1+X2,data=desy)
summary(fitd2)


par(mfrow = c(1, 2))

#main effect X1
plotmeans(y~desy$X1,xlab="Factor Salt",ylab="Time to Nucleation", p=.68, main="Main
 effect Plot Salt",barcol="black") 

#main effect X2
plotmeans(y~desy$X2,xlab="Factor Sugar",ylab="Time to Nucleation", p=.68, main="Main
 effect Plot Sugar",barcol="black")


#interaction.plot(desy$X1, desy$X2, y, type="b", main="Interaction Plot Salt and Sugar", xlab="Interaction Level", ylab="Response", trace.lab="Interaction Level", pch=20,
#fixed=F,legend = FALSE) 


plot()

interaction.plot(desy$X1, desy$X2, y, type="b", col=c(1:3), 
  	leg.bty="l", leg.bg="beige", lwd=2, pch=c(18,24,22),	
   xlab="Dosage of Salt", 
   ylab="Seconds to nucleation", 
   main="Interaction Plot")

abline(fitd)


fitall=rsm(y~FO(X1,X2)+TWI(X1,X2)+SO(X1,X2),data=desy)
fitall
summary(fitall)
anova(fitall)
plot(fitall)


fits=rsm(y~SO(X1,X2),data=desy)
fits
summary(fits)
anova(fits)

fiti=rsm(y~FO(X1,X2)+TWI(X1,X2),data=desy)
fiti
summary(fiti)
anova(fiti)
plot(fiti)


fitf=rsm(y~FO(X1,X2),data=desy)
fitf
summary(fitf)
anova(rsm(y~FO(X1,X2),data=desy))

plot(fitf)

ncvTest(fitf) 

BIC(fitall) #Full model
BIC(fits) #Second order model
BIC(fiti) # first order with interaction
BIC(fitf) #First order

#Lower BIC is better

#pick first order


effects = coef(fitf)[-1]*2
es = round(effects, digits = 2)
es

contourPlot(fit1, xlim = c(-2.2,2.2),ylim = c(-2.2,2.2))
contourPlot(fitd2, xlim = c(-2.2,2.2),ylim = c(-2.2,2.2))





par(mfrow = c(1, 1))
qqnorm(es)
qqline(es)
halfnorm(coef(fitf)[-1]*2,pch=20, main="Half norm plot")


n = nrow(desy)
x = desy[,1]
y = desy[,3]

resi = fitf$resi
resi
rank.k = rank(resi)
mse = sum(resi^2)/(n-2)
p = (rank.k - 0.375)/(n+0.25)
exp.resi = sqrt(mse)*qnorm(p)
cbind(resi,exp.resi)
cor(resi,exp.resi)

