##############
rm(list=ls())

### Using FrF2 package in R to create fractional designs
library(FrF2)




## Ex. 4.5
planEx4.5 <- FrF2(nruns = 8, nfactors = 7, randomize = FALSE)
design.info(planEx4.5)
y= c(85.5, 75.1, 93.2, 145.4, 83.7, 77.6, 95, 141.8)
planEx4.5 <- add.response(planEx4.5, y)
DanielPlot(lm(y~(.)^2,planEx4.5), alpha=0.2, half=TRUE)


## FOld-Over design
## full foldover for dealiasing all main effects

planEx4.5 <- fold.design(planEx4.5)
design.info(planEx4.5)
yt = c(91.3, 136.7, 82.4, 73.4, 94.1, 143.8, 87.3, 71.9)
y = c(y,yt)
planEx4.5 <- add.response(planEx4.5, y, replace=TRUE)

linmod <- lm(y~(.)^2,planEx4.5)
DanielPlot(linmod, alpha=0.2, half=TRUE)
MEPlot(linmod)
IAPlot(linmod)


## create resolution III design
plan <- FrF2(nruns = 8, nfactors = 5, randomize = FALSE)
y <- c( -3.03,  9.25, -1.23, -1.84, -1.81,  1.19,  8.48,  1.17)
## add the response into the design
plan <- add.response(plan, y)
DanielPlot(lm(y~(.)^2,plan), alpha=0.2, half=TRUE)

## Effects B and D are significant

## alias information
design.info(plan)
## full foldover for dealiasing all main effects
plan <- fold.design(plan)
design.info(plan)



## Plackett-Burman Designs

## 11 factors
plan12pb = pb(12,randomize=FALSE)
design.info(plan12pb)

## fold a Plackett-Burman design with 11 factors
fold.design(plan12pb)



