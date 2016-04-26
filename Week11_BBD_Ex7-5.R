###

rm(list = ls())

library(rsm)

# use bbd() function

des7.5 = bbd(k=3, n0 = 3, randomize = FALSE,
              coding = list (
                x1 ~ (Temp - 175)/25, x2 ~ (Agitation - 7.5)/2.5, x3 ~ (Rate - 20)/5))


# original natural variables
des7.5
# prints the coded values
print(des7.5 , decode = FALSE)

# response values, y = viscosity
y = c(53, 58, 59, 56, 64, 45, 35, 60, 59, 64, 53, 65, 65, 59, 62)


# fit a second-order model
fit_7.5 = rsm(y ~ SO(x1, x2, x3), data = des7.5)
summary(fit_7.5)

# canonical analysis
summary(fit_7.4)$canonical

# Since eigenvalues are mixed signs, 
# the stationary point is a saddle point of 

# this is the stationary point
xs0 = canonical(fit_7.5)$xs
xs0 = round(xs0, digits = 3)
# need to convert to data frame to use predict function - 
# dont forget to transpose xs0
xs0df = data.frame(t(xs0))
# 95% prediction interval for the molecular weight distribution of the resin (viscosity)
predict(fit_7.5, xs0df, interval = "prediction")


## Contour plots



par(mfrow = c(2,2)) # plot of 2x2 panels 
contour(fit_7.5, ~ x1 + x2, image=TRUE, 
        at = data.frame(x1 = 0, x2 = 0, x3 = 1), main = "through (0, 0, x3=1)")
contour(fit_7.5, ~ x1 + x2, image=TRUE, 
        at = data.frame(x1 = 0, x2 = 0, x3 = 0), main = "through (0, 0, x3=0)")
contour(fit_7.5, ~ x1 + x2, image=TRUE, 
        at = data.frame(x1 = 0, x2 = 0, x3 = -1), main = "through (0, 0, x3=-1)")
par(mfrow = c(1,1))

# Agitation was fixed at the low, medium, and high levels. It
# is clear that high-molecular-weight resins are produced
# with low values of agitation, whereas
# low-molecular-weight resins are potentially available when
# one uses high values of agitation. In fact, the extremes of
# low rates, low temperature, and high agitation produces
# low-molecular-weight resins, whereas low agitation, low
# temperature, and high rate results in
# high-molecular-weight resins.
