data1 <- read.table("http://www.unt.edu/rss/class/Jon/R_SC/Module10/MCMCfactanal_data1.txt",
   header=TRUE, sep=",", na.strings="NA", dec=".", strip.white=TRUE)
summary(data1)
data1


## Traditional factor analysis; here assigned to the object "fa.1".

fa.1 <- factanal(~x1+x2+x3+x4+x5+x6+x7+x8, factors = 2, rotation = "varimax", data = data1)
fa.1

# If desired; display the loadings without suppression (cutoff) and only the first 3 digits below zero.

print(fa.1, digits = 3, cutoff = .000001)


# A little demonstration, v2 is just v1 with noise,
# and same for v4 vs. v3 and v6 vs. v5
# Last four cases are there to add noise
# and introduce a positive manifold (g factor)
v1 <- c(1,1,1,1,1,1,1,1,1,1,3,3,3,3,3,4,5,6)
v2 <- c(1,2,1,1,1,1,2,1,2,1,3,4,3,3,3,4,6,5)
v3 <- c(3,3,3,3,3,1,1,1,1,1,1,1,1,1,1,5,4,6)
v4 <- c(3,3,4,3,3,1,1,2,1,1,1,1,2,1,1,5,6,4)
v5 <- c(1,1,1,1,1,3,3,3,3,3,1,1,1,1,1,6,4,5)
v6 <- c(1,1,1,2,1,3,3,3,4,3,1,1,1,2,1,6,5,4)
m1 <- cbind(v1,v2,v3,v4,v5,v6)
cor(m1)
factanal(m1, factors = 3) # varimax is the default
factanal(m1, factors = 3, rotation = "promax")
# The following shows the g factor as PC1
prcomp(m1) # signs may depend on platform

## formula interface
factanal(~v1+v2+v3+v4+v5+v6, factors = 3,
         scores = "Bartlett")$scores

## a realistic example from Bartholomew (1987, pp. 61-65)
utils::example(ability.cov)











## Bayesian Factor Analysis using Markov Chain Monte Carlo (MCMC) methods. 

# Keep in mind that a Bayesian factor analysis is by its very nature a confirmatory analysis. The 
# Bayesian perspective necessitates the use of a prior and therefore, it can be assumed that the prior 
# is based on an exploratory factor analysis done previously (or the prior is based on previous 
# research involving the establishment or acceptance of the items/scales/measure). 

# Load the MCMCpack library.

library(MCMCpack)


help(MCMCfactanal)

# Run the MCMC factor analysis (assigning it to an object; here "fa.2"). Keep in mind, this can take 
# a few minutes. In the example below, we do not fully specify the model (i.e. constraining which items 
# load on which factors); which will be covered further below.


fa.2 <- MCMCfactanal(~x1+x2+x3+x4+x5+x6+x7+x8, factors = 2, data = data1, burnin = 1000, mcmc = 10000,
                     thin = 10, verbose = 0, seed = NA, lambda.start = NA, psi.start = NA, l0 = 0, L0 = 0, 
                     a0 = 0.001, b0 = 0.001, store.scores = FALSE, std.var = TRUE)
summary(fa.2)
heidel.diag(fa.2)

# Extracting elements of the output. 

### First, the loadings (Lambda). 

loadings <- summary(fa.2)$statistics[1:16]
loadings

# Factor 1 item loadings (items x1, x2, x3, x4).

factor1.item.loadings <- loadings[c(1,3,5,7)]
factor1.item.loadings


# Factor 2 item loadings (items x5, x6, x7, x8).

factor2.item.loadings <- loadings[c(10,12,14,16)]
factor2.item.loadings

# Extract the 95% Credible Interval estimates of each loading.

ci.loadings <- summary(fa.2)$quantiles[1:16,c(1,5)]
ci.loadings

# Factor 1 item loading intervals (items x1, x2, x3, x4).

factor1.ci.loadings <- ci.loadings[c(1,3,5,7),]
factor1.ci.loadings

# Factor 2 item loading intervals (items x5, x6, x7, x8).

factor2.ci.loadings <- ci.loadings[c(10,12,14,16),]
factor2.ci.loadings

### Extract the uniquenesses (Psi). 

uniquenesses <- data.frame(summary(fa.2)$statistics[17:24], names(data1))
names(uniquenesses)[1] <- "uniquenesses"
uniquenesses

# Extract the 95% Credible Interval estimates of each uniqueness.

ci.unique <- summary(fa.2)$quantiles[17:24,c(1,5)]
ci.unique

# Calculate the Communalities for each item.

communalities <- data.frame(1 - uniquenesses[,1], names(data1))
names(communalities)[1] <- "communalities"
communalities


# Here constraining the loadings (Lambda) so that the first four items load exclusively on 
# factor 1 and not on factor 2; as well as ensuring the second four items load on factor 2 
# and not on factor 1; for instance, item "x1" is constrained on factor 2 to have a loading 
# of zero [e.g. x1=c(2,0)]. One could say this is a more 'confirmatory' strategy; which seems 
# appropriate when taking a Bayesian approach (i.e. the specification of a prior, which 
# is necessary; indicates an exploratory factor analysis was done previoiusly or previous
# research has established the structure of the measure). 



fa.3 <- MCMCfactanal(~x1+x2+x3+x4+x5+x6+x7+x8, factors = 2, data = data1, 
                     lambda.constraints=list(x1=list(2,0), x2=c(2,0), x3=list(2,0), x4=c(2,0),
                                             x5=list(1,0), x6=c(1,0), x7=list(1,0), x8=c(1,0)),
                     burnin = 1000, mcmc = 10000, thin = 10, verbose = 0, 
                     seed = NA, lambda.start = NA, psi.start = NA, l0 = 0, L0 = 0, 
                     a0 = 0.001, b0 = 0.001, store.scores = FALSE, std.var = TRUE)
summary(fa.3)


# Below, running the Heidel diagnostic test (from package 'coda') confirms stationarity was achieved. 

heidel.diag(fa.3)

# Also, the densities for the loadings are more normally distributed. 

plot(fa.3)
