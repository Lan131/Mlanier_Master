
### Fractional Factorial Design
### Example 4.1
rm(list = ls())

y = c(45,71,48,65,68,60,80,65,43,100,45,104,75,86,70,96)

lv = c(-1,1)

X1 =  expand.grid(A=lv,B=lv,C=lv,D=lv)

dat.full = cbind(X1,y)

### Suppose we only use half of the data points
### using a one-half fraction using runs with
### design relation I=ABCD (positive)

###############################
### Set Defining Relation
###############################

## set defining relation to I = ABCD
attach(X1) ## make A, B, C, and D global variables
DR = A*B*C*D
detach(X1) ## remove A, B, C, and D global variables

## use which() to return index of DR = +1 
## pfrac is the row index of principal fraction
pfrac = which(DR == "1")

## extract rows of principal fraction from data
dat.frac = dat.full[pfrac,]

### Compare effect size estimates from data using full design
### and data using one-half fraction design

## full design
fit.full0 = lm(y ~ A*B*C*D, data = dat.full)
summary(fit.full0)
eff_f0 = coef(fit.full0)[-1]*2
abs.eff = abs(eff_f0)
abs.eff[order(abs.eff, decreasing = T)]

## large effects in order: A, AC, AD, D, C



## fractional design
## The estimated effect sizes for fractional designs
## are alias with other effect (see discussion on how to find alias effects)
fit.frac0 = lm(y ~ A*B*C*D, data = dat.frac)
summary(fit.frac0)
eff_fr0 = coef(fit.frac0)[-1]*2
abs.effr = abs(eff_fr0)
abs.effr[order(abs.effr, decreasing = T)]

## Large effects observed in order: A, BC, AC, D, C
## Similar large effect, except for BC which is aliased with AD,  
## are observed under fractional design.
## Note that if we include BC in the final model
## under fractional design, we need to include the main effect B also.
## Since BC is aliased with AD, then its possible that the large effect
## for BC observed in this fractional data is really due to AD.
## Thus, we use AD in the final model instead of BC. 
## We also avoided introducing the insignificant main effect B in the final model.


## fitting a linear model with the observed effects as predictor
fit.full1 = lm(y ~ A + C + D + A*C + A*D, data = dat.full)
summary(fit.full1)
ef.full = coef(fit.full1)[-1]*2

## The estimated effect sizes for fractional designs
## are alias with other effect (see discussion on how to find alias effects)
fit.frac1 = lm(y ~ A + C + D + A*C + A*D, data = dat.frac)
summary(fit.frac1)
ef.frac = coef(fit.full1)[-1]*2

data.frame(ef.full,ef.frac)

## Nevertheless, both full design and fractional design suggested
## similar (close) effects as influential/significact in explaining
## the behavior of the response.
## Albeit for one half (even less) the cost for fractional designs compared
## to full factorial designs.
