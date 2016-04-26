getwd()
rm(list = ls()) 

x.norm<-rnorm(n=200,m=10,sd=2)

mydata=x.norm

hist(x.norm,main="Histogram of observed data")
library(MASS)
library(fitdistrplus)
library(gdata)


distributions = c("normal","exponential","binomial""negative binomial","gamma","t","lognormal")
x = x[ x >= 0 ]
for ( dist in distributions ) {
print( paste( "fitting parameters for ", dist ) )
params = fitdistr( x, dist )
print( params )
print( summary( params ) )
print( params$loglik )
y<-params$loglik
}