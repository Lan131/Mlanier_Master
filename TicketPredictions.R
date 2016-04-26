rm(list = ls())  # clear list
### Check the working directory
getwd()
library(car)
dat= read.table('Ticketbacklogpred.txt',header=F)
names(dat)= c("Tickets", "Calls","Shrink")
fit = lm(Tickets~Calls+Shrink, data=dat)
summary(fit)
plot(fit)
plot(dat)
crPlots(fit)