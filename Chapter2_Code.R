### Check the working directory
getwd()
### Change the working directory to 
### to where toluca.txt is located
### Load the data in R

toluca = read.table('toluca.txt',header=F) 

### Change the column names
names(toluca)= c("Size", "Hours")
### Doing linear regression using R function lm()

fit = lm(Hours~Size, data=toluca)
summary(fit)

### Plot the data using scatterplot
plot(toluca,xlim=c(0,150),ylim=c(0,600))
abline(fit, col="red")

### Inference using direct functions in R
### 1) Confidence intervals for beta1 and beta0
confint(fit,level=0.95) # default is 95% level

### Two-sided test for beta0 and beta1 using
### summary() of fit object 
summary(fit)$coef

### 2) Inference for E{Y_h}

### Let's find a 95% confidence interval of E{Y_h} when using
### EXISTING observation X_h=100 units.

newx = data.frame(Size=100)
predict.lm(fit, newx, interval="confidence",level=.95)

### When X_h = 45, 80, 105

newx = data.frame(Size=c(45, 80, 105))
predict.lm(fit, newx, interval="confidence",level=.95)


### 3) Prediction for a new observation
### Suppose  NEW observation consists of X_h=100 units, 
### we want a 95% confidence interval

newx = data.frame(Size=100)
predict.lm(fit, newx, interval="prediction",level=.95)

### When X_h = 45, 80, 105

newx = data.frame(Size=c(45, 80, 105))
predict.lm(fit, newx, interval="prediction",level=.95)


### To construct Confidence Band's
### First we need the fitted values and 
### their standard errors for all the observations. 
 
CI = predict(fit, se.fit=TRUE)

### We also need the Working-Hotelling multiplier
### For a 95% band, we use

W = sqrt(2*qf(0.95, 2, n-2))

### n-2 is the degrees of freedom
### Now we have R calculate the upper and lower bounds 
### of the confidence band for each observation

Low.Band = CI$fit - W*CI$se.fit
Up.Band = CI$fit + W*CI$se.fit
Band = cbind(Low.Band, Up.Band)

### Make a Scatterplot of the original data and 
### then add the regression line.
### We also add a Title using main = "" , 
### x,y axis labels using xlab = "", ylab = ""
### change the point symbol using pch = ""

plot(toluca$Size, toluca$Hours, pch=19, xlab="Lot Size",
    ylab="Hours", main="Confidence Band for Toluca Data")
abline(fit, col = "red" )

### Superimpose the confidence band
### Since the estimated regression line has positive slope
### we sort the columns of Band in increasing order.
### However, if the estimated slope is negative,
### you need to sort the columns of band in decreasing order.
points(sort(toluca$Size), sort(Band[,1]), type="l", lty=3, col = "blue")
points(sort(toluca$Size), sort(Band[,2]), type="l", lty=3, col = "blue")

### add a 90% confidence band
W90 = sqrt(2*qf(0.90, 2, n-2))
Band90 = cbind(CI$fit - W90*CI$se.fit, CI$fit + W90*CI$se.fit)
points(sort(toluca$Size), sort(Band90[,1]), type="l", lty=2, col = "green")
points(sort(toluca$Size), sort(Band90[,2]), type="l", lty=2, col = "green")


### Add a legend
legend("topleft", c("95% Band", "90% Band" ), 
    col = c("blue", "green"), lty = c(2, 3))


### ANOVA Table for Regression
anova(fit)
summary(fit)




#############################
### You can also calculate the least square estimates by hand 
#############################
x = toluca[,1] 
y = toluca[,2]
n = length(x)
xmean = mean(x) 
ymean = mean(y)
b1 = sum((x-xmean)*(y-ymean))/sum((x-xmean)^2)
b0 = ymean - b1 * xmean


### Residuals

resi = fit$residuals

### Compute SSE, MSE 
SSE = sum(resi^2)
MSE = SSE/(25-2)

### Inference for beta1
sb1sq = MSE/sum((x-xmean)^2)
sb1 = sqrt(sb1sq)

### 95% confidence interval
qt975 = qt(0.975, df=23)

b1 - qt975 * sb1
b1 + qt975 * sb1

### two side test for beta1
tstar = b1/sb1
data.frame(tstar, qt975)
## Threshold hold for tstar = qt975
## here tstar > qt975, Reject H_0, accept H_a

### p value
2*(1-pt(tstar, df=23))

#### Inference for beta0
sb0sq = MSE*(1/n+xmean^2/sum((x-xmean)^2))
sb0 =sqrt(sb0sq)

b0 - qt975 * sb0
b0 + qt975 * sb0

