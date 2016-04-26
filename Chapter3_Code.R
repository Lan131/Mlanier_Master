####Diagnostic

##0. satisfying the assumptions
set.seed(0)
n = 100
x = rnorm(n)
y = x + rnorm(n)
fit = lm(y~x)
resi = fit$resi

par(mfrow=c(2,2))
plot(x, fit$resi,main="Residual Plot against X")
mse = sum(resi^2)/(n-2)
plot(resi/sqrt(mse),main="Sequence Plot")
plot(resi,main="Sequence Plot")
qqnorm(resi,main="Q-Q Plot")
par(mfrow=c(1,1))


##1. nonlinear relationship
n = 100
x = rnorm(n)
y = exp(x) + rnorm(n)
fit = lm(y~x)
resi = fit$resi

par(mfrow=c(1,2))
plot(x,y,main="Plot of x and y")
abline(fit,col="red")
plot(x, fit$resi,main = "Residual Plot")
abline(h=0,col="blue")
par(mfrow=c(1,1))


##2. unequal error variance
x = runif(n)
y = x + rnorm(n) * abs(x)
fit = lm(y~x)
par(mfrow=c(1,2))
plot(x, fit$resi,main = "Residual Plot")
plot(x, abs(fit$resi),main = "Absolute Residual Plot")
par(mfrow=c(1,1))


##3. outlying observation
n=30
x = rnorm(n)
y = x + rnorm(n,sd=0.2)
y[10]= 10
fit=lm(y~x)
fit1 = lm(y[-10]~x[-10])
resi= fit$resi
mse = sum(resi^2)/(n-2)

par(mfrow=c(1,2))
plot(x,y,main="Plot of x and y")
abline(fit,col="red")
abline(fit1, col="blue")
plot(resi/sqrt(mse),main = "Semistudentisized Residual Plot")
par(mfrow=c(1,1))

coef(fit)
coef(fit1)


##4. dependency on the index of the observation
n=100
x = runif(n)
y = x + rnorm(n) * (1:n)
fit = lm(y~x)
resi = fit$resi

par(mfrow=c(1,2))
plot(x, fit$resi,main="Residuals against x")
plot(fit$resi,main="Sequence Plot of Residuals") ##see the difference of the two plots
par(mfrow=c(1,1))


##5. nonnormality of the random error
n = 1000
x = runif(n)
y = x + rexp(n)
fit = lm(y~x)
resi = fit$resi
qqnorm(resi)
qqline(resi, col = "red")

x = runif(n)
y = x + rt(n,2)
fit = lm(y~x)
resi = fit$resi
qqnorm(resi)
qqline(resi, col = "red")



####Correlation Test for Normality
####using the toluca example
rm(list = ls())  # clear memomy list
data = read.table('toluca.txt')
n = nrow(data)
x = data[,1]
y = data[,2]
fit = lm(y~x)
resi = fit$resi
rank.k = rank(resi)
mse = sum(resi^2)/(n-2)
p = (rank.k - 0.375)/(n+0.25)
exp.resi = sqrt(mse)*qnorm(p)
cbind(resi,exp.resi)
cor(resi,exp.resi)






##################################################################
##  Tests for constancy of error variance 
## (Brown-Forsythe test, Breusch-Pagan test, Section 3.6) 
##################################################################

####Brown-Forsythe Test
####using the toluca example
rm(list = ls())  # clears memory
data = read.table('toluca.txt')
n = nrow(data)
x = data[,1]
y = data[,2]
## divide the 25 cases into
## two groups with approx 
## equal sizes
## group 1 = 20 to 70
## group 2 = 80 to 120
ind1 = which(x<80)
ind2 = which(x>=80)
fit = lm(y~x)
resi = fit$resi
resi1 = resi[ind1]
resi2 = resi[ind2]
d1 = abs(resi1-median(resi1))
d2 = abs(resi2-median(resi2))
BF = t.test(d1,d2)
data.frame(BF$statistic, BF$p.value)


##### Breush-Pagan Test
##### for Toluca data
fit2 = lm(resi^2~x) 
anova(fit)
anova(fit2)
SSE = anova(fit)$"Sum Sq"[2] 
SSR.star = anova(fit2)$"Mean Sq"[1]
BP.statistic = (SSR.star/2)/(SSE/n)^2
BP.p.value = pchisq(BP.statistic,df=1,lower.tail=F)
data.frame(BP.statistic, BP.p.value)
library(car) 
ncvTest(fit) ###a direct function for BP test 


#### Breush-Pagan Test
#### for a data with increasing 
#### standard deviation
rm(list = ls())  # clear memory list
set.seed(21)  # set seed number generator
n = 50
x = rep(c(1,2,3,4,5), n)
error = rnorm(n, sd=rep(c(0.5,1,2,3,4), n))
y = 1 + x + error
fit = lm(y~x)
ncvTest(fit) ###a direct function for BP test 

plot(x,fit$res)




#### Lack of Fit Test
#### Bank Example
rm(list = ls()) # clears memory
Size = c(125,100,200,75,150,175,75,175,125,200,100) 
NewAc = c(160,112,124,28,152,156,42,124,150,104,136)
Reduced = lm(NewAc ~ Size) 
coef(Reduced)
anova(Reduced) 
table(Size) 
## "as.factor()" encode a vector in terms of category (no longer numerical)
## Note that we are regressing "NewAC" to "as.factor(Size)" 
as.factor(Size)
## "-1" in "as.factor(Size)-1" removes the y-intercept in the model
Full = lm(NewAc ~ as.factor(Size)-1) 
anova(Reduced,Full)



####Box-Cox transformation
set.seed(17)
n = 1000
x = rnorm(n)
eps = rnorm(n)/10
sy = x + eps + 6
y = sy^2
logk2 = mean(log(y))
k2 = exp(logk2)
 
lamList = seq(from=-2, to=2, by=0.25)
sseList = rep(0,length(lamList))
for(i in 1:length(lamList)){
lam = lamList[i]
k1 = 1/lam/k2^(lam-1)
if(lam == 0) w = k2*log(y)
if(lam != 0) w = k1*(y^lam-1)
fit = lm(w~x)
sseList[i] = sum((w-fitted(fit))^2)
}

plot(lamList,sseList, type = "b")
lamList[which.min(sseList)] ###best transformation parameter

### direct function
library(MASS)
fit = lm(y~x)
a = boxcox(fit)
a$x[which.max(a$y)] ###best transformation parameter


### Box-Cox Transformation 
### on Plasma Data
rm(list = ls())
library(MASS)
plasma = read.table("plasma.txt")
colnames(plasma) = c("X","Y","log10Y")
fit = lm(Y~X, data=plasma)
coef(fit)

## Check the fit and qqplot
par(mfcol = c(1,2))  # two figures in a panel
plot(plasma$X,plasma$Y)
abline(fit, col = "red")
qqnorm(fit$resi)
qqline(fit$resi, col= "blue")
par(mfcol = c(1,1))

## Determine the best transformation parameter
## through BoxCox Transformation direct function
a = boxcox(fit)
a$x[which.max(a$y)] ###best transformation parameter
plasma$Ynew = plasma$Y^{-0.5}
fit.new = lm(Ynew ~ X, data=plasma)
coef(fit.new)

## Check the plot and qqplot again
par(mfcol = c(1,2))
plot(plasma$X,plasma$Ynew)
abline(fit.new, col = "red")
qqnorm(fit.new$resi)
qqline(fit.new$resi, col = "blue")
par(mfcol = c(1,1))



