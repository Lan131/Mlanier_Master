##########################################
####### Fold-Over of a Fractional Design
####### Example 4.5
rm(list = ls())

lv = c(-1,1)

X1 =  expand.grid(A=lv,B=lv,C=lv)

attach(X1)

D = A*B
E = A*C
F = B*C
G = A*B*C

X = cbind(X1,D,E,F,G)

y= c(85.5, 75.1, 93.2, 145.4, 83.7, 77.6, 95, 141.8)

fit0 = lm(y ~ ., data = X)
summary(fit0)

eff.size = coef(fit0)[-1]*2

### rank the absolute value of the effect sizes
abs.eff = abs(eff.size)
rr = rank(abs.eff)
### Effects estimate by this fraction
data.frame(eff.size=eff.size,abs.eff=abs.eff,rr=rr)

# The largest three effects are [A], [B], and [D].
# Since A, B, and D are aliased with other effects then 
# saying A, B, and D are significant is misleading.
# Moreover, I = ABD is a defining relation in this fractional 
# design. Thus, D is confounded to the AB.
# Also, checking the alias structure of this design, we know that
# A is confounded to BD+CE+FG, B is confounded with AD+CF+EG, and
# D is confounded to AB+CG+EF.
# To separate the main effects and the two-factor
# interactions, a second fraction is run with all the signs
# reversed.

## reverse the sign (levels)
lvt = c(1,-1)

X1t =  expand.grid(At=lvt,Bt=lvt,Ct=lvt)
attach(X1t)
Dt = -At*Bt
Et = -At*Ct
Ft = -Bt*Ct
Gt = At*Bt*Ct

yt = c(91.3, 136.7, 82.4, 73.4, 94.1, 143.8, 87.3, 71.9)

Xt = cbind(X1t,Dt,Et,Ft,Gt)

fit1 = lm(yt ~ ., data = Xt)
summary(fit1)

eff.size1 = coef(fit1)[-1]*2

### rank the absolute value of the effect sizes
abs.eff1 = abs(eff.size1)
rr1 = rank(abs.eff1)
### Effects estimate by this fraction
data.frame(eff.size1=eff.size1,abs.eff1=abs.eff1,rr1=rr1)

# By combining the effect estimates from this second
# fraction with the effect estimates from the original eight
# runs, we obtain the following estimates of the effects

# main effects
main.effect = 0.5*(eff.size + eff.size1)
data.frame(main.effect = main.effect)

# two-way effects aliased
two.way.alias = 0.5*(eff.size - eff.size1)
names(two.way.alias) = c("BD+CE+FG","AD+CF+EG","AE+BF+DG",
                           "AB+CG+EF","AC+BG+DF","BC+AG+DE","CD+BE+AF" )
data.frame(two.way.alias=two.way.alias)

# The largest two effects are B and D.
# Furthermore, the third largest effect is BD + CE + FG, 
# so it seems reasonable to attribute this to the BD interaction.
# The analyst used the two factors distance (B) and illumination level (D) 
# in subsequent experiments with the other factors A, C, E, and
# F at standard settings and verified the results obtained 
# here. He decided to use subjects as blocks in these new 
# experiments rather than ignore a potential subject effect, 
# because several different subjects had to be used to 
# complete the experiment.
