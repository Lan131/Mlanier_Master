rm(list = ls())
getwd

library(MASS)
library(car)
library(lmSupport)

##Load data
abalone=read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/abalone/abalone.data", header=F, sep=",")
abalone


##Names
##    Sex		      nominal		M, F, and I (infant)
##	Length		continuous	mm	Longest shell measurement
##	Diameter	      continuous	mm	perpendicular to length
##	Height		continuous	mm	with meat in shell
##	Whole weight	continuous	grams	whole abalone
##	Shucked weight	continuous	grams	weight of meat
##	Viscera weight	continuous	grams	gut weight (after bleeding)
##	Shell weight	continuous	grams	after being dried
##	Rings		      integer           +1.5 gives the age in years




colnames(abalone)=c('sex','length','diameter','height','wholeweight','shuckedweight','visceraweight','shellweight','rings')
pairs(abalone)
Y=abalone[,9]
X1=abalone[,1]
X2=abalone[,2]
X3=abalone[,3]
X4=abalone[,4]
X5=abalone[,5]
X6=abalone[,6]
X7=abalone[,7]
X8=abalone[,8]




##Fit model
fit=lm(Y~factor(X1)+X2+X3+X4+X5+X6+X7+X8)
summary(fit)
plot(fit)
##Adj rsq= .53
simplelinear= BIC(fit)
##BIC=18499
##Check constant error assumption
plot(fit$fitted, fit$residuals)
ncvTest(fit)
qqnorm(fit$resi)
##Not constant



##Try weighted least squares to fix constant error issue.
##Weighted fit to correct error assumption
Y=abalone[,9]
X1=abalone[,1]
X2=abalone[,2]
X3=abalone[,3]
X4=abalone[,4]
X5=abalone[,5]
X6=abalone[,6]
X7=abalone[,7]
X8=abalone[,8]
fit=lm(Y~factor(X1)+X2+X3+X4+X5+X6+X7+X8)
weight=fit$fitted
weightedfit=lm(Y~factor(X1)+X2+X3+X4+X5+X6+X7+X8,data=abalone, weight= 1/(weight^.5))
linear=BIC(weightedfit)
linear



plot(weightedfit$fitted, weightedfit$residuals)
summary(weightedfit)
ncvTest(weightedfit)
##Did not work.



##Check normal assumption
qqnorm(fit$resi)
##It does not appear normal.



##Check lack of fit


#reduced=fit
#full=lm(Y~as.factor(factor(X1))+as.factor(X2)+as.factor(X3)+as.factor(X4)+as.factor(X5)+as.factor(X6)+as.factor(X7)+as.factor(X8)-1,data=abalone)
#anova(reduced,full)
#SSLF = anova(reduced,full)[2,4]
#SSPE = anova(full)[3,2]
#MSLF = SSLF/8
#MSPE = SSPE/4159
#Fstar = MSLF / MSPE
#Fstar
#qf(.995,6,4158)
#data.frame(MSLF,MSPE,Fstar)


#This is a very high Fstar, which indicates lack of fit.

# Evaluate Nonlinearity
# component + residual plot 
crPlots(fit)
# Ceres plots 
ceresPlots(fit)



##These appear to provide evidence for quadratic regression, due to non constant error keep weights
Y=abalone[,9]
X1=abalone[,1]
X2=abalone[,2]
X3=abalone[,3]
X4=abalone[,4]
X5=abalone[,5]
X6=abalone[,6]
X7=abalone[,7]
X8=abalone[,8]

x2=X2-mean(X2)
x3=X3-mean(X3)
x4=X4-mean(X4)
x5=X5-mean(X5)
x6=X6-mean(X6)
x7=X7-mean(X7)
x8=X8-mean(X8)

fit=lm(Y~factor(X1)+x2+x3+x4+x5+x6+x7+x8+I(x2^2)+I(x3^3)+I(x4^2)+I(x5^2)+I(x6^2)+I(x7^2)+I(x8^2))
summary(fit)
weight=fit$fitted

