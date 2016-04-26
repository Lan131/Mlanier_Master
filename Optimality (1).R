rm(list = ls())
library(rsm)

#### 8.1
## A single rep of a 2^3 design
df.8.1 <- read.table(text="
x1 x2 x3
-1 -1 -1
 1 -1 -1
-1  1 -1
 1  1 -1
-1 -1  1
 1 -1  1
-1  1  1
 1  1  1
", header=TRUE)
str(df.8.1)

N = 8 
p = 3
X = as.matrix(df.8.1)
# moment matrix
M = t(X)%*%X/N
# determinant
det(M)^(1/p)
# trace - average coefficient variance
Mi = solve(M)
sum(diag(Mi))/p


# You can use the package AlgDesign function eval.design() to evaluate the 
# D and A efficiencies of the design. The efficiency depends on the model function
# you specify.


library(AlgDesign)
eval.design(~ x1 + x2 + x3, df.8.1)
# these can be assigned to variables
D.eff.lin <- eval.design(~ x1 + x2 + x3, df.8.1)$determinant
# note that A-efficiency is 1/A given from eval.design()
A.eff.lin <- 1 / eval.design(~ x1 + x2 + x3, df.8.1)$A
c(D.eff.lin, A.eff.lin)


# Now we calculate the same quantities after adding 3 center points.
df.8.1c <- rbind(df.8.1, data.frame(x1 = rep(0,3), x2 = rep(0,3), x3 = rep(0,3)))
df.8.1c

library(AlgDesign)
eval.design(~ x1 + x2 + x3, df.8.1c)
D.eff.lin <-  eval.design(~ x1 + x2 + x3, df.8.1c)$determinant
A.eff.lin <- 1 / eval.design(~ x1 + x2 + x3, df.8.1c)$A
c(D.eff.lin, A.eff.lin)


# Sometimes it is desirable to augment a design in an optimal way. Suppose it is
# expected that a linear model will suffice for the experiment and so the design
# in df.8.2 is run.

#### 8.2
df.8.2 <- read.table(text="
x1 x2
-1 -1
 1 -1
-1  1
 0  0
 0  0
", header=TRUE)
str(df.8.2)

# Later, the experimenters realized that a second-order design would be more
# appropriate. They constructed a sensible list of design points to include 
# (based on a face-centered CCD).

# Then they evaluate the star points at a number of values (0.5, 1.0, 1.5, 2.0),
# and find the D-optimal augmentation at each.

for (i.alpha in c(0.5, 1.0, 1.5, 2.0)) {
  # augment design candidate points
  D.candidate.points <- i.alpha * data.frame(x1 = c( 1, -1,  0,  0)
                                           , x2 = c( 0,  0,  1, -1))

  # combine original points with candidate points
  D.all <- rbind(df.8.2, D.candidate.points)

  # keep the original points and augment the design with 4 points
  # the function optFederov() calculates an exact or approximate algorithmic design
  # the goal of algorithmic design is to maximize the information about the parameters 
  library(AlgDesign)
  D.aug <- optFederov(~ quad(.), D.all, nTrials = dim(df.8.2)[1] + 4, rows = 1:dim(df.8.2)[1]
                      , augment = TRUE, criterion = "D", maxIteration = 1e4, nRepeats = 1e2)
  ## same as:
  #D.aug <- optFederov(~ x1 + x2 + x1:x2 + x1^2 + x2^2
  #                    , D.all, nTrials = dim(df.8.2)[1] + 4, rows = 1:dim(df.8.2)[1]
  #                    , augment = TRUE, criterion = "D", maxIteration = 1e4, nRepeats = 1e2)

  # Added points
  print(D.aug$design[(dim(df.8.2)[1]+1):dim(D.aug$design)[1],])

  #library(AlgDesign)
  # quadratic
  #rm(D.eff.lin, A.eff.lin)
  D.eff.lin <-     eval.design(~ quad(.), D.aug$design)$determinant
  A.eff.lin <- 1 / eval.design(~ quad(.), D.aug$design)$A
  print(c(i.alpha, D.eff.lin, A.eff.lin))
}

# Funding comes through and they don't have to just add the four axial
# points, but can afford to add any 12 points they like to the initial run. 
# They look at a range of combinations of points for x1 and x2 and find the D-optimal
# augmentation.

# augment design candidate points
D.candidate.points <- expand.grid(x1 = seq(-2, 2, by = 0.5)
                                , x2 = seq(-2, 2, by = 0.5))
str(D.candidate.points)
D.candidate.points

# combine original points with candidate points
D.all <- rbind(df.8.2, D.candidate.points)

# keep the original points and augment the design with 4 points
library(AlgDesign)
D.aug <- optFederov(~ quad(.), D.all, nTrials = dim(df.8.2)[1] + 12, rows = 1:dim(df.8.2)[1]
                    , augment = TRUE, criterion = "D", maxIteration = 1e4, nRepeats = 1e2)

# Added points
print(D.aug$design[(dim(df.8.2)[1]+1):dim(D.aug$design)[1],])

library(AlgDesign)
# quadratic
#rm(D.eff.lin, A.eff.lin)
D.eff.lin <-     eval.design(~ quad(.), D.aug$design)$determinant
A.eff.lin <- 1 / eval.design(~ quad(.), D.aug$design)$A
print(c(i.alpha, D.eff.lin, A.eff.lin))

# full design
library(plyr)
D.aug.ordered <- arrange(D.aug$design, x1, x2)
D.aug.ordered


# The AlgDesign package can be used to create computer-generated designs, 
# providing a list of permitted/suggested design points.
# D-optimal 3 x 2 x 2 for the model
#     y = beta0 + beta1*x1 + beta2*x2 + beta3*x3 + beta11*x1^2 + epsilon

#### 8.10
# design candidate values  3 * 2 * 2
D.candidate.points <- expand.grid(x1 = seq(-1, 1, by = 1)
                                , x2 = c(-1, 1)
                                , x3 = c(-1, 1))
D.candidate.points

# choose the 12 points based on D-criterion
library(AlgDesign)
D.gen <- optFederov(~ x1 + x2 + x3 + x1^2, D.candidate.points, nTrials = 12
                    , criterion = "D", evaluateI = TRUE, maxIteration = 1e4, nRepeats = 1e2)
D.gen
A.eff <- 1/D.gen$A # A efficiency is the reciprocal of $A

# easier to read when ordered
library(plyr)
D.gen.ordered <- arrange(D.gen$design, x1, x2, x3)
D.gen.ordered


# D-optimal 5 x 2 x 2 for the model
#     y = beta0 + beta1*x1 + beta2*x2 + beta3*x3 + beta11*x1^2 + epsilon


#### 8.11
# design candidate values  5 * 2 * 2
D.candidate.points <- expand.grid(x1 = seq(-1, 1, by = 0.5)
                                , x2 = c(-1, 1)
                                , x3 = c(-1, 1))
D.candidate.points

# choose the 12 points based on D-criterion
library(AlgDesign)
D.gen <- optFederov(~ x1 + x2 + x3 + x1^2, D.candidate.points, nTrials = 12
                    , criterion = "D", evaluateI = TRUE, maxIteration = 1e4, nRepeats = 1e2)
D.gen
A.eff <- 1/D.gen$A # A efficiency is the reciprocal of $A

# easier to read when ordered
library(plyr)
D.gen.ordered <- arrange(D.gen$design, x1, x2, x3)
D.gen.ordered



#### 8.10
# design candidate values  5 * 2 * 2
D.candidate.points <- expand.grid(x1 = seq(-1, 1, by = 0.5)
                                , x2 = c(-1, 1)
                                , x3 = c(-1, 1))
D.candidate.points

# choose the 12 points based on I-criterion
library(AlgDesign)
D.gen <- optFederov(~ x1 + x2 + x3 + x1^2, D.candidate.points, nTrials = 12
                    , criterion = "I", evaluateI = TRUE, maxIteration = 1e4, nRepeats = 1e2)
D.gen
A.eff <- 1/D.gen$A # A efficiency is the reciprocal of $A

# easier to read when ordered
library(plyr)
D.gen.ordered <- arrange(D.gen$design, x1, x2, x3)
D.gen.ordered



#### 8.10
# design candidate values
D.candidate.points <- expand.grid(x1 = seq(-1, 1, by = 0.5)
                                , x2 = c(-1, 1)
                                , x3 = c(-1, 1))
#D.candidate.points

# choose the 12 points based on A-criterion
library(AlgDesign)
D.gen <- optFederov(~ x1 + x2 + x3 + x1^2, D.candidate.points, nTrials = 12
                    , criterion = "A", evaluateI = TRUE, maxIteration = 1e4, nRepeats = 1e2)
D.gen
A.eff <- 1/D.gen$A # A efficiency is the reciprocal of $A

# easier to read when ordered
library(plyr)
D.gen.ordered <- arrange(D.gen$design, x1, x2, x3)
D.gen.ordered



library(rsm)
par(mfrow = c(2,2))
varfcn(D.gen.ordered, ~ x1 + x2 + x3 + x1^2)
# the contour plots will plot the first two variables in the formula
varfcn(D.gen.ordered, ~ x1 + x2 + x3 + x1^2, contour = TRUE)
varfcn(D.gen.ordered, ~ x2 + x3 + x1 + x1^2, contour = TRUE)
varfcn(D.gen.ordered, ~ x1 + x3 + x2 + x1^2, contour = TRUE)


