###

DesX = cbind(c(0,-1.4,0,1.4),c(1.4,0,-1.4,0),c(-1,1,-1,1))

y = c(8.52,9.76,7.38,12.5)

DesX = data.frame(DesX,y)

colnames(DesX) = c("x1","x2","x3","y")


fit0 = lm(y~., data=DesX)

coef(fit0)
