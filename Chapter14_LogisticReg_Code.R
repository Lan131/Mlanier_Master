rm(list = ls())
dat = read.table("task.txt")
colnames(dat) = c("X","Y","pihat")

## computes numerical summaries
summary(dat)

sapply(dat,sd)

## passed down variables to global environment
attach(dat)

## fit a logistic regression model using the "glm" function in R
logit.fit = glm(Y ~ X,family = "binomial")
summary(logit.fit)

## estimated probability of task success
pihat.fit = logit.fit$fitted
pihat.fit

## another way to compute pihat.fit (predicted)
pihat.fit=exp(-3.0597+0.1615*X)/(1+exp(-3.0597+0.1615*X))

## check logistic regression model with data
## prediction = 1, if estimated proby of success > 50%
prediction=as.numeric(pihat.fit >.5)
error=Y-prediction

data.frame(success=Y,predicted=pihat.fit,prediction,error)

plot(X,Y,xlab="Months of experience",ylab="Probability of task success",xlim=c(0,35)) 

curve(predict(logit.fit,data.frame(X=x),type="resp"),add=TRUE) # draws a curve based on prediction from logistic regression model

points(X,pihat.fit,pch=20)

## estimate the probability of task success when months of experience is X=14 
newdata = data.frame(X=14)
predict(logit.fit,newdata,type="response")

## another way to compute estimate proby of task success
X0 = 14
exp(-3.0597+0.1615*X0)/(1+exp(-3.0597+0.1615*X0))


 
## estimated odds ratio
exp(coef(logit.fit)) 

## CIs using profiled likelihood
confint(logit.fit)

## CIs using standard errors
confint.default(logit.fit)


## Multiple logistic regression, Disease Outbreak data page 573

dat = read.table("outbreak.txt")
colnames(dat) = c("Case","X1","X2","X3","X4","Y")
Full.Model = glm (Y ~ X1 + X2 + X3 + X4, family = "binomial",data=dat)
summary(Full.Model)

## Estimate the mean response for case 1.
X0 = dat[1,][-1]
X0
newdata = data.frame(X0)
predict(Full.Model,newdata,type="response")

## coefficients under FM
coef(Full.Model)

## estimated odds ratio
exp(coef(Full.Model))



## Reduced Model, we remove variable X1 = Age
Reduced.Model = glm (Y ~ X2 + X3  + X4, family = "binomial", data=dat)

## coef under RM
coef(Reduced.Model)

## Odds ratio under RM
exp(coef(Reduced.Model))


## Likelihood Ratio Test whether some coefs are zero
## Log-Likelihood Under Full Model
LF = logLik(Full.Model)
## Log-Likelihood Under Feduced Model
LR = logLik(Reduced.Model)
## test statistic
G2 = -2*(LR-LF)
data.frame(LF,LR,G2) 
## p-q = 5-4 = 2, chi-square distribution with 1 degree of freedom
qchisq(0.95,df=1)
G2 > qchisq(0.95,df=1)
p.value = 1 - pchisq(as.numeric(G2), df=1)

# Reduced Model where we drop SES (X2, X3)

RM2 = glm (Y ~ X1 + X4, family = "binomial", data=dat)
G2 = -2*(logLik(RM2) - LF) 
qchisq(0.95,df=2)
p.value = 1 - pchisq(as.numeric(G2), df=2)

# Reduced Model where we drop city sector

RM3 = glm (Y ~ X1 + X2 + X3, family = "binomial", data=dat)
G2 = -2*(logLik(RM3) - LF) 
qchisq(0.95,df=1)
p.value = 1 - pchisq(as.numeric(G2), df=1)

## SES can be dropped from the model containing the other two predictors
## However, since this variable was considered important (controlling variable)
## so we keep SES.


## Second-Order Multiple Logistic Model
Full.Second = glm (Y ~ X1 + X2 + X3 + X4 + I(X1*X2) + I(X1*X3) 
	+ I(X1*X4) + I(X2*X4) + I(X3*X4), family = "binomial",data=dat)

G2 = -2*(LF - logLik(Full.Second))
qchisq(0.95,df=5)
p.value = 1 - pchisq(as.numeric(G2), df=5)

## The logistic model without the interaction terms is acceptable.