weightedfit=lm(Y~factor(X1)+x2+x3+x4+x5+x6+x7+x8+I(x2^2)+I(x3^3)+I(x4^2)+I(x5^2)+I(X6^2)+I(x7^2)+I(x8^2)
,data=abalone, weight= 1/(weight^2))
plot(weightedfit$fitted, weightedfit$residuals)
summary(weightedfit)
ncvTest(weightedfit)

#x7,x5,x3 are not significent

fit=lm(Y~factor(X1)+x2+x4+x6+x8+I(x2^2)+I(x4^2)+I(x6^2)+I(x8^2))
summary(fit)
weight=fit$fitted

weightedfit=lm(Y~factor(X1)+x2+x4+x6+x8+I(x2^2)+I(x4^2)+I(x6^2)+I(x8^2)
,data=abalone, weight= 1/(weight^2))
plot(weightedfit$fitted, weightedfit$residuals)
summary(weightedfit)

##Remove x6^2
abalone=read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/abalone/abalone.data", header=F, sep=",")
abalone
Y=abalone[,9]
X1=abalone[,1]
X2=abalone[,2]
X3=abalone[,3]
X4=abalone[,4]
X5=abalone[,5]
X6=abalone[,6]
X7=abalone[,7]
X8=abalone[,8]

x2=X2-mean(X2)
x3=X3-mean(X3)
x4=X4-mean(X4)
x5=X5-mean(X5)
x6=X6-mean(X6)
x7=X7-mean(X7)
x8=X8-mean(X8)
fit=lm(Y~factor(X1)+x2+x4+x6+x8+I(x2^2)+I(x4^2)+I(x8^2))
summary(fit)
weight=fit$fitted

weightedfit=lm(Y~factor(X1)+x2+x4+x6+x8+I(x2^2)+I(x4^2)+I(x8^2)
,data=abalone, weight= 1/(weight^2))
plot(weightedfit$fitted, weightedfit$residuals)
summary(weightedfit)
plot(weightedfit)

##Check multicolinarity
vif(weightedfit)
sqrt(vif(weightedfit))>10

#No issue
plot(weightedfit$fitted, weightedfit$residuals)

#Non linearity
crPlots(weightedfit)
#constant error
ncvTest(weightedfit)
#issue

simplequadweighted=BIC(weightedfit)
simplequadweighted
##Adj rsq= .63
##BIC=17819

#Transform y
Y=abalone[,9]
X1=abalone[,1]
X2=abalone[,2]
X3=abalone[,3]
X4=abalone[,4]
X5=abalone[,5]
X6=abalone[,6]
X7=abalone[,7]
X8=abalone[,8]

x2=X2-mean(X2)
x3=X3-mean(X3)
x4=X4-mean(X4)
x5=X5-mean(X5)
x6=X6-mean(X6)
x7=X7-mean(X7)
x8=X8-mean(X8)

fit=lm(Y~factor(X1)+x2+x3+x5+x7+x4+x6+x8+I(x3^2)+I(x5^2)+I(x7^2)+I(x6^2)+I(x2^2)+I(x4^2)+I(x8^2))
summary(fit)





##Remove X3 and square of x8, not significent remove them
Y=abalone[,9]
X1=abalone[,1]
X2=abalone[,2]
X3=abalone[,3]
X4=abalone[,4]
X5=abalone[,5]
X6=abalone[,6]
X7=abalone[,7]
X8=abalone[,8]

x2=X2-mean(X2)
x3=X3-mean(X3)
x4=X4-mean(X4)
x5=X5-mean(X5)
x6=X6-mean(X6)
x7=X7-mean(X7)
x8=X8-mean(X8)

fit=lm(Y~factor(X1)+x2+x5+x7+x4+x6+x8+I(x5^2)+I(x7^2)+I(x6^2)+I(x2^2)+I(x4^2))

summary(fit)



a=boxcox(fit)
j=a$x[which.max(a$y)]
Ytransform=Y^j
j
transformfit=lm(Ytransform~factor(X1)+x2+x5+x7+x4+x6+x8+I(x5^2)+I(x7^2)+I(x6^2)+I(x2^2)+I(x4^2),data=abalone, weight= 1/(weight^2))
summary(transformfit)

##X2,X5,X7 not significent 

