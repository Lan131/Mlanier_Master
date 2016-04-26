####
rm(list = ls())

b0 = 78.8988
b = c(2.272,3.496)
Bhat = matrix(c(-2.08,-1.44,-1.44,-2.92), nrow = 2, byrow=T)
eigen(Bhat)

# eigenvalues
lambda = eigen(Bhat)$values

# eigenvectors
P = eigen(Bhat)$vectors

w1 = P[,1]
w2 = P[,2]

Bhat%*%w1 
lambda[1]%*%w1

P%*%t(P)

Delta = diag(lambda)

## stationary point
xs = -0.5*solve(Bhat)%*%b

## maximum response at xs
ys = b0 + 0.5*t(xs)%*%b



