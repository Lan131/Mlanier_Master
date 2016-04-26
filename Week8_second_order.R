rm(list = ls())
# package for response surface analysis
library(rsm)


## Read Example 6-2 data

dat6.2 = read.table("Example_6-2.txt",header=T)

# code the variables
des_6.2 = as.coded.data(dat6.2, x1 ~ (SodiumCitrate - 3)/0.7, 
                        x2 ~ (Glycerol - 8)/3, 
                        x3 ~ (EquilibrationTime - 16)/6)

# original variables
str(des_6.2)
des_6.2
# prints the coded values
print(des_6.2, decode = FALSE)


# we fit a second-order model to the data
# Note that we use SO(x1,x2,x3) for x1*x2*x3
fit_6.2 = rsm(y ~ SO(x1, x2, x3), data = des_6.2)
summary(fit_6.2)
# canonical analysis
summary(fit_6.2)$canonical
# stationary point
summary(fit_6.2)$canonical$xs
# eigenvalues
summary(fit_6.2)$canonical$eigen$values

# Note that the eigenvalues are all negative.
# This indicates that the stationary point is a point
# of maximum estimated response - 
# maximum estimated percent survival.


# this is the stationary point
xs0 = canonical(fit_6.2)$xs
xs0 = round(xs0, digits = 3)
# need to convert to data frame to use predict function - 
# dont forget to transpose xs0
xs0df = data.frame(t(xs0))
# 95% prediction interval for the maximum estimated
# percent survival
predict(fit_6.2, xs0df, interval = "prediction")


# contour plots

# We might be satisfied to operate at the conditions 
# of the computed stationary point xs. 
# Because of economic and scientific constraints of the problem, 
# it is often of interest to determine how sensitive the 
# estimated response is to movement away from the stationary point. 
# In this regard, contour plotting can be very useful.

# We create contours of constant percent survival for Example 6.2
par(mfrow = c(2,2)) # plot of 2x2 panels 
# for (a) Equilibrium at 14.96 hours (through stationary point)
contour(fit_6.2, ~ x1 + x2, image=TRUE, 
        at = xs0, main = "through stationary point")
# for (b) Equilibrium at 14 hours
contour(fit_6.2, ~ x1 + x2, image=TRUE, 
        at = data.frame(x1 = 0, x2 = 0, x3 = -1/3), main = "through (0, 0, ET=14)")
# for (c) Equilibrium at 12 hours
contour(fit_6.2, ~ x1 + x2, image=TRUE, 
        at = data.frame(x1 = 0, x2 = 0, x3 = -2/3), main = "through (0, 0, ET=12)")
# for (d) Equilibrium at 10 hours
contour(fit_6.2, ~ x1 + x2, image=TRUE, 
        at = data.frame(x1 = 0, x2 = 0, x3 = -1  ), main = "through (0, 0, ET=10)")
par(mfrow = c(1,1))

# perspective plots
par(mfrow = c(2,2))
persp(fit_6.2, ~ x1 + x2 + x3 , at = xs0)
par(mfrow = c(1,1))

# perspective plots with colours
par(mfrow = c(2,2))
persp(fit_6.2, ~ x1 + x2 + x3 , at = xs0,
      contours = "col", col = rainbow(40), 
      zlab = "% Survival", 
      xlabs = c("% Sodium Citrate", "% Glycerol",
                "Equilibrium Time"))
par(mfrow = c(1,1))


# Save perspective plots in one PDF file (will be three pages long)
pdf(file = "survival-plots.pdf")
persp(fit_6.2, ~ x1 + x2 + x3 , at = xs0,
      contours = "col", col = rainbow(40), 
      zlab = "% Survival", 
      xlabs = c("% Sodium Citrate", "% Glycerol",
                "Equilibrium Time"))
dev.off()