fit=lm(Y~factor(X1)+x4+x6+x8+I(x6^2)+I(x4^2))
a=boxcox(fit)
j=a$x[which.max(a$y)]
Ytransform=Y^j
j
fit=lm(Ytransform~factor(X1)+x4+x6+x8+I(x6^2)+I(x4^2))

summary(fit)
plot(fit)

##Check multicolinarity
vif(fit)
sqrt(vif(fit))>10
##No issue

quadwithtransform=BIC(fit)
quadwithtransform
##adj r2 =.58
##BIC=-18798


##transform data.
##Note that Radj for second model is better.

##Check interaction term

Y=abalone[,9]
X1=abalone[,1]
X2=abalone[,2]
X3=abalone[,3]
X4=abalone[,4]
X5=abalone[,5]
X6=abalone[,6]
X7=abalone[,7]
X8=abalone[,8]

x2=X2-mean(X2)
x4=X4-mean(X4)
x6=X6-mean(X6)
x8=X8-mean(X8)

x24=x2*x4
x26=x2*x6
x28=x2*x8
x46=x4*x6
x48=x4*x8
x68=x6*x8
fit=lm(Y~factor(X1)+x4+x6+x8+x46+x48+x68+I(x4^2)+I(x6^2))
summary(fit)
weight=fit$fitted
weightedfit=lm(Y~factor(X1)+x4+x6+x8+x46+x48+x68+I(x4^2)+I(x6^2),data=abalone, weight= 1/(weight^2))
summary(weightedfit)

#Remove square x4




fit=lm(Y~factor(X1)+x4+x6+x8+x46+x48+x68+I(x6^2))
summary(fit)
weight=fit$fitted

weightedfit=lm(Y~factor(X1)+x4+x6+x8+x46+x48+x68+I(x6^2),data=abalone, weight= 1/(weight^2))
summary(weightedfit)

weightedinteraction=BIC(weightedfit)
weightedinteraction
##Check multicolinarity
vif(weightedfit)
sqrt(vif(weightedfit))>10
##No issue


#adj rsq=.65
#BIC=17429

#Compare BIC



weightedinteraction
simplequadweighted
simplelinear
quadwithtransform


##Quad with transform best using BIC criterion.

##Model selected
abalone=read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/abalone/abalone.data", header=F, sep=",")

Y=abalone[,9]
X1=abalone[,1]
X2=abalone[,2]
X3=abalone[,3]
X4=abalone[,4]
X5=abalone[,5]
X6=abalone[,6]
X7=abalone[,7]
X8=abalone[,8]

x2=X2-mean(X2)
x3=X3-mean(X3)
x4=X4-mean(X4)
x5=X5-mean(X5)
x6=X6-mean(X6)
x7=X7-mean(X7)
x8=X8-mean(X8)


fit=lm(Y~factor(X1)+x4+x6+x8+I(x6^2)+I(x4^2))
a=boxcox(fit)
j=a$x[which.max(a$y)]
Ytransform=Y^j
j
fit=lm(Ytransform~factor(X1)+x4+x6+x8+I(x6^2)+I(x4^2))
final=fit
summary(final)


##Diagnostics
#Check outliers+ influential points
outlierTest(final) 
plot(final)



#Remove points and adjust model
abalone=read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/abalone/abalone.data", header=F, sep=",")
abalone=abalone[-2628,]
abalone=abalone[-2184,]
abalone=abalone[-2052,]
abalone=abalone[-720,]
abalone=abalone[-481,]
abalone=abalone[-237,]

Y=abalone[,9]
X1=abalone[,1]
X2=abalone[,2]
X3=abalone[,3]
X4=abalone[,4]
X5=abalone[,5]
X6=abalone[,6]
X7=abalone[,7]
X8=abalone[,8]

x2=X2-mean(X2)
x4=X4-mean(X4)
x6=X6-mean(X6)
x8=X8-mean(X8)


fit=lm(Y~factor(X1)+x4+x6+x8+I(x6^2)+I(x4^2))
a=boxcox(fit)
j=a$x[which.max(a$y)]
Ytransform=Y^j
j
fit=lm(Ytransform~factor(X1)+x4+x6+x8+I(x6^2)+I(x4^2))

