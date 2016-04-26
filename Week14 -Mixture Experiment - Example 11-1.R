rm(list = ls())

#### 11.1a

data.11.1 <- read.table("Example_11-1.txt", header=TRUE)
data.11.1

# fit intercept-only model (all betas equal)
fit.0 <- lm(y ~ 1, data = data.11.1)
fit.0$studres <- rstudent(fit.0)
summary(fit.0)

# fit first-order model
#   the ~ 0 in the formula indicates no intercept will be fit
fit.FO <- lm(y ~ 0 + x1 + x2 + x3, data = data.11.1)
fit.FO$studres <- rstudent(fit.FO)
summary(fit.FO)

# test H_0: \beta_1 = \beta_2 = \beta_3
anova(fit.0, fit.FO)



#### 11.1b

# fit interaction model
fit.FO.int <- lm(y ~ 0 + x1 + x2 + x3 + x1:x2 + x1:x3 + x2:x3, data = data.11.1)
# externally Studentized residuals
fit.FO.int$studres <- rstudent(fit.FO.int)
summary(fit.FO.int)

# test H_0: \beta_{12} = \beta_{13} = \beta_{23} = 0
anova(fit.FO, fit.FO.int)


# test H_0: \beta_{12} = \beta_{13} = \beta_{23} = 0
#           AND
#           \beta_1 = \beta_2 = \beta_3
anova(fit.0, fit.FO.int)



# create a grid over x1 and x2
x <- seq(0, 1, by = 0.01)
x1 <- x; x2 <- x; # for plotting labels

grid.x123 <- expand.grid(x1 = x
                         , x2 = x
                         , x3 = NA)
grid.x123$x3 <- 1 - (grid.x123$x1 + grid.x123$x2)
# set any x3 < 0 to NA
grid.x123[(grid.x123$x3 < 0),] <- NA

# predictions for 3 models
predict.fit.0   <- predict(fit.0   , newdata = grid.x123)
predict.fit.FO  <- predict(fit.FO , newdata = grid.x123)
predict.fit.FO.int <- predict(fit.FO.int, newdata = grid.x123)

# manually set predictions outside simplex to NA for intercept model
predict.fit.FO.int[is.na(grid.x123$x3)] <- NA

# plot contour plots for 3 mixture models
par(mfrow = c(1,3))
image  (x = x1, y = x2, z = matrix(predict.fit.0  , nrow = length(x)), main = "Intercept-only")
contour(x = x1, y = x2, z = matrix(predict.fit.0  , nrow = length(x)), add = TRUE)
image  (x = x1, y = x2, z = matrix(predict.fit.FO , nrow = length(x)), main = "First-order")
contour(x = x1, y = x2, z = matrix(predict.fit.FO , nrow = length(x)), add = TRUE)
image  (x = x1, y = x2, z = matrix(predict.fit.FO.int, nrow = length(x)), main = "Two-way interaction")
contour(x = x1, y = x2, z = matrix(predict.fit.FO.int, nrow = length(x)), add = TRUE)

