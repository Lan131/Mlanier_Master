rm(list = ls())
library(lmSupport)
pres = read.csv("presidents.csv",header=T)
names(pres)
attach(pres)
pairs(pres)
options(digits=2)

### Model 1

model1 = lm(Historians.rank ~ Age.at.inauguration + Age.at.death 
            + Length.of.Retirement + factor(War))
summary(model1)
anova(model1)
vif(model1)

### Model 2
model2 = lm(Historians.rank ~ Years.in.Office + factor(Attempt) 
                           + factor(War))
summary(model2)

### Remove NA in both Age at death and Lenght of Retirement
pres[38:42,]
Age.at.death.N = Age.at.death[!is.na(Age.at.death)]
Length.of.Retirement.N = Length.of.Retirement[!is.na(Length.of.Retirement)]
cor(Age.at.death.N,Length.of.Retirement.N)
plot(Age.at.death.N,Length.of.Retirement.N, col = "red", pch=19)


### Model 1 without Age.at.death

model1.New = lm(Historians.rank ~ Age.at.inauguration  
                + Length.of.Retirement + factor(War))
summary(model1.New)
vif(model1.New)
