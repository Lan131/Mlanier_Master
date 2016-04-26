####
rm(list = ls())

library(rsm)

# Find a good central-composite design
ccd.pick(k=3, n0.c=1:6, wbr.s=1)

# use ccd() function
des7.4 = ccd(3, n0=c(0,6), alpha="rotatable", randomize=FALSE,
             coding = list (
               x1 ~ (Temp1 - 255)/30, x2 ~ (Temp2 - 55)/9, x3 ~ (polyethylene - 1.1)/0.6))

# original natural variables
des7.4 
# prints the coded values
print(des7.4 , decode = FALSE)

# response values
y = c(6.6, 6.9, 7.9, 6.1, 9.2, 6.8, 10.4, 7.3, 9.8, 5.0, 6.9, 6.3, 4.0, 8.6, 10.1, 9.9, 12.2, 9.7, 9.7, 9.6)

# fit a second-order model
fit_7.4 = rsm(y ~ SO(x1, x2, x3), data = des7.4)
summary(fit_7.4)

# canonical analysis
summary(fit_7.4)$canonical

# Since eigenvalues are all negative, 
# the stationary point is a point of estimated
# maximum mean strength of the breadwrapper.

# this is the stationary point
xs0 = canonical(fit_7.4)$xs
xs0 = round(xs0, digits = 3)
# need to convert to data frame to use predict function - 
# dont forget to transpose xs0
xs0df = data.frame(t(xs0))
# 95% prediction interval for the maximum  strength 
# of breadwrapper stock in grams per square inc (PSI)
predict(fit_7.4, xs0df, interval = "prediction")

# contour plots
# We create contours of constant strength at
# percentage of polyethylene x3 = 0.6812768 (through stationary point)
par(mfrow = c(1,1))
contour(fit_7.4, ~ x1 + x2, image=TRUE, 
        at = xs0, main = "through stationary point")


# We create contours of constant strength at different levels
# of the percentage of polyethylene x3 values of -0.5, 0, 0.25, and 0.5.
# The purpose is to determine how much strength is lost by moving percent polyethylene x3
# off the optimum value of 0.681 (coded).



par(mfrow = c(2,2)) # plot of 2x2 panels 
contour(fit_7.4, ~ x1 + x2, image=TRUE, 
        at = data.frame(x1 = 0, x2 = 0, x3 = -0.5), main = "through (0, 0, x3=-0.5)")
# for (b) percentage of polyethylene x3 =
contour(fit_7.4, ~ x1 + x2, image=TRUE, 
        at = data.frame(x1 = 0, x2 = 0, x3 = 0), main = "through (0, 0, x3=0)")
# for (c) Equilibrium at 12 hours
contour(fit_7.4, ~ x1 + x2, image=TRUE, 
        at = data.frame(x1 = 0, x2 = 0, x3 = 0.25), main = "through (0, 0, x3=0.25)")
# for (d) Equilibrium at 10 hours
contour(fit_7.4, ~ x1 + x2, image=TRUE, 
        at = data.frame(x1 = 0, x2 = 0, x3 = 0.5  ), main = "through (0, 0, x3=0.5)")
par(mfrow = c(1,1))

# From the contour plots, it becomes apparent that even if the polyethylene
# content is reduced to a value as low as 0.25 (coded), the
# estimated maximum strength is reduced to only slightly
# less than 10.9 psi. A reduction to 0.500 in polyethylene
# will still produce a maximum that exceeds 11.0 psi.



