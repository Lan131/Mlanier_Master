rm(list = ls())
library(rsm)
library(AlgDesign)
library(DoE.wrapper)
library(VdgRsm)
library(FrF2)


#Problem 1
dat=read.table("matrix1.txt", header=TRUE)


eval.design(~ x1 + x2 + x3 + x1*x3+x1*x2+x2*x3, dat)
# these can be assigned to variables
D.eff.lin <- eval.design(~ x1 + x2 + x3 + x1*x3+x1*x2+x2*x3, dat)$determinant
# note that A-efficiency is 1/A given from eval.design()
A.eff.lin <- 1 / eval.design(~ x1 + x2 + x3 + x1*x3+x1*x2+x2*x3, dat)$A
c(D.eff.lin, A.eff.lin)




#Problem 2

#part a
desi <- expand.grid(x1 = seq(-1, 1, by = 1)
                                  , x2 = c(-1,0, 1)
                                  , x3 = c(-1,0, 1)
                                  , x4 = c(-1,0, 1))
D.candidate.points=rbind(desi,c(2,0,0,0)
                         ,c(-2,0,0,0)
                         ,c(0,2,0,0)
                         ,c(0,-2,0,0)
                         ,c(0,0,2,0)
                         ,c(0,0,-2,0)
                         ,c(0,0,0,2)
                         ,c(0,0,0,-2)
                             ,c(0,0,0,0))
D.candidate.points
# choose the 30 points based on D-criterion

D.gen <- optFederov(~ x1 + x2 + x3 + x4 + x1^2 + x2^2+ x3^2+ x4^2 + x1*x2+x1*x3+x1*x4+x2*x3+x2*x4+x3*x4, D.candidate.points, nTrials = 30
                    , criterion = "D", evaluateI = TRUE, maxIteration = 1e4, nRepeats = 1e2)
D.gen

eval.design(~ x1 + x2 + x3 + x4 + x1^2 + x2^2+ x3^2+ x4^2 + x1*x2+x1*x3+x1*x4+x2*x3+x2*x4+x3*x4, D.gen)
# these can be assigned to variables
D.eff.lin <- eval.design(~ x1 + x2 + x3 + x1*x3+x1*x2+x2*x3, dat)$determinant
# note that A-efficiency is 1/A given from eval.design()
A.eff.lin <- 1 / eval.design(~ x1 + x2 + x3 + x1*x3+x1*x2+x2*x3, dat)$A
c(D.eff.lin, A.eff.lin)


#part b
desiccd = expand.grid(x1 = seq(-1, 1, by = 1)
                    , x2 = c(-1,0, 1)
                    , x3 = c(-1,0, 1)
                    , x4 = c(-1,0, 1))
desiccd2=rbind(desiccd,c(2,0,0,0)
                                       ,c(-2,0,0,0)
                                       ,c(0,2,0,0)
                                       ,c(0,-2,0,0)
                                       ,c(0,0,2,0)
                                       ,c(0,0,-2,0)
                                       ,c(0,0,0,2)
                                       ,c(0,0,0,-2))
desiccd2
for(i in 1:6)
{
  desiccd2=rbind(desiccd2,c(0,0,0,0))
 
}

finalccd=desiccd2

par(mfrow = c(2,2)) # plot of 2x2 panels 

as.data.frame(varfcn(D.gen$design,~ x1 + x2 + x3 + x4 + x1^2 + x2^2+ x3^2+ x4^2 + x1*x2+x1*x3+x1*x4+x2*x3+x2*x4+x3*x4 ,plot=FALSE))


as.data.frame(varfcn(finalccd, ~ x1 + x2 + x3 + x4 + x1^2 + x2^2+ x3^2+ x4^2 + x1*x2+x1*x3+x1*x4+x2*x3+x2*x4+x3*x4,plot=FALSE))
varfcn(D.gen$design,~ x1 + x2 + x3 + x4 + x1^2 + x2^2+ x3^2+ x4^2 + x1*x2+x1*x3+x1*x4+x2*x3+x2*x4+x3*x4 ,plot=TRUE,main="D Optimal")
varfcn(finalccd, ~ x1 + x2 + x3 + x4 + x1^2 + x2^2+ x3^2+ x4^2 + x1*x2+x1*x3+x1*x4+x2*x3+x2*x4+x3*x4,plot=TRUE,main="CCD")

