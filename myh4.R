#myhw4
rm(list=ls())
#4.9
library(FrF2)
#I=ACE, I=BDE iff E=AC, D=BE iff E=AC, D=ABC
desi=FrF2(nruns = 8, nfactors = 5, generators=c("ABC","AC"), randomize = FALSE)
design.info(desi)
desi
y <- c( 23.2,16.9,16.8,15.5,23.8,23.4,16.2,18.1)
desi=add.response(desi,y)
fit=lm(y~(.)^2, desi)
summary(fit)
fit=lm(y~A+B+C+D+E+A*B+A*D, desi)
summary(fit)
eff.size = coef(fit)[-1]*2
eff.size
plot(fit)
DanielPlot(fit)
anova(fit)
fit1=lm(y~A+B+C+E+A*B, desi)
summary(fit1)
plot(fit1$fitted,fit1$resi)
#These residuals seem to have the constant error. There are no patterns so the linear estimate appears good. There are also no major outliers.

qqnorm(fit1$resi)
qqline(fit1$resi)
#4.10
yC = c(20.1,20.9,19.8,20.4)

## use distribute=1, because all center points are run at the end
desi = add.center(desi, ncenter=4, distribute = 1)

y = c(y,yC)
# add to the design
desi  <- add.response(desi, y, replace=TRUE)
fitC=lm(y~(.)^2, desi)
anova(fitC)
curvature = iscube(desi)
fitCC=lm(y~(.)^2+curvature, desi)
summary(fitCC)

fitCC=lm(y~A+B+C+D+A*D+curvature, desi)
summary(fitCC)
anova(fitCC)
#Model significent at alpha=.1, Curvature is not significent with p value .389. The model is twice
# as significent without the curvature. This means the best model to choose is one without the curvature.

fitNC=lm(y~A+B+C+D+A*D, desi)
summary(fitNC)

#4.11a
#I=ABD, I=BCE iff D=AB, E=BC
Mon=FrF2(nruns=8,nfactors=5, generators=c("AB","BC"), randomize = FALSE)
design.info(Mon)
Mon
y=c(95,134,158,190,92,187,155,185)
Mon=add.response(Mon,y)
fitM=lm(y~(.)^2,Mon)
summary(fitM)
fitM=lm(y~A+B+C+D+E+A*C+A*E,Mon)
effects=coef(fitM)[-1]*2
effects
summary(fitM)

#4.11c
Mon <- fold.design(Mon)
summary(Mon)
yC = c(189,154,135,96,193,152,137,98)

y = c(y,yC)
# add to the design
Mon <- add.response(Mon, y, replace=TRUE)
fitM=lm(y~(.)^2,Mon)
summary(fitM)
effects=coef(fitM)[-1]*2
effects

#4.11b
Mon=FrF2(nruns=8,nfactors=5, generators=c("AB","BC"), randomize = FALSE)
design.info(Mon)
Mon <- fold.design(Mon, column=1)
Mon
yC = c(136,93,187,153,139,99,191,150)

y = c(y,yC)
# add to the design
Mon <- add.response(Mon, y, replace=TRUE)
fitM=lm(y~(.)^2,Mon)
summary(fitM)
effects=coef(fitM)[-1]*2
effects