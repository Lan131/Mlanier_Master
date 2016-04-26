### Matrix Computations in R
A = matrix(c(1,-1,-1,2),nrow=2)
B = matrix(c(3,2,2,-1),nrow=2)
C = matrix(c(1,0.5,-0.5,0.5,1,-0.5,-0.5,-0.5,1),nrow=3)
A+B # sum
A%*%B # matrix multiplication, enclose "*" with "%"
C = matrix(c(1,0.5,-0.5,0.5,1,-0.5,-0.5,-0.5,1),nrow=3) # 3 by 3 matrix
One3 = rep(1,3) # vector of one 
One3
t(One3)%*%C
solve(A) # matrix inverse 
A%*%solve(A) # verify 

#### Linear Regression in Matrix Form and Matrix Computations
dat = read.table("toluca.txt")
X1 = dat[,1]
Y = dat[,2]
n = length(Y) 
One = rep(1,n) 
X = cbind(One,X1)

## Least Squares Estimators
t(X)%*%X
t(X)%*%Y
b = solve(t(X)%*%X)%*%t(X)%*%Y # LSE
b
Yhat = X%*%b # fitted Y values
resi = Y-Yhat # residuals
head(cbind(Y,Yhat,resi))
SSE = t(resi)%*%resi 
MSE = SSE/(n - 2)
SSTO = t(Y-mean(Y))%*%(Y-mean(Y))
SSR = SSTO - SSE
data.frame(SSTO,SSE,SSR)