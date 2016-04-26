####  Model selection example             #############

####  Best subset using package "bestglm" #############
rm(list = ls())
### synthetic data
set.seed(1)
n = 100
### generate predictor values from standard normal
x1 = rnorm(n)
x2 = rnorm(n)
x3 = rnorm(n)
x4 = rnorm(n)
x5 = rnorm(n)
### set population regression model
### with beta2=beta4=0
### and beta1=1, beta3=2, beta5=3
### error values are also from standard normal
y = x1 + 2*x3 + 3*x5 + rnorm(n)
### combine the predictor values with y
### make sure to set the new object as data.frame
dat = data.frame(cbind(x1,x2,x3,x4,x5,y))
### histogram of data
par(mfcol = c(2,3))
for (i in 1:6) 
plot(density(dat[,i]), main=substitute(paste('Density of ', a), list(a=colnames(dat)[i])))
par(mfcol = c(1,1))
pairs(dat)


####  best subset using package "leaps"   #############
library(leaps)

leaps<-regsubsets(y~x1+x2+x3+x4+x5,data=dat,nbest=10) #nbest means the max number of optimal model for each size
# view results
summary(leaps,matrix.logical=TRUE)
# plot a table of models showing variables in each model.
# models are ordered by the selection statistic.
plot(leaps,scale="r2")
plot(leaps,scale="adjr2")
plot(leaps,scale="Cp")
plot(leaps,scale="bic")

leaps1<-regsubsets(y~x1+x2+x3+x4+x5,data=dat,nbest=1)
# view results
summary(leaps1,matrix.logical=TRUE)
# plot a table of models showing variables in each model.
# models are ordered by the selection statistic.
plot(leaps1,scale="r2")
plot(leaps1,scale="adjr2")
plot(leaps1,scale="Cp")
plot(leaps1,scale="bic")


#### Alternative package "bestglm"
library(bestglm)

fit = bestglm(dat,IC='AIC')
fit$Subsets

##  model 3 with predictors X1, X2, X3 with AIC criterion
-2*4.912315 + 2*3

fit = bestglm(dat,IC='BIC')
fit$Subsets

##  model 3 with predictors X1, X2, X3 with BIC Criterion
-2*4.912315 + 3*log(100)



### Create our own function 
### that computes R2, R2a, AIC, BIC, PRESS Cp

### bestsubset() function
### argument X is the data frame containing predictor values
### response vector y
bestsubset <- function(X, y){
  ## start of function
  P = ncol(X)
  ## create a grid containing all possible predictor subset combinations
  subsets = expand.grid( rep( list( 0:1), P))
  names(subsets)=paste('X',1:P,sep='')
  stat = NULL
  SST = sum((y-mean(y))^2)

  fitall = lm(y~X)
  n = nrow(X)
  MSEP = deviance(fitall)/(n-P-1) 
  ## for loop that evaluates all possible subsets
  for(i in 1:nrow(subsets)){
    subs = which(subsets[i,]>0)
    ## fit model with intercept term only
    if(length(subs)==0) fit = lm(y~1)
    ## fit model for other predictor subsets
    else {
      subX = X[,which(subsets[i,]>0)]
      fit = lm(y~subX)
    }
    p = length(subs)+1
    ## compute summary fit measures SSE, R2, R2a, Cp, AIC, BIC
    SSE = deviance(fit)
    R2 = 1-SSE/SST
    R2a = 1-SSE/SST*(n-1)/(n-p)
    Cp = SSE/MSEP - (n-2*p) 
    AIC = n*log(SSE)-n*log(n)+2*p
    BIC = n*log(SSE)-n*log(n)+log(n)*p
    
    ## compute PRESS_p
    X1 = as.matrix(cbind(1,X[,subs]))
    hatMat = X1%*%solve(t(X1)%*%X1)%*%t(X1)
    eList = fit$residuals
    dList = eList/(1-diag(hatMat))
    PRESS = sum(dList^2)
    ## combine the fir measures in a vector
    criList = c(length(subs)+1, subsets[i,],  SSE, R2, R2a, Cp, AIC, BIC, PRESS)
    ## add vector criList as row to previously
    ## computed fit measures from previous models
    stat=rbind(stat,criList)
  }
  rownames(stat)=NULL
  colnames(stat)=c('p',names(subsets),'SSE','R2','R2a','Cp','AIC','BIC','PRESS')
  
  model = NULL
  ## select the best fit measures
  model$R2 = which.max(stat[,P+3])
  model$R2a = which.max(stat[,P+4])
  model$Cp = which.min(stat[,P+5])
  model$AIC = which.min(stat[,P+6])
  model$BIC = which.min(stat[,P+7])
  model$PRESS = which.min(stat[,P+8])
  list(model=model, stat=stat)
}

## end of function bestsubset()

######

X = cbind(x1,x2,x3,x4,x5)
## use bestsubset()
bestsubset(X,y)


## automatic procedures

full = lm(y~x1+x2+x3+x4+x5,data=dat)
null = lm(y~1, data=dat)

step(null, scope=list(upper=full, lower=null), direction='both', trace=TRUE)

step(null, scope=list(upper=full, lower=null), direction='forward', trace=TRUE)

step(full, scope=list(upper=full, lower=null), direction='backward', trace=TRUE)

add1 (null, ~x2+x3+x4+x5)

drop1 (full)

add1 (null, ~x2+x3+x4+x5,test='F')

drop1 (full,test='F')



###### Model Selection for surgical example  ########
######

dat = read.table('surgical.txt')

colnames(dat) = c("X1","X2","X3","X4","X5","X6","X7","X8","Y","lnY")

fit0 = lm(Y~X1+X2+X3+X4,data=dat)
fit = lm(lnY~X1+X2+X3+X4,data=dat) 


par(mfrow=c(2,2))
plot(fit0$fitted,  fit0$residuals)
qqnorm(fit0$residuals)
qqline(fit0$residuals)
plot(fit$fitted, fit$residuals)
qqnorm(fit$residuals)
qqline(fit$residuals)
par(mfrow=c(1,1))

## transforming the response using log transformation
## seems to satisfy the normality assumption

cor(dat[,c(10,1:4)])
pairs(dat[,c(10,1:4)])

#### using regsubset function
library(leaps)
leaps4 = regsubsets(lnY~X1+X2+X3+X4, data = dat, nbest=10)
summary(leaps4,matrix.logical=TRUE)
plot(leaps4,scale="adjr2")
plot(leaps4,scale="Cp")
plot(leaps4,scale="bic")

## using the function bestsubset
X = as.matrix(dat[,1:4])
bestsubset(X,dat$lnY)


### all 8 predictors
## remove column for Y
newdat = dat[, -9]

## using regsubsets from "leap" package
leaps8<-regsubsets(lnY~.,data=newdat,nbest=9)
summary(leaps8,matrix.logical=T)

plot(leaps8,scale="adjr2")
plot(leaps8,scale="Cp")
plot(leaps8,scale="bic")

## using bestglm
fitg1 = bestglm(newdat,IC='AIC')
fitg1$Subsets
fitg2 = bestglm(newdat,IC='BIC')
fitg2$Subsets

## using bestsubset()
X = as.matrix(newdat[,-9])
y = dat$lnY
bestsubset(X,y)


## automatic procedures

full = lm(lnY~.,data=newdat)
null = lm(lnY~1,data=newdat)

## stepwise
step(null, scope=list(upper=full, lower=null), direction='both', trace=TRUE)
## forward
step(null, scope=list(upper=full, lower=null), direction='forward', trace=TRUE)
## backward
step(full, scope=list(upper=full, lower=null), direction='backward', trace=TRUE)

