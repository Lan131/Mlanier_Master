rm(list = ls())  # clear list

## Bonferroni Joint Estimation of beta_0 and beta_1

toluca = read.table("toluca.txt",header=F)
names(toluca) = c("Size", "Hours")
attach(toluca)


lm.fit=lm(Hours~Size, data = toluca)
confint(lm.fit,level=.90)

#  Direct Function;  You can make the Bonferroni adjustment here
confint(lm.fit,level=(1-.10/2))  	# In general, confint(results,level=(1-alpha/k))	

## bY hAND

coefficients(summary(lm.fit))

b0=coefficients(summary(lm.fit))[1,1]  # Extracting the value of b0
se.b0=coefficients(summary(lm.fit))[1,2]	# The standard error of b0

b1=coefficients(summary(lm.fit))[2,1]	# Extracting the value of b1
se.b1=coefficients(summary(lm.fit))[2,2] # The standard error of b1

# The 90% joint confidence intervals for beta_0 and beta_1:
B=qt(1-.10/(2*2),df=23)				# In general, B=qt(1-.10/(2*k),df), k=no. of intervals
lower.b0=b0-B*se.b0;  upper.b0=b0+B*se.b0
lower.b1=b1-B*se.b1;  upper.b1=b1+B*se.b1

rbind(c(lower.b0,upper.b0),c(lower.b1,upper.b1))


## Simultaneous Estimation of Mean Responses

new=data.frame(Size=c(30,65,100))

# Direct Function: you can make the Bonferroni adjustment here
predict(lm.fit,new,interval="confidence",level=(1-.10/3))

# BY HAND
ci=predict(lm.fit,new,interval="confidence",se.fit=T,level=0.9)   
# This will give you the fitted values and their corresponding SE.mean with 90% CL

# Using Working-Hotelling Procedure 
# to constuct 90% joint confidence intervals for the mean response at the 3 x levels.
W2=2*qf(1-.10,2,23)
W=sqrt(W2)    	# equals 2.258003

ci$fit[1]-W*ci$se[1]; ci$fit[1]+W*ci$se[1]	# at size=30
ci$fit[2]-W*ci$se[2]; ci$fit[2]+W*ci$se[2]	# at size=65
ci$fit[3]-W*ci$se[3]; ci$fit[3]+W*ci$se[3]	# at size=100


## Working-Hotelling Confidence Band

# mu.hat +/- W*SE.mu.hat, where W^2=2*F(1-alpha;2,n-2) 

ci.band=predict(lm.fit, se.fit=TRUE,level=0.9) 	# This will give you the fitted values and their corresponding SE.mean with 90% CL
SE.mean=ci.band$se.fit

llW=ci.band$fit-W*SE.mean
ulW=ci.band$fit+W*SE.mean

plot(x = Size, y = Hours, xlab="Size of Plot", ylab="Number of Hours", main="Confidence Band for Toluca Data")
abline(lm.fit$coefficients[1], lm.fit$coefficients[2],col="darkred",lwd=2)

points(sort(Size), sort(llW), type="l", lty=2, col="blue")	# Superimposes the ll
points(sort(Size), sort(ulW), type="l", lty=2, col="blue")	# Superimposes the ul




# Using Bonferroni Procedure
B=qt(1-.10/(2*3),23)


llB=ci$fit-B*SE.mean
ulB=ci$fit+B*SE.mean

ci$fit[1]-B*ci$se[1]; ci$fit[1]+B*ci$se[1]	# at size=30
ci$fit[2]-B*ci$se[2]; ci$fit[2]+B*ci$se[2]	# at size=65
ci$fit[3]-B*ci$se[3]; ci$fit[3]+B*ci$se[3]	# at size=10




## Simultaneous Estimation of Mean Responses

MSE=anova(lm.fit)$Mean[2]

new=data.frame(Size=c(80,100))
ci=predict(lm.fit,new,interval="prediction",se.fit=T,level=0.9)

se.fit.pred=sqrt(MSE*(1+(ci$se.fit^2/MSE)))

# Scheffe Procedure
S=sqrt(2*qf(1-.05,2,23))		# In general, use S=sqrt(k*qf(1-.05,k,n-2))
# If k=2:10, look at plot(k,sqrt(k*qf(1-.05,k,n-2)))
lwr.scheffe=ci$fit[,1]-S*se.fit.pred
upr.scheffe=ci$fit[,1]+S*se.fit.pred
cbind(ci$fit[,1],lwr.scheffe,upr.scheffe)

# Direct Function ; Bonferroni Procedure
ci.bon=predict(lm.fit,new,interval="prediction",level=(1-.05/2))




## Regression through Origin

warehouse=read.table("warehouse.txt",header=F)	# Example in the book (page 162)
names(warehouse) = c("Units","Cost")
attach(warehouse)

n=length(Cost)
b1=sum(Units*Cost)/sum(Units^2)
fitted=b1*Units
residuals=Cost-fitted
SSE=sum(residuals^2)
MSE=SSE/(n-1)
se.b1=sqrt(MSE/sum(units^2))

# The 95% C.I. for beta_1 is 
lwr=b1-qt(.975,n-1)*se.b1
upr=b1+qt(.975,n-1)*se.b1
