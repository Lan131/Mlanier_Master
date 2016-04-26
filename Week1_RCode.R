### Week 1 Lecture Code

rm(list = ls())
dat <- expand.grid( t=c(-1,1), c=c(-1,1), k=c(-1,1))
dat$y <- c(60,72,54,68,52,83,45,80)
dat
#pp = c(8.6, 22.4, 36.2, 56.9, 56.9, 77.6, 91.38)
eff.size = c(-5, 0, 0.5, 1.5, 10, 23)
cpercent  = c(7.1,21.4,35.7,57.1,78.6,92.9)/100
q.norm = qnorm(cpercent)
runs = c("c","ck","tck","tc & k","tk","t")

## Probability Plot
plot(q.norm, eff.size,  ylab = "Effect Size", xlab="Normal Score",
     main = "Probability Plot of Effect Sizes",
     xlim = c(-2,2), ylim = c(-10,30), pch=19, col="red")
text(q.norm, eff.size,  runs, pos=3)
qqline(q.norm)

## Half-Normal Plot
library(fdrtool)
abs.eff = c(0, 0.5, 1.5, 5, 10, 23)
#abs.cper  = c(7.1,21.4,35.7,56.9,77.6,92.9)/100
new.cper = c(7.1,21.4,42.6,64.3,78.6,92.9)/100
abs.runs = c("ck","tck","tc & k","c","tk","t")
abs.norm = qhalfnorm(new.cper)
plot(abs.norm, abs.eff,  ylab = "Effect Size", xlab="Half Normal Score",
     main = "Half-Normal Plot of Effect Sizes",
     xlim = c(0,1.9), ylim = c(0,30), pch=19, col="red")
text(abs.norm, abs.eff,  abs.runs, pos=3)
qqline(abs.norm)




##### Computing Effect Sizes using
##### the Regression Model

##### Pilot Plant Investigation

dat
fit = lm(y~t*c*k,data=dat)
summary(fit)
# effect sizes
effects = coef(fit)[-1]*2
es = round(effects, digits = 2)
# Sum of Squares
SS = (es*4)^2/8
SStot = sum(SS)
data.frame(es,SS)


##### LR by Hand
rm(list = ls())
Xb =  expand.grid(t=c(-1,1),c=c(-1,1),k=c(-1,1))
xtc = Xb$t*Xb$c
xtk = Xb$t*Xb$k
xck = Xb$c*Xb$k
xtck = Xb$t*Xb$c*Xb$k
X = cbind(x0=1,Xb,xtc,xtk,xck,xtck)
X = as.matrix(X)
y = c(60,72,54,68,52,83,45,80)
t(X)%*%X
t(X)%*%y
b = solve(t(X)%*%X)%*%t(X)%*%y
# reg coefficients
b
# effect sizes
es = b[-1]*2
# Sum of Squares
SS = (es*4)^2/8
SStot = sum(SS)
data.frame(es,SS)


#### Using Doe.Base and FRF2 package in R
library(DoE.base)
library(FrF2)

plant.23design <- 
  fac.design(nfactors = 3, replications = 1, randomize = FALSE, 
             factor.names = list(t = c(-1, 1), c = c(-1, 1), k = c(-1, 1)))

y = c(60,72,54,68,52,83,45,80)

plant.23design <- add.response(design = plant.23design, response = y)

### Plot main effects and interactions
MEPlot(plant.23design)
IAPlot(plant.23design)

### Regression Model
### Regression
plant.lm <- lm(y ~ t * c * k, data = plant.23design)
summary(plant.lm)

effects = coef(plant.lm)[-1]*2
es = round(effects, digits = 2)
# Sum of Squares
SS = (es*4)^2/8
SStot = sum(SS)
data.frame(es,SS)


######## Example 3.1

etch.d <- 
  fac.design(nfactors = 3, replications = 2, randomize = FALSE, 
             factor.names = list(A = c(-1, 1), B = c(-1, 1), C = c(-1, 1)))

y = c(247,470,429,435,837,551,775,660,400,446,405,445,850,670,865,530)

etch.d <- add.response(design = etch.d, response = y)

### Plot main effects and interactions
MEPlot(etch.d)
IAPlot(etch.d)

fit.etch <- lm(y ~ A*B*C, data=etch.d)

summary(fit.etch)
anova(fit.etch)

effects = coef(fit.etch)[-1]*2
es = round(effects, digits = 2)
# Sum of Squares
SS = (es*8)^2/16
SStot = sum(SS)
data.frame(es,SS)

# predicted response or yhat
yhat = fit.etch$fitted.values
res = fit.etch$residuals
data.frame(y,yhat,res)

# normal probability plot
qqnorm(res, pch=19, col="red")
qqline(res)



######## Exercise 3.2

life.d <- 
  fac.design(nfactors = 3, replications = 2, randomize = FALSE, 
             factor.names = list(A = c(-1, 1), B = c(-1, 1), C = c(-1, 1)))

life = c(22,32,35,55,44,40,60,39,31,43,34,47,45,37,50,41)

life.d <- add.response(design = life.d, response = life)

fit.life <- lm(life ~ A*B*C, data=life.d)

summary(fit.life)

effects = coef(fit.life)[-1]*2
es = round(effects, digits = 2)
# Sum of Squares
SS = (es*8)^2/16
SStot = sum(SS)
data.frame(es,SS)
