rm(list = ls())
# package for response surface analysis
library(rsm)


## Read Example 6-3 data

dat6.3 = read.table("Example_6-3.txt",header=T)
str(dat6.3)


fit_6.3 = rsm(y ~ SO(x1, x2, x3, x4), data = dat6.3)
# externally Studentized residuals
fit_6.3$studres = rstudent(fit_6.3)
summary(fit_6.3)
# the stationary point:
summary(fit_6.3)$canonical$xs
canonical(fit_6.3)$xs
# just the eigenvalues and eigenvectors
summary(fit_6.3)$canonical$eigen
canonical(fit_6.3)$eigen

# The eigenvalues indicates a saddle point.
# They indicate that a ridge analysis might
# reveal reasonable candidates for operating conditions,
# with the implied constraint that the candidates lie 
# inside or on the boundary of the experimental design.


par(mfrow = c(2,3), oma = c(0,0,0,0), mar = c(4,4,2,0))
contour(fit_6.3, ~ x1 + x2 + x3 + x4, image=TRUE, 
           at = canonical(fit_6.3)$xs, 
           main = "through stationary point")

## The stationary point is just outside region of experimentation for x4.
## The contour plots go through the stationary point.
## The saddle is most apparent in the (x2, x3) plot.


# calculate predicted increase along ridge of steepest ascent
steepest.6.3 = steepest(fit_6.3, dist = seq(0, 2, by = 0.1))
# include SE of response in the table, too
predict.6.3 = predict(fit_6.3, 
                       newdata = steepest.6.3[,c("x1","x2","x3","x4")], se.fit = TRUE)
steepest.6.3$StdError = predict.6.3$se.fit
# steepest.6.3

###  latex output#
#library(xtable)
#xtab.out = xtable(steepest.6.3, digits=3)
#print(xtab.out, floating=FALSE, math.style.negative=TRUE)

###

par(mfrow = c(1, 2))
# plot expected response vs radius
plot(steepest.6.3$dist, steepest.6.3$yhat, pch = "y", 
     main = "Ridge plot: Estimated maximum +- SE vs radius")
points(steepest.6.3$dist, steepest.6.3$yhat, type = "l")
points(steepest.6.3$dist, steepest.6.3$yhat - predict.6.3$se.fit, type = "l", col = "red")
points(steepest.6.3$dist, steepest.6.3$yhat + predict.6.3$se.fit, type = "l", col = "red")
# plot change of factor variables vs radius
plot  (steepest.6.3$dist, steepest.6.3$x1, pch = "1", col = "red", 
         main = "Ridge plot: Factor values vs radius", 
         ylim = c(-2, 0.25))
points(steepest.6.3$dist, steepest.6.3$x1, type = "l", col = "red")
points(steepest.6.3$dist, steepest.6.3$x2, pch = "2", col = "blue")
points(steepest.6.3$dist, steepest.6.3$x2, type = "l", col = "blue")
points(steepest.6.3$dist, steepest.6.3$x3, pch = "3", col = "green")
points(steepest.6.3$dist, steepest.6.3$x3, type = "l", col = "green")
points(steepest.6.3$dist, steepest.6.3$x4, pch = "4", col = "purple")
points(steepest.6.3$dist, steepest.6.3$x4, type = "l", col = "purple")
