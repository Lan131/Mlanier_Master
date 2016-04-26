
### Fractional Factorial Design
### Example 4.6
rm(list = ls())

y = c(-.63,2.51,-2.68,1.66,2.06,1.22,-2.09,1.93,6.79,5.47,3.45,5.68,5.22,4.38,4.3,4.05)

lv = c(-1,1)

X1 =  expand.grid(A=lv,B=lv,C=lv,D=lv,E=lv)

barplot(y)

dat.full = cbind(X1,y)
###############################
### Set Defining Relation
###############################

# set defining relation to I = ABCDE
attach(X1) ## make A, B, C, and D , Eglobal variables
DR = A*B*C*D*E
detach(X1) ## remove A, B, C, and D , Eglobal variables
## use which() to return index of DR = +1 
## pfrac is the row index of principal fraction
pfrac = which(DR == "1")
## extract rows of principal fraction from data
dat.frac = dat.full[pfrac,]
## fractional design
## The estimated effect sizes for fractional designs
## are alias with other effect (see discussion on how to find alias effects)
fit.frac0 = lm(y ~ A*B*C*D, data = dat.frac)
summary(fit.frac0)
eff_fr0 = coef(fit.frac0)[-1]*2
abs.effr = abs(eff_fr0)





#4.6a

abs.effr[order(abs.effr, decreasing = T)]

q.norm=qqnorm(eff_fr0 , pch=19, col="red")
#4.6b
#See attached plot. This is a saturated model so the residuals are all 0.
plot(fit.frac0)
qqnorm(fit.frac0$resi)
#4.6c
## Large effects observed in order: D,AD,B,A,AB

## fitting a linear model with the observed effects as predictor
fit.full1 = lm(y ~ A + B + D + A*B + A*D, data = dat.full)
summary(fit.full1)
ef.full = coef(fit.full1)[-1]*2
plot(fit.full1)

#project

## The estimated effect sizes for fractional designs
## are alias with other effect (see discussion on how to find alias effects)
fit.frac1 = lm(y ~ A + B + D + A*B + A*D, data = dat.frac)
summary(fit.frac1)
ef.frac = coef(fit.frac1)[-1]*2
ef.frac
plot(fit.frac1)


q.norm=qqnorm(ef.frac , pch=19, col="red")
#These effects are all significent at .05 level and the model is highly significent.
#A, D, and the interaction of A and B appear are positivly correlated to a postive correlation in the response. B and the interaction of A and D are negativly correlated to the response.

#4.13a
#2 to the  6-2 resolution 4, with F=BCD and E=ABC. Main effects alliased to 5 way or 3 way interactions
#4.13b
# 2 way effects alliased to 3,4, or a 6 way interaction, 3 way alliased to main effects or 4 way, 4 way interactions alliased to 

y1=c(157.25,48,44,55.75,55.75,230,97.25,225,50.25,85.25,31.5,160,133.75,92.75,150.75,115) 


lv = c(-1,1)

X1 =  expand.grid(A=lv,B=lv,C=lv,D=lv,E=lv,F=lv)

dat.full = cbind(X1,y1)
# set defining relation to I = ADEF
attach(X1) ## make A, B, C, and D , Eglobal variables
DR = A*D*E*F
detach(X1) 
## use which() to return index of DR = +1 
## pfrac is the row index of principal fraction
pfrac = which(DR == "1")
## extract rows of principal fraction from data
dat.frac = dat.full[pfrac,]
## fractional design
## The estimated effect sizes for fractional designs
## are alias with other effect (see discussion on how to find alias effects)
fit.frac0 = lm(y1 ~ A*B*C*D, data = dat.frac)
summary(fit.frac0)
eff_fr0 = coef(fit.frac0)[-1]*2
abs.effr = abs(eff_fr0)
abs.effr[order(abs.effr, decreasing = T)]

#A,C look like they effect the average camber.

#look at variance 4.13d
y2=c(24.418,20.976,4.0825,25.025,22.41,63.639,16.029,39.42,26.725,50.341,7.681,20.083,31.12,29.51,6.75,17.45)
lv = c(-1,1)

X1 =  expand.grid(A=lv,B=lv,C=lv,D=lv,E=lv,F=lv)

