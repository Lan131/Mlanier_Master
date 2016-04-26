rm(list = ls())
dat = read.table('fat.txt')
colnames(dat) = c('triceps', 'thigh', 'midarm', 'bodyfat')
# matrix scatterplot
pairs(dat)

# correlation of predictor variables
cor(dat[,-4])


X1 = dat[,1]; X2 = dat[,2]; X3 = dat[,3]; Y = dat[,4]

# regress Y onto X1 only
fit1 = lm(Y~X1) 
anova(fit1)[,1:4] 
fit1
coef(summary(fit1))[,1:2]

# regress Y onto X1 and X2 
fit12 = lm(Y~X1+X2) 
anova(fit12)[,1:4] 
coef(summary(fit12))[,1:2]

# regress Y onto X2 only
fit2 = lm(Y~X2) 
anova(fit2)[,1:4] 

fit21 = lm(Y~X2+X1)
anova(fit21)[,1:4]

# regress Y onto X1, X2, and X3
fit123 = lm(Y~X1+X2+X3) 
anova(fit123)[,1:5] 


# coefficient of partial determination
anova(fit1,fit12)
anova(fit12,fit123)
anova(fit1,fit123)

###
## need to load this package "lmSupport" to access use vif() in R
library(lmSupport)

# Variance Inflation Factor to detect possible collinearity
vif(fit)
# Rule of Thumb is sqrt(VIF) > 10
sqrt(vif(fit)) > 10

## Check the VIF function for X1
## Regress X1 onto X2 and X3
lm1 = lm(X1 ~ X2 + X3)
## extract R2 from lm1
R21 = summary(lm1)$r.squared
1/(1-R21)
