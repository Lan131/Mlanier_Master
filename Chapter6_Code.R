rm(list =ls())
studio = read.table('studio.txt')
names(studio)=c('people16','income','sales')
fit = lm(sales~people16+income, data=studio)
coefficients(summary(fit))
resi = fit$resi
anova(fit)
summary(fit)
confint(fit)

newx = data.frame(people16 = 65.4, income = 17.6)
predict.lm(fit, newx, interval="confidence",level=.95)
predict.lm(fit, newx, interval="prediction",level=.95)



panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- abs(cor(x, y))
  txt <- format(c(r, 0.123456789), digits = digits)[1]
  txt <- paste0(prefix, txt)
  if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
  text(0.5, 0.5, txt, cex = cex.cor * r)
}

panel.hist <- function(x, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(usr[1:2], 0, 1.5) )
  h <- hist(x, plot = FALSE)
  breaks <- h$breaks; nB <- length(breaks)
  y <- h$counts; y <- y/max(y)
  rect(breaks[-nB], 0, breaks[-1], y, col="cyan", ...)
}

pairs(studio, diag.panel=panel.hist, upper.panel = panel.cor)