dat.full = cbind(X1,y2)
# set defining relation to I = ADEF
attach(X1) ## make A, B, C, and D , Eglobal variables
DR = A*D*E*F
detach(X1) 
## use which() to return index of DR = +1 
## pfrac is the row index of principal fraction
pfrac = which(DR == "1")
## extract rows of principal fraction from data
dat.frac = dat.full[pfrac,]
## fractional design
## The estimated effect sizes for fractional designs
## are alias with other effect (see discussion on how to find alias effects)
fit.frac0 = lm(y2 ~ A*B*C*D, data = dat.frac)
summary(fit.frac0)
eff_fr0 = coef(fit.frac0)[-1]*2
eff_fr0
abs.effr = abs(eff_fr0)
abs.effr[order(abs.effr, decreasing = T)]

#B and A effect the variability in camber greatly.
#4.13e
#Reduce A and C, and increase B and D. Reduce A (Lamination temp) and C (lamination pressure) the most.

#4.13f 
ydiv=y2/y1

lv = c(-1,1)

X1 =  expand.grid(A=lv,B=lv,C=lv,D=lv,E=lv,F=lv)

dat.full = cbind(X1,ydiv)
# set defining relation to I = ADEF
attach(X1) ## make A, B, C, and D , Eglobal variables
DR = A*D*E*F
detach(X1) 
## use which() to return index of DR = +1 
## pfrac is the row index of principal fraction
pfrac = which(DR == "1")
## extract rows of principal fraction from data
dat.frac = dat.full[pfrac,]
## fractional design
## The estimated effect sizes for fractional designs
## are alias with other effect (see discussion on how to find alias effects)
fit.frac0 = lm(ydiv ~ A*B*C*D, data = dat.frac)
summary(fit.frac0)
eff_fr0 = coef(fit.frac0)[-1]*2
eff_fr0
#Decrease A or D, or increase B or C.


### Fractional Factorial Design
### Example 4.6
rm(list = ls())

y = c(-.63,2.51,-2.68,1.66,2.06,1.22,-2.09,1.93,6.79,5.47,3.45,5.68,5.22,4.38,4.3,4.05)

lv = c(-1,1)

X1 =  expand.grid(A=lv,B=lv,C=lv,D=lv,E=lv)

barplot(y)

dat.full = cbind(X1,y)
###############################
### Set Defining Relation
###############################

# set defining relation to I = ABCDE
attach(X1) ## make A, B, C, and D , Eglobal variables
DR = A*B*C*D*E
detach(X1) ## remove A, B, C, and D , Eglobal variables
## use which() to return index of DR = +1 
## pfrac is the row index of principal fraction
pfrac = which(DR == "1")
## extract rows of principal fraction from data
dat.frac = dat.full[pfrac,]
## fractional design
## The estimated effect sizes for fractional designs
## are alias with other effect (see discussion on how to find alias effects)
fit.frac0 = lm(y ~ A*B*C*D, data = dat.frac)
summary(fit.frac0)
eff_fr0 = coef(fit.frac0)[-1]*2
abs.effr = abs(eff_fr0)





#4.6a

abs.effr[order(abs.effr, decreasing = T)]

q.norm=qqnorm(eff_fr0 , pch=19, col="red")
#4.6b
#See attached plot. This is a saturated model so the residuals are all 0.
plot(fit.frac0)
qqnorm(fit.frac0$resi)
#4.6c
## Large effects observed in order: D,AD,B,A,AB

## fitting a linear model with the observed effects as predictor
fit.full1 = lm(y ~ A + B + D + A*B + A*D, data = dat.full)
summary(fit.full1)
ef.full = coef(fit.full1)[-1]*2
plot(fit.full1)

#project

## The estimated effect sizes for fractional designs
## are alias with other effect (see discussion on how to find alias effects)
fit.frac1 = lm(y ~ A + B + D + A*B + A*D, data = dat.frac)
summary(fit.frac1)
ef.frac = coef(fit.frac1)[-1]*2
ef.frac
plot(fit.frac1)


q.norm=qqnorm(ef.frac , pch=19, col="red")
#These effects are all significent at .05 level and the model is highly significent.
#A, D, and the interaction of A and B appear are positivly correlated to a postive correlation in the response. B and the interaction of A and D are negativly correlated to the response.

