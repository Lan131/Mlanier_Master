rm(list = ls())
library(graphics)


  curve((1-x)^50,ylab="Likelihood", xlab=expression(theta))


title(main="LR n=50 x=0")


curve(x*(1-x)^52/((1/53)*(1-1/53)^52 ),ylab="Likelihood", xlab=expression(theta))


title(main="LR n=52 x=1")

curve(x^5*(1-x)^547/((5/552)^5*(1-5/552)^547 ),ylab="Likelihood", xlab=expression(theta))


title(main="LR n=552 x=5")



curve