final=fit
summary(final)
final=transformfit
BIC(final)

fit=lm(Y~factor(X1)+x4+x6+x8+I(x4^2))
a=boxcox(fit)
j=a$x[which.max(a$y)]
Ytransform=Y^j
j
finalfit=lm(Ytransform~factor(X1)+x4+x6+x8+I(x4^2))
summary(finalfit)
modelwithoutliersremoved=BIC(finalfit)


##Test for outlier again
plot(finalfit)
outlierTest(finalfit) 



#Final model
abalone=read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/abalone/abalone.data", header=F, sep=",")
abalone=abalone[-2628,]
abalone=abalone[-2184,]
abalone=abalone[-2052,]
abalone=abalone[-720,]
abalone=abalone[-481,]
abalone=abalone[-237,]
abalone=abalone[-1415,]
abalone=abalone[-1255,]


Y=abalone[,9]
X1=abalone[,1]
X2=abalone[,2]
X3=abalone[,3]
X4=abalone[,4]
X5=abalone[,5]
X6=abalone[,6]
X7=abalone[,7]
X8=abalone[,8]

x2=X2-mean(X2)
x4=X4-mean(X4)
x6=X6-mean(X6)
x8=X8-mean(X8)



fit=lm(Y~factor(X1)+x4+x6+x8+I(x4^2))
a=boxcox(fit)
j=a$x[which.max(a$y)]
Ytransform=Y^j
j
finalfit=lm(Ytransform~factor(X1)+x4+x6+x8+I(x4^2))
summary(finalfit)
bicmoreoutliersgome=BIC(finalfit)
BIC(finalfit)
plot(finalfit)


##Final BIC
summary(finalfit)
FinalBIC=BIC(finalfit)
FinalBIC
##Adjrsq=.6189
plot(finalfit)
plot(finalfit$fitted, finalfit$residuals)
summary(finalfit)
ncvTest(finalfit)
##Did not work, due to large sample size



##Check normal assumption
qqnorm(finalfit$resi)
##Appears normal.

plot(abalone)

#LOF test
reduced=final
full=lm(Ytransform~as.factor(factor(X1))+as.factor(x4)+as.factor(x6)+as.factor(x8)+as.factor(I(x4^2))+as.factor(I(x8^2)),data=abalone, weight= 1/(weight^2))
anova(reduced,full)
SSLF = anova(reduced,full)[2,4]
SSPE = anova(full)[3,2]
MSLF = SSLF/6
MSPE = SSPE/length(Ytransform)
Fstar = MSLF / MSPE
Fstar
#Lack of fit indicated.

abalone
##Predictions
abalone=read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/abalone/abalone.data", header=F, sep=",")
abalone=abalone[-2628,]
abalone=abalone[-2184,]
abalone=abalone[-2052,]
abalone=abalone[-720,]
abalone=abalone[-481,]
abalone=abalone[-237,]
abalone=abalone[-1415,]
abalone=abalone[-1255,]

Y=abalone[,9]
X1=abalone[,1]
X2=abalone[,2]
X3=abalone[,3]
X4=abalone[,4]
X5=abalone[,5]
X6=abalone[,6]
X7=abalone[,7]
X8=abalone[,8]

x2=X2-mean(X2)
x4=X4-mean(X4)
x6=X6-mean(X6)
x8=X8-mean(X8)

myframe <- data.frame( Y=Ytransform, X1=as.factor(X1), x4=x4, x6=x6, x8=x8 )



finalfit <-lm(Ytransform~factor(X1)+x4+x6+x8+I(x4^2), data=myframe)

Then create the new data frame for prediction, using the same variable names.

newdata <- data.frame( X1="M", x2=.5, x4=1, x6=.75, x8=3 )


ci1=predict(finalfit, newdata, interval="predict", level=0.99)

ci1
(ci1)^(-(1/.2222))

newdata <- data.frame( X1="F", x2=.043, x4=.0001, x6=3, x8=2 )


ci2=predict(finalfit, newdata, interval="predict", level=0.99)

(ci2)^(1/-.2222)
