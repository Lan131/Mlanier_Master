data=ts(c(884740,
971479,
1786302,
1150300,
1107227,
1336403,
940836,
989800,
1344317,
1470808,
1522639,
1339789,
615107,
694785,
2039621,
707131,
869633
),start=c(2014, 2), end=c(2015, 6), frequency=12)

fit=HoltWinters(data ,alpha = NULL, beta = 0, gamma = NULL,
            seasonal = c("additive", "multiplicative")
            )
summary(fit)
plot(fit)
plot(fitted(fit))
lines(fitted(fit)[,1], col = 3)

#(data)

arima(data, order = c(1,0,1))
arima(data, order = c(1,1,1))
arima(data, order = c(3,0,0))
arima(data, order = c(1,1,2))
arima(data, order = c(0,1,1))
#0,1,1 best AIC
fit2=arima(data, order = c(0,1,1))
pred=predict(fit2,6)

pred
predict(fit, n.ahead = 6, prediction.interval = TRUE,
       level = 0.95)
