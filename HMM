#install.packages("HMM")
#install.packages("HMMCont")
library(HMMCont)
library(HMM)
library(ggplot2)

#Calculate mariginal probability of past observation given hidden states A, B and observed states L,R
# Initialise HMM
hmm = initHMM(c("A","B"), c("L","R"), transProbs=matrix(c(.8,.2,.2,.8),2),
              emissionProbs=matrix(c(.6,.4,.4,.6),2))
print(hmm)
# Sequence of observations
observations = c("L","L","R","R")
# Calculate backward probablities
logBackwardProbabilities = backward(hmm,observations)
print(exp(logBackwardProbabilities))


#An HMM can be defined by (A, B, pi), where A is a matrix of state transition probabilities, B is a vector of state emission probabilities and pi (a special member of A) is a vector of initial state distributions. The following steps are taken to estimate these parameters:
#For the A and pi parameters, randomly initialise the HMM (between 0 and 1)
#Initialise the B parameter by uniformly segmenting the training data and estimating the global mean and variance. The B parameter deals with the mean and variances of each state
#Re-estimate and refine the parameters using the Baum-Welch algorithm. This is a variant of the well known Expectation-Maximation (EM) algorithm.



#Baum Welch Algorithm, find long run convergence
# Initial HMM
hmm = initHMM(c("A","B"),c("L","R"),
              transProbs=matrix(c(.2,.1,.8,.9),2),
              emissionProbs=matrix(c(.3,.45,.7,.55),2))
print(hmm)
# Sequence of observation
a = sample(c(rep("L",50),rep("R",40)))
b = sample(c(rep("L",35),rep("R",14)))
observation = c(a,b)
# Baum-Welch
bw = baumWelch(hmm,observation,10)
print(bw$hmm)


# Dishonest casino example
dishonestCasino()


nSim = 2000
States = c("Fair", "Unfair")
Symbols = 1:6
transProbs = matrix(c(0.99, 0.01, 0.02, 0.98), c(length(States),
                                                 length(States)), byrow = TRUE)
emissionProbs = matrix(c(rep(1/6, 6), c(rep(0.1, 5), 0.5)),
                       c(length(States), length(Symbols)), byrow = TRUE)
hmm = initHMM(States, Symbols, transProbs = transProbs, emissionProbs = emissionProbs)
sim = simHMM(hmm, nSim)
vit = viterbi(hmm, sim$observation)
f = forward(hmm, sim$observation)
b = backward(hmm, sim$observation)
i <- f[1, nSim]
j <- f[2, nSim]
probObservations = (i + log(1 + exp(j - i)))
posterior = exp((f + b) - probObservations)
x = list(hmm = hmm, sim = sim, vit = vit, posterior = posterior)
##Plotting simulated throws at top
mn = "Fair and unfair die"
xlb = "Throw nr."
ylb = ""
plot(x$sim$observation, ylim = c(-7.5, 6), pch = 3, main = mn,
     xlab = xlb, ylab = ylb, bty = "n", yaxt = "n")
axis(2, at = 1:6)
#######Simulated, which die was used (truth)####################
text(0, -1.2, adj = 0, cex = 0.8, col = "black", "True: green = fair die")
for (i in 1:nSim) {
  if (x$sim$states[i] == "Fair")
    rect(i, -1, i + 1, 0, col = "green", border = NA)
  else rect(i, -1, i + 1, 0, col = "red", border = NA)
}
########Most probable path (viterbi)#######################
text(0, -3.2, adj = 0, cex = 0.8, col = "black", "Most probable path")
for (i in 1:nSim) {
  if (x$vit[i] == "Fair")
    rect(i, -3, i + 1, -2, col = "green", border = NA)
  else rect(i, -3, i + 1, -2, col = "red", border = NA)
}
##################Differences:
text(0, -5.2, adj = 0, cex = 0.8, col = "black", "Difference")
differing = !(x$sim$states == x$vit)
for (i in 1:nSim) {
  if (differing[i])
    rect(i, -5, i + 1, -4, col = rgb(0.3, 0.3, 0.3),
         border = NA)
  else rect(i, -5, i + 1, -4, col = rgb(0.9, 0.9, 0.9),
            border = NA)
}

