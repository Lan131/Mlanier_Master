#################
rm(list=ls())

### Using FrF2 package in R to create fractional designs
library(FrF2)

## create the 2^2 design
plan = FrF2(nruns = 4, nfactors = 2, randomize = FALSE)

## add the response data
y = c(39.3, 40.9, 40, 41.5)
plan <- add.response(plan, y)


## data at center points
yC = c(40.3, 40.5, 40.7, 40.2, 40.6)

## use distribute=1, because all center points are run at the end
plan1 = add.center(plan, ncenter=5, distribute = 1)

y = c(y,yC)
# add to the design
plan1  <- add.response(plan1, y, replace=TRUE)

## check

curvature = iscube(plan1)

fit0 = lm(y ~(.)^2 + curvature, data = plan1)
anova(fit0)

# The analysis of variance indicates that both factors exhibit
# significant main effects, that there is no interaction, and
# that there is no evidence of curvature in the response over
# the region of exploration.
# The null hypotheses of no curvature cannot be rejected.

# FO model with interaction
fit1 = lm(y ~A + B + A*B, data = plan1)
anova(fit1)

# FO model with no interaction
fit2 = lm(y ~A + B, data = plan1)
anova(fit2)

# check the difference in sum of squares for the two nested models
anova(fit2, fit1)
# differencve of 0.0025 - negligible amount

# We conclude that there was no indication
# of quadratic effects and interaction; that is, a first-order model is appropriate.


#############
### load this graphing package rgl
library(rgl)

summary(fit2)

plan1
A = plan1$A
B = plan1$B
y = plan1$y
## Plot a scatterplot 3d
plot3d(A,B,y, type="s", col="red", size=1)

coefs <- coef(fit2)
b1 <- coefs["A"]
b2 <- coefs["B"]
b3 <- -1
b0 <- coefs["(Intercept)"]
## superimpose the response surface plane
planes3d(b1, b2, b3, b0, alpha=0.5)


## use clipplanes to cut the space into two regions
open3d()
plot3d(A,B,y, type="s", col="red", size=1)
clipplanes3d(b1, b2, b3, b0)


### Let's plot the design together with the path of ascent
m = b2/b1
plot(A,B)
abline(a=0,b=m, col="red")
text(0, -0.6, expression(x[2] == frac(.325, .775)*x[1]))



### Responses at the points along the PSA
yPSA = c(41,42.9,47.1,49.7,53.8,59.9,65.0,70.4,77.6,80.3,76.2,75.1)
PSA.Steps = seq(1,length(yPSA))
plot(PSA.Steps,yPSA,type="b", ylab = "Yield", ylim = c(40,90))
abline(v=10, col="blue", lty=2)
abline(h=yPSA[10], col="blue", lty=2)


### Second PSA Experiment

## create the 2^2 design
plan2 = FrF2(nruns = 4, nfactors = 2, randomize = FALSE)

y2 = c(76.5,77,78,79.5,79.9,80.3,80,79.7,79.8)
## use distribute=1, because all center points are run at the end
plan2 = add.center(plan2, ncenter=5, distribute = 1)

# add to the design
plan2  <- add.response(plan2, y2)

## check

curvature = iscube(plan2)

fit.new = lm(y2 ~(.)^2 + curvature, data = plan2)
anova(fit.new)

## First-Order Model
# FO model with no interaction
fit.new1 = lm(y2 ~ A + B, data = plan2)
summary(fit.new1)