#At zero the CCD design is better.
V=as.matrix(D.gen$design)
V

#Part B
#as.data.frame(varfcn(D.gen$design,~ x1 + x2 + x3 + x4 + x1^2 + x2^2+ x3^2+ x4^2 + x1*x2+x1*x3+x1*x4+x2*x3+x2*x4+x3*x4 ,plot=FALSE,x1 = seq(-1, 1, by = 1),x2 = seq(-1, 1, by = 1),x3 = seq(-1, 1, by = 1),x4 = seq(-1, 1, by = 1),dist = seq(-1, 1, by = 1)))
#J=as.data.frame(varfcn(D.gen$design,~ x1 + x2 + x3 + x4 + x1^2 + x2^2+ x3^2+ x4^2 + x1*x2+x1*x3+x1*x4+x2*x3+x2*x4+x3*x4 ,plot=FALSE,vector=V,dist=1))
as.data.frame(varfcn(D.gen$design,~ x1 + x2 + x3 + x4 + x1^2 + x2^2+ x3^2+ x4^2 + x1*x2+x1*x3+x1*x4+x2*x3+x2*x4+x3*x4 ,plot=FALSE, contour = FALSE))
spv(finalccd,D.gen$design,des.names=c("CCD","D Optimal"))
as.data.frame(spv(finalccd,D.gen$design,des.names=c("CCD","D Optimal")))

#The CCD design is better in terms of average SPV.


#Problem 3
tauguchi=FrF2(nruns=16,nfactors=4)
y=c(500,669,604,650,633,642,601,635,1037,749,1052,868,1075,860,1063,729)

tauguchiy=cbind(tauguchi,y)
tauguchiy
fit=lm(y~A*B,data=tauguchiy)
fit

MEPlot(fit)
IAPlot(fit)

write.csv(tauguchiy, "E:/Taguchi.csv")

#To maximize the SNR we pick low A (.8 cm anode- cathode gap) and large B 550 mTorr power to cathode. to maximize etch rate.

#Problem 4
mix=read.table("mixdat.txt")
mix  
names(mix)=c("x1","x2","x3","y")  
mix
  
  
# fit first-order model
#   the ~ 0 in the formula indicates no intercept will be fit
fit.FO = lm(y ~ 0 + x1 + x2 + x3, data = mix)
summary(fit.FO)
anova(fit.FO)
plot(fit.FO)

#The linear model is highly significent and the factors are all significent. There are no major diagnostic issues.

fit.Q = lm(y ~ 0 + x1 + x2 + x3+ x1*x2+x1*x3+x3*x2, data = mix)
summary(fit.Q)
anova(fit.Q)
plot(fit.Q)

#Quadaratic terms not significent.

anova(fit.FO,fit.Q)

#No significent difference in the models.

BIC(fit.FO)
BIC(fit.Q)

#BIC criterion pick first order model

#part c

# create a grid over x1 and x2
x <- seq(0, 1, by = 0.01)
x1 <- x; x2 <- x; # for plotting labels

grid.x123 <- expand.grid(x1 = x
                         , x2 = x
                         , x3 = NA)
grid.x123$x3 <- 1 - (grid.x123$x1 + grid.x123$x2)
# set any x3 < 0 to NA
grid.x123[(grid.x123$x3 < 0),] <- NA

predict.fit.FO   <- predict(fit.FO   , newdata = grid.x123)
predict.fit.Q  <- predict(fit.Q , newdata = grid.x123)


par(mfrow = c(1,2))
image  (x = x1, y = x2, z = matrix(predict.fit.FO  , nrow = length(x)), main = "First order")
contour(x = x1, y = x2, z = matrix(predict.fit.F0  , nrow = length(x)), add = TRUE)
image  (x = x1, y = x2, z = matrix(predict.fit.Q , nrow = length(x)), main = "quadratic")
contour(x = x1, y = x2, z = matrix(predict.fit.Q , nrow = length(x)), add = TRUE)