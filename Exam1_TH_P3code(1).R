rm(list = ls())
library(plyr) # load this package to use the mapvalues function

## Be sure that you change the working directory to where to saved your data.
dat = read.csv("exam1P3.csv",header = T)
dat
names(dat)

dat$A = mapvalues(dat$volume, from = c(3,5), to = c(-1,1))
dat$B = mapvalues(dat$batch, from = c(1,2), to = c(-1,1))
dat$C = mapvalues(dat$time, from = c(6,14), to = c(-1,1))
dat$D = mapvalues(dat$speed, from = c(6650,7350), to = c(-1,1))
dat$E = mapvalues(dat$acc, from = c(5,20), to = c(-1,1))
dat$F = mapvalues(dat$cover, from = c('Off','On'), to = c(-1,1))

dat # check
## type code from here

