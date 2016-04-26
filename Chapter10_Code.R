###body fat

dat = read.table('fat.txt')
X1 = dat[,1]
X2 = dat[,2]
X3 = dat[,3]
Y = dat[,4]
fit = lm(Y~X1+X2)   
n = nrow(dat)


###Added Variable Plot 
resi = fit$resi
par(mfrow=c(2,2))

fit2 = lm(Y~X2)
fit12 = lm(X1~X2)
fit1 = lm(Y~X1)
fit21 = lm(X2~X1)
plot(X1,resi,main='Residual Plot Against X1')    
plot(fit12$resi,fit2$resi, main='Added Variable Plot for X1')
abline(lm(fit2$resi~fit12$resi))
plot(X2,resi,main='Residual Plot Against X2')
plot(fit21$resi,fit1$resi, main='Added Variable Plot for X2')     
abline(lm(fit1$resi~fit21$resi))

###Examine outlying Y observations
elist = fit$resi
p = 3 
SSE = sum(elist^2)
X = cbind(1,X1,X2)
hlist = diag(X%*%solve(t(X)%*%X)%*%t(X))
tlist = elist*((n-p-1)/(SSE*(1-hlist)-elist^2))^(1/2)
cbind(elist,hlist,tlist)
max(abs(tlist))
qt(0.9975,n-p-1)

###Identifying outlying X observations
2*p/n
hlist  ##Case 3 and 15 larger than 2p/n

###Identifying influential cases
MSE = SSE/(n-p)
DFFITS = tlist * (hlist/(1-hlist))^0.5
Dlist = elist^2 /p/MSE*hlist/((1-hlist)^2)
clist = diag(solve( t(X)%*%X))
b = fit$coef
DFBETAS = matrix(0,n,p)
for(i in 1:n){
fiti = lm(Y[-i]~X1[-i]+X2[-i])
bi = fiti$coef
MSEi = sum(fiti$resi^2)/(n-1-p) 
DFBETAS[i,] = (b-bi)/sqrt(MSEi*clist)
}

###VIF
Xmat = cbind(X1,X2,X3)
VIF = diag(solve(cor(Xmat)))
VIF 
#  X1       X2       X3 
#708.8429 564.3434 104.6060 
Xmat = cbind(X1,X2)
VIF = diag(solve(cor(Xmat)))
VIF 


