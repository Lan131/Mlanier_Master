#################
rm(list=ls())
library(FrF2)
library(alr3) # needs this to breakdown anova table's residual SS into lack-of-fit and pure error



design3 = read.csv("3levdes.csv",header=T)

str(design3)

attach(design3)

x1 = (Concentration - 2)/1
x2 = (Time - 14)/4
y = Density

x12 = x1*x2

des = data.frame(y,x1,x2,x12)

#x11 = x1*x1 - 2/3
#x22 = x2*x2 - 2/3
#des = data.frame(y,x1,x2,x12,x11,x22)

fit = lm(y~x1+x2+x12, data = des)
summary(fit)
anova(fit)  # ignore pure error
#

pureErrorAnova(fit)
# Concentration Strength and Time are signifcant. The quadratic and interaction effects
# are not significant. 

# The MSR is MSR = (SSA+SSB)/2 = (192.667 + 22.042)/2 = 107.3545. 
# So, the model F-value is F = MSR/MSE = 107.3545/2.44 = 44
# implies the model is significant. 
p.valueM = pf(44, df1 = 2, df2 = 33, lower.tail = F)
p.valueM
# There is only below 0.01% chance that a "Model F-Value"
# this large could occur due to noice.