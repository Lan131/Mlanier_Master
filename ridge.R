WT

train=head(WT,20)
test=tail(WT,10)
train
fit=lm(Y~.,data=train)
summary(fit)

vif(fit)
fitR=lm.ridge(Y ~ ., data=train, lambda = seq(0,.5,0.001))
fitR
plot(fitR)
select(fitR)
fitR=lm.ridge(Y ~ ., data=WT, lambda = .223)
fitR
A=predict(fit,test)
B=scale(test[,1:2],center = F, scale = fitR$scales)%*% fitR$coef
J=as.data.frame(test[,3]-A)
K=as.data.frame(test[,3]-B)
A

#In testing the difference in LSE vs Ridge is 39025 absolutly.



fit = bestglm(train,IC='AIC')
fit$Subsets
fitstep=lm(train[,3]~X2, data=train)
fitstep
summary(fitstep)
