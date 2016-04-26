####
rm(list = ls())

### Table 3.7
y = c(45,71,48,65,68,60,80,65,43,100,45,104,75,86,70,96)

lv = c(-1,1)

X1 =  expand.grid(A=lv,B=lv,C=lv,D=lv)
### make A, B, C, and D global variables
attach(X1)

fit0 = lm(y~A*B*C*D)

summary(fit0)
eff.size = coef(fit0)[-1]*2

### rank the absolute value of the effect sizes
abs.eff = abs(eff.size)
rr = rank(abs.eff)
data.frame(abs.eff=abs.eff,rr=rr)
qq = qqnorm(abs.eff)

### Example 3.6
### Confound the highest-order interaction ABCD with blocks
block = A*B*C*D

fit1 = lm(y ~ block + A + C + D + A*C + A*D)

anova(fit1)

