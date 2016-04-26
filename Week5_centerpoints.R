#################
rm(list=ls())

### Using FrF2 package in R to create fractional designs
library(FrF2)

## create the 2^2 design
planEx3.4 = FrF2(nruns = 4, nfactors = 2, randomize = FALSE)

## add the response data
y = c(39.3, 40.9, 40, 41.5)
planEx3.4 <- add.response(planEx3.4, y)

## analysing this design
MEPlot(lm(y~(.)^2, planEx3.4 ))
IAPlot(lm(y~(.)^2, planEx3.4 ))
DanielPlot(lm(y~(.)^2,planEx3.4 ), half=TRUE, alpha=0.2)

## data at center points
yC = c(40.3, 40.5, 40.7, 40.2, 40.6)

## use distribute=1, because all center points are run at the end
planEx3.4c = add.center(planEx3.4, ncenter=5, distribute = 1)

y = c(y,yC)
# add to the design
planEx3.4c  <- add.response(planEx3.4c, y, replace=TRUE)

## check

## sanity check: repeat previous analyses for comparison, with the help of function iscube()
MEPlot(lm(y~(.)^2, planEx3.4c, subset=iscube(planEx3.4c)))
IAPlot(lm(y~(.)^2, planEx3.4c, subset=iscube(planEx3.4c)))
DanielPlot(lm(y~(.)^2, planEx3.4c, subset=iscube(planEx3.4c)), half=TRUE, alpha=0.2)

curvature = iscube(planEx3.4c)

fit0 = lm(y ~(.)^2 + curvature, data = planEx3.4c)
anova(fit0)

# The analysis of variance indicates that both factors exhibit
# significant main effects, that there is no interaction, and
# that there is no evidence of curvature in the response over
# the region of exploration.
# The null hypotheses of no curvature cannot be rejected.

# FO model with interaction
fit1 = lm(y ~A + B + A*B, data = planEx3.4c)
anova(fit1)

# FO model with no interaction
fit2 = lm(y ~A + B, data = planEx3.4c)
anova(fit2)

# check the difference in sum of squares for the two nested models
anova(fit2, fit1)
# differencve of 0.0025 - negligible amount

# We conclude that there was no indication
# of quadratic effects and interaction; that is, a first-order model is appropriate.

eff.size2 = coef(fit2)[-1]*2

#############


