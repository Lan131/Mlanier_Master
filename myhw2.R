### Homework 2 Michael
rm(list = ls())
#A
#### Using Doe.Base and FRF2 package in R
library(DoE.base)
library(FrF2)

design3.8 <- 
  fac.design(nfactors = 2, replications = 4, randomize = FALSE, 
             factor.names = list(A = c(55, 59), B = c("Short", "Long")))

y = c(14.037, 13.880, 14.821, 14.88, 16.165, 13.86, 14.757, 14.921, 13.972, 14.032, 14.843, 14.415, 13.907, 13.914, 14.878, 14.932)

design3.8 <- add.response(design = design3.8, response = y)


design3.8

### Plot main effects and interactions
MEPlot(design3.8)
IAPlot(design3.8)




### Regression Model
### Regression
fit3.8 <- lm(y ~ A*B, data = design3.8)

effects = coef(fit3.8)[-1]*2
effects
q.norm=qqnorm(effects, pch=19, col="red")
q.norm
runs = c( "a","b","ab")

## Probability Plot
plot(q.norm)
text(q.norm, runs, pos=3)
qqline(q.norm)



effects = coef(fit3.8)[-1]*2
effects




### ANOVA Table
anova(fit3.8)
summary(fit3.8)


plot(fit3.8)
#5 has extremly high leverage.

#remove the point
newdesign3.8 = design3.8[-5,]
newfit3.8 <- lm(y ~ A*B, data = newdesign3.8)
summary(newfit3.8)




### Create a contour plot
X1 =  expand.grid(A=c(-1,1),B=c(-1,1)) # one replicate
X1 
condes3.8 = rbind(X1,X1,X1,X1) # repeat for 4 replicates
condes3.8
condes3.8$y = y  ## add the response
condes3.8=condes3.8[-5,]
confit3.8 <- lm(y ~ A*B, data = condes3.8)

summary(confit3.8)

library(pid)   
contourPlot(confit3.8)


#B 3.13

design3.13 =fac.design(nfactors = 5, replications = 1, randomize = FALSE,factor.names = 
list(A = c("Small", "Large"), B = c("Below", "Above"),C=c("30","45"),D=c("small","large"),E=c("14.5","15.5")))

y = c(15,20,70,112,30,40,79,125,16,21,65,100,35,45,85,120,14,23,71,110,31,43,90,130,12,19,60,106,32,39,82,128)

design3.13 <- add.response(design = design3.13, response = y)


design3.13

### Plot main effects and interactions
MEPlot(design3.13)
IAPlot(design3.13)




### Regression Model
### Regression
fit3.13 <- lm(y ~ A*B*C*D*E, data = design3.13)
summary(fit3.13)








effects = coef(fit3.13)[-1]*2
effects
es = round(effects, digits = 2)
es
q.norm=qqnorm(effects, pch=19, col="red")
q.norm
runs = c( "a","b","ab","c","ac","bc","abc","d","ad","bd","abd","cd","acd","bcd","abcd","e","ae","be","abe","ce","ace","bce","abce","de","ade","bde","abde","cde","acde","bcde","abcde")

## Probability Plot
plot(q.norm)
text(q.norm, runs, pos=3,cex = .4)


anova(fit3.13)
qqnorm(fit3.13$residuals)

yhat = fit3.13$fitted.values
res = fit3.13$residuals
data.frame(y,yhat,res)


### ANOVA Table
anova(fit3.13)
summary(fit3.13)


##Reduced#############################################################

fit3.13 <- lm(y ~ A*B*C, data = design3.13)
summary(fit3.13)








effects = coef(fit3.13)[-1]*2
effects
es = round(effects, digits = 2)
es
q.norm=qqnorm(effects, pch=19, col="red")
q.norm
runs = c( "a","b","ab","c","ac","bc","abc")

## Probability Plot
plot(q.norm)
text(q.norm, runs, pos=3,cex = .4)
text

anova(fit3.13)
qqnorm(fit3.13$residuals)

yhat = fit3.13$fitted.values
res = fit3.13$residuals
data.frame(y,yhat,res)


### ANOVA Table
anova(fit3.13)
summary(fit3.13)




### Create a contour plot
X1 =  expand.grid(A = c(-1, 1), B = c(-1, 1),C=c(-1,1)) # one replicate
condes3.13 = rbind(X1,X1,X1,X1) # repeat for 4 replicates
condes3.13
condes3.13$y = y  ## add the response

condes3.13=condes3.13[-5,]
confit3.13 <- lm(y ~ A*B*C, data = condes3.13)
library(pid)   
contourPlot(confit3.13)



#3.24



design3.24 <- 
  fac.design(nfactors = 4, replications = 1, randomize = FALSE, 
             factor.names = list(A = c(-1,1), B = c(-1,1),C = c(-1,1),D = c(-1,1)))

y = c(90,64,81,63,77,61,88,53,98,62,87,75,99,69,87,60)

design3.24 <- add.response(design = design3.24, response = y)


design3.24

X1 =  expand.grid(A = c(-1, 1), B = c(-1, 1),C = c(-1,1),D = c(-1,1))


X1$y = y  ## add the response

X1=X1[-5,]
confit3.24 <- lm(y ~ A*B*C*D, data = X1)
library(pid)   
contourPlot(confit3.24)

### With Blocking Variable Confounded on Effect A*B*C*D
X1$block = X1$A * X1$B * X1$C * X1$D

fit3.24.block = lm(y ~ A + B + C + D + block, data = X1)
summary(fit3.24.block)
anova(fit3.24.block)

effects = coef(fit3.24.block)[-1]*2
effects
es = round(effects, digits = 2)
es



ynew=c(90,64,81,63,77,61,88,53,78,42,67,55,79,49,67,40)
X1 =  expand.grid(A = c(-1, 1), B = c(-1, 1),C = c(-1,1),D = c(-1,1))


X1$y = y  ## add the response

X1=X1[-5,]
confit3.24 <- lm(y ~ A*B*C*D, data = X1)
X1 =  expand.grid(A = c(-1, 1), B = c(-1, 1),C = c(-1,1),D = c(-1,1))


X1$y = y  ## add the response

X1=X1[-5,]
confit3.24 <- lm(y ~ A*B*C*D, data = X1)

effects = coef(fit3.24.block)[-1]*2
effects
es = round(effects, digits = 2)
es


