# Table 13.6
# Agresti, p. 561
 black <- c(119,16,12,7,3,2,0)
 white <- c(1070,60,14,4,0,0,1)
 resp <- c(rep(0:6,times=black), rep(0:6,times=white))
 race <- factor(c(rep("black", sum(black)), rep("white", sum(white))), levels = c("white","black"))
 victim <- data.frame(resp, race)
 table(race)
 with(victim, tapply(resp, race, mean))
 with(victim, tapply(resp, race, var))
 table(resp, race)
 
 
library(MASS)

nbGLM <- glm.nb(resp ~ race, data=victim)
 summary(nbGLM)
 fmeans <- exp(predict(nbGLM, newdata = data.frame(race = c("white","black"))))
 fmeans + fmeans^2 * (1/nbGLM$theta)

 