#4.13a
#2 to the  6-2 resolution 4, with F=BCD and E=ABC. Main effects alliased to 5 way or 3 way interactions
#4.13b
# 2 way effects alliased to 3,4, or a 6 way interaction, 3 way alliased to main effects or 4 way, 4 way interactions alliased to 

y1=c(157.25,48,44,55.75,55.75,230,97.25,225,50.25,85.25,31.5,160,133.75,92.75,150.75,115) 


lv = c(-1,1)

X1 =  expand.grid(A=lv,B=lv,C=lv,D=lv,E=lv,F=lv)

dat.full = cbind(X1,y1)
# set defining relation to I = ADEF
attach(X1) ## make A, B, C, and D , Eglobal variables
DR = A*D*E*F
detach(X1) 
## use which() to return index of DR = +1 
## pfrac is the row index of principal fraction
pfrac = which(DR == "1")
## extract rows of principal fraction from data
dat.frac = dat.full[pfrac,]
## fractional design
## The estimated effect sizes for fractional designs
## are alias with other effect (see discussion on how to find alias effects)
fit.frac0 = lm(y1 ~ A*B*C*D, data = dat.frac)
summary(fit.frac0)
eff_fr0 = coef(fit.frac0)[-1]*2
abs.effr = abs(eff_fr0)
abs.effr[order(abs.effr, decreasing = T)]

#A,C look like they effect the average camber.

#look at variance 4.13d
y2=c(24.418,20.976,4.0825,25.025,22.41,63.639,16.029,39.42,26.725,50.341,7.681,20.083,31.12,29.51,6.75,17.45)
lv = c(-1,1)

X1 =  expand.grid(A=lv,B=lv,C=lv,D=lv,E=lv,F=lv)

dat.full = cbind(X1,y2)
# set defining relation to I = ADEF
attach(X1) ## make A, B, C, and D , Eglobal variables
DR = A*D*E*F
detach(X1) 
## use which() to return index of DR = +1 
## pfrac is the row index of principal fraction
pfrac = which(DR == "1")
## extract rows of principal fraction from data
dat.frac = dat.full[pfrac,]
## fractional design
## The estimated effect sizes for fractional designs
## are alias with other effect (see discussion on how to find alias effects)
fit.frac0 = lm(y2 ~ A*B*C*D, data = dat.frac)
summary(fit.frac0)
eff_fr0 = coef(fit.frac0)[-1]*2
eff_fr0
abs.effr = abs(eff_fr0)
abs.effr[order(abs.effr, decreasing = T)]

#B and A effect the variability in camber greatly.
#4.13e
#Reduce A and C, and increase B and D. Reduce A (Lamination temp) and C (lamination pressure) the most.

#4.13f 
ydiv=y2/y1

lv = c(-1,1)

X1 =  expand.grid(A=lv,B=lv,C=lv,D=lv,E=lv,F=lv)

dat.full = cbind(X1,ydiv)
# set defining relation to I = ADEF
attach(X1) ## make A, B, C, and D , Eglobal variables
DR = A*D*E*F
detach(X1) 
## use which() to return index of DR = +1 
## pfrac is the row index of principal fraction
pfrac = which(DR == "1")
## extract rows of principal fraction from data
dat.frac = dat.full[pfrac,]
## fractional design
## The estimated effect sizes for fractional designs
## are alias with other effect (see discussion on how to find alias effects)
fit.frac0 = lm(ydiv ~ A*B*C*D, data = dat.frac)
summary(fit.frac0)
eff_fr0 = coef(fit.frac0)[-1]*2
eff_fr0
#Decrease A or D, or increase B or C.
dat.full

Xtest=expand.grid(A=c(-1,1),B=c(-1,1))
ytest=c(-1,.5,4,-3)
Xtest=cbind(Xtest,ytest)
Xtest
Xtest$A
help(contour)
sort(ytest)
X=c(-1:1)
sort(ytest)
contour(data.matrix(Xtest))
persp(data.matrix(Xtest),expand=.2)
persp(volcano)
persp(volcano,expand=.2)