#################Posterior-probability:#########################
points(x$posterior[2, ] - 3, type = "l")
###############Difference with classification by posterior-probability:############
text(0, -7.2, adj = 0, cex = 0.8, col = "black", "Difference by posterior-probability")
differing = !(x$sim$states == x$vit)
for (i in 1:nSim) {
  if (posterior[1, i] > 0.5) {
    if (x$sim$states[i] == "Fair")
      rect(i, -7, i + 1, -6, col = rgb(0.9, 0.9, 0.9),
           border = NA)
    else rect(i, -7, i + 1, -6, col = rgb(0.3, 0.3, 0.3),
              border = NA)
  }
  else {
    if (x$sim$states[i] == "Unfair")
      rect(i, -7, i + 1, -6, col = rgb(0.9, 0.9, 0.9),
           border = NA)
    else rect(i, -7, i + 1, -6, col = rgb(0.3, 0.3, 0.3),
              border = NA)
  }
}
 





#Calculate mariginal probability of future observation given hidden states A, B and observed states L,R

# Initialise HMM
hmm = initHMM(c("A","B"), c("L","R"), transProbs=matrix(c(.8,.2,.2,.8),2),
              emissionProbs=matrix(c(.6,.4,.4,.6),2))
print(hmm)
# Sequence of observations
observations = c("L","L","R","R")
# Calculate forward probablities
logForwardProbabilities = forward(hmm,observations)
print(exp(logForwardProbabilities))

#calaculate posterior probability
# Initialise HMM
hmm = initHMM(c("A","B"), c("L","R"), transProbs=matrix(c(.4,.2,.6,.8),2),
              emissionProbs=matrix(c(.9,.4,..1,.6),2))
print(hmm)
# Sequence of observations
observations = c("L","L","R","R","L","L","R")
# Calculate posterior probablities of the states
posterior = posterior(hmm,observations)
print(posterior)


#simulate HMM (ie predict a future sequence)
# Initialise HMM
hmm = initHMM(c("T","F"),c("s","ns"))
simHMM(hmm, 100)
# Simulate from the HMM
j=simHMM(hmm, 100)
j
as.numeric(as.factor(j$observation))



#most likely path
# Initialise HMM
hmm = initHMM(c("A","B"), c("L","R"), transProbs=matrix(c(.6,.4,.4,.6),2),
              emissionProbs=matrix(c(.6,.4,.4,.6),2))
print(hmm)
# Sequence of observations
observations = c("L","L","R","R","R")
# Calculate Viterbi path
viterbi = viterbi(hmm,observations)
print(viterbi)
#vt = viterbiTraining(hmm,observation,5)
#vt$hmm



#viterbi Algorithm, find long run convergence
# Initial HMM
hmm = initHMM(c("A","B"),c("L","R"),
              transProbs=matrix(c(.9,.1,.1,.9),2),
              emissionProbs=matrix(c(.5,.51,.5,.49),2))
print(hmm)
# Sequence of observation
a = sample(c(rep("L",50),rep("R",300)))
b = sample(c(rep("L",300),rep("R",100)))
observation = c(a,b)
# Viterbi-training
vt = viterbiTraining(hmm,observation,10)
print(vt$hmm)

#initialize
hmm=initHMM(c("X","Y"), c("a","b","c"))
hmm

Prices
Returns
#cont HMM
# Step-by-step analysis example.
Returns<-logreturns(Prices) # Getting a stationary process
Returns<-Returns*10 # Scaling the values
hmm<-hmmsetcont(Returns) # Creating a HMM object
print(hmm) # Checking the initial parameters
for(i in 1:6){hmm<-baumwelchcont(hmm)} # Baum-Welch is
# executed 6 times and results are accumulated
print(hmm) # Checking the accumulated parameters
summary(hmm) # Getting more detailed information
hmmcomplete<-viterbicont(hmm) # Viterbi execution
statesDistributionsPlot(hmmcomplete, sc=10) # PDFs of
# the whole data set and two states are plotted
par(mfrow=c(2,1))
plot(hmmcomplete, Prices, ylabel="Price")
plot(hmmcomplete, ylabel="Returns") # the revealed
# Markov chain and the observations are plotted
