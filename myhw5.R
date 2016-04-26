rm(list = ls())
library(DoE.base)
library(FrF2)
library(rsm)

#dat
##41.852 38.75 69.69 170.83 45 219.74
#115.329 51.87 113.46 230.06 25 181.22
#99.628 53.79 113.54 228.19 65 179.06
#49.409 53.84 118.75 117.73 65 281.30
#72.958 49.17 119.72 117.69 25 282.2
#107.702 47.61 168.38 173.46 45 216.14
#97.239 64.19 169.85 169.85 45 223.88
#105.856 52.73 169.85 170.86 45 222.8
#99.438 51 170.89 173.34 25 218.12
#100.008 43.18 171.43 171.43 45 219.2
#175.38 71.23 171.59 263.49 45 168.62
#117.8 49.3 171.63 171.63 45 217.58
#217.409 50.87 171.93 170.91 10 219.92
#41.725 54.44 173.92 71.73 45 296.6
#151.139 47.93 221.44 217.39 65 189.14
#220.63 42.91 222.74 221.73 25 285.8
#80.537 64.94 231.19 113.52 65 286.34
#152.966 43.18 236.84 167.77 45 221.72

dat
dat= read.table("62 data.txt")
colnames(dat)=c("y1","y2","x1","x2","x3","x4")
(max(dat[,3])+min(dat[,3]))/2
(max(dat[,3])-min(dat[,3]))/2

(max(dat[,4])+min(dat[,4]))/2
(max(dat[,4])-min(dat[,4]))/2

(max(dat[,5])+min(dat[,5]))/2
(max(dat[,5])-min(dat[,5]))/2

(max(dat[,6])+min(dat[,6]))/2
(max(dat[,6])-min(dat[,6]))/2


des_6.2 = as.coded.data(dat, x1 ~ (Var1 - 153.265)/83.575, 
                        x2 ~ (Var2 - 167.61)/95.88, 
                        x3 ~ (Var3 - 37.5)/27.5,
				 x4 ~ (Var4 -323.61)/63.99   )




#6.2a
des_6.2

fit_6.2_y1 = rsm(y1 ~ SO(x1, x2, x3, x4), data =des_6.2)
fit_6.2_y2 = rsm(y2 ~ SO(x1, x2, x3, x4), data = des_6.2)
fit_6.2_y1
fit_6.2_y2

# the stationary point:
canonical (fit_6.2_y1, threshold = 1e-20)

canonical (fit_6.2_y2, threshold = 1e-20)

#6.2b
decode.data(fit_6.2_y1)
decode.data(fit_6.2_y2)


#6.2c
# the stationary point:
canonical (fit_6.2_y1, threshold = 1e-20)
decode.data(canonical (fit_6.2_y1, threshold = 1e-20))
canonical (fit_6.2_y2, threshold = 1e-20)
decode.data(canonical (fit_6.2_y2, threshold = 1e-20))
#The eigenvalues are mixed this is a ridge since some of these eigenvalues are close to zero.
#Use steepest ascent


canonical.path(fit_6.2_y1)
canonical.path(fit_6.2_y2)
 predict(fit_6.2_y1, se.fit = TRUE)
dat[13,]



#6.2d,e
#Operate at the following with variables in order 
canonical(decode.data(fit_6.2_y1))$xs
canonical(decode.data(fit_6.2_y2))$xs
Operate at ...


#6.4

data=read.table("mydata1.txt")
data
colnames(data)=c("x1","x2","x3","x4","x5","y")

fit2 = rsm(y ~ SO(x1, x2, x3,x4,x5), data =data)
fit2
canonical (fit2, threshold = 1e-20)
#Saddle point. 

canonical.path(fit2)
steepest(fit2, dist = seq(0, 3, by = .001))

#1.000 -0.672 0.650 1.011 0.667 |  916.861

1*10+45 #is x1
-.6672*.2+.5  #is x2
.65*3+85 #is x3
.05*1.011+.25 #is x4
.1*.667+.4 #is x5

varfcn(data,~SO(x1, x2, x3,x4,x5),contour =TRUE,plot = TRUE)
#Prediction error at center is 0.
#Prediction error at factorial points is root 2.
#Prediction error at axial points is 2

predict(fit2, se.fit = TRUE)

dat69= read.table("mydata2.txt")
colnames(dat69)=c("x1","x2","x3","y")
dat69
d1=dat69[,1]
d2=dat69[,2]
d3=dat69[,3]

#6.9a
des_6.9 = as.coded.data(dat69, x1 ~ (Time - (max(d1)+min(d1))/2)/((max(d1)-min(d1))/2), 
                        x2 ~ (Temp - (max(d2)+min(d2))/2)/((max(d2)-min(d2))/2), 
                        x3 ~ (Nickle - (max(d3)+min(d3))/2)/((max(d3)-min(d3))/2))

des_6.9

fit_6.9 = rsm(y ~ SO(x1, x2, x3), data =des_6.9)
#6.9b
fit_6.9

summary(fit_6.9)
fit_6.9b = rsm(y ~ FO(x1, x2, x3)+PQ(x1,x2,x3), data =des_6.9)
#6.9b
fit_6.9b
summary(fit_6.9b)
#6.9c
plot(fit_6.9b)
plot(des_6.9$x1,resid(fit_6.9b))
plot(des_6.9$x2,resid(fit_6.9b))
plot(des_6.9$x3,resid(fit_6.9b))
#6.9d
par(mfrow = c(2,2)) # plot of 2x2 panels 
contour(fit_6.9b, ~ x1 + x2, image=TRUE, at =  data.frame(x1 = 0, x2 = 0, x3 = (10- (max(d3)+min(d3))/2)/((max(d3)-min(d3))/2)), main = "Nickle at 10")
contour(fit_6.9b, ~ x1 + x2, image=TRUE, at =  data.frame(x1 = 0, x2 = 0, x3 = (14- (max(d3)+min(d3))/2)/((max(d3)-min(d3))/2)), main = "Nickle at 14")
contour(fit_6.9b, ~ x1 + x2, image=TRUE, at =  data.frame(x1 = 0, x2 = 0, x3 = (18- (max(d3)+min(d3))/2)/((max(d3)-min(d3))/2)), main = "Nickle at 18")


contour(fit_6.9b, ~ x3 + x1, image=TRUE, at =  data.frame(x1 = 0, x3 = 0, x2 = (10- (max(d3)+min(d3))/2)/((max(d3)-min(d3))/2)), main = " at 10")
contour(fit_6.9b, ~ x3 + x1, image=TRUE, at =  data.frame(x1 = 0, x3 = 0, x2 = (14- (max(d3)+min(d3))/2)/((max(d3)-min(d3))/2)), main = " at 14")
contour(fit_6.9b, ~ x3 + x1, image=TRUE, at =  data.frame(x1 = 0, x3 = 0, x2 = (18- (max(d3)+min(d3))/2)/((max(d3)-min(d3))/2)), main = " at 18")

contour(fit_6.9b, ~ x3 + x2, image=TRUE, at =  data.frame(x1 = 0, x3 = 0, x1 = (10- (max(d3)+min(d3))/2)/((max(d3)-min(d3))/2)), main = " at 10")
contour(fit_6.9b, ~ x3 + x2, image=TRUE, at =  data.frame(x1 = 0, x3 = 0, x1 = (14- (max(d3)+min(d3))/2)/((max(d3)-min(d3))/2)), main = " at 14")
contour(fit_6.9b, ~ x3 + x2, image=TRUE, at =  data.frame(x1 = 0, x3 = 0, x1 = (18- (max(d3)+min(d3))/2)/((max(d3)-min(d3))/2)), main = " at 18")

#6.9d
S=steepest(decode.data(fit_6.9b), dist = seq(-100, 100, by = 1))
#operate on lower temp, high temparture, and low or high nickle.

#6.9e

predict.6.9 = predict(fit_6.9b,fit_6.9b$canonical$xs, se.fit = TRUE)
predict.6.9
S$StdError = predict.6.9$se.fit
S$StdError

#6.10a
dat610= read.table("mydata3.txt")
colnames(dat610)=c("x1","x2","x3","y")
dat610
d1=dat610[,1]
d2=dat610[,2]
d3=dat610[,3]


des_6.10 = as.coded.data(dat610, x1 ~ (Time - (max(d1)+min(d1))/2)/((max(d1)-min(d1))/2), 
                        x2 ~ (Temp - (max(d2)+min(d2))/2)/((max(d2)-min(d2))/2), 
                        x3 ~ (Nickle - (max(d3)+min(d3))/2)/((max(d3)-min(d3))/2))

des_6.10 
print(des_6.10, decode = FALSE)
#6.10b
#This is a central composite design, it is a facotrial design with center points and axial points.
fit_6.10 = rsm(y ~ SO(x1, x2, x3), data =des_6.10)

fit_6.10

summary(fit_6.10)
fit_6.10b = rsm(y ~ FO(x1, x2, x3)+PQ(x1,x2,x3), data =des_6.10)
fit_6.10b

contour(fit_6.10b, ~ x3 + x2, image=TRUE, at =  data.frame(x1 = 0, x3 = 0, x1 = (10- (max(d3)+min(d3))/2)/((max(d3)-min(d3))/2)), main = " at 10")
contour(fit_6.10b, ~ x3 + x2, image=TRUE, at =  data.frame(x1 = 0, x3 = 0, x1 = (14- (max(d3)+min(d3))/2)/((max(d3)-min(d3))/2)), main = " at 14")
contour(fit_6.10b, ~ x3 + x2, image=TRUE, at =  data.frame(x1 = 0, x3 = 0, x1 = (18- (max(d3)+min(d3))/2)/((max(d3)-min(d3))/2)), main = " at 18")
contour(fit_6.10b, ~ x1 + x2, image=TRUE, at =  data.frame(x1 = 0, x2 = 0, x3 = (10- (max(d3)+min(d3))/2)/((max(d3)-min(d3))/2)), main = "Nickle at 10")
contour(fit_6.10b, ~ x1 + x2, image=TRUE, at =  data.frame(x1 = 0, x2 = 0, x3 = (14- (max(d3)+min(d3))/2)/((max(d3)-min(d3))/2)), main = "Nickle at 14")
contour(fit_6.10b, ~ x1 + x2, image=TRUE, at =  data.frame(x1 = 0, x2 = 0, x3 = (18- (max(d3)+min(d3))/2)/((max(d3)-min(d3))/2)), main = "Nickle at 18")
contour(fit_6.10b, ~ x3 + x1, image=TRUE, at =  data.frame(x1 = 0, x3 = 0, x2 = (10- (max(d3)+min(d3))/2)/((max(d3)-min(d3))/2)), main = " at 10")
contour(fit_6.10b, ~ x3 + x1, image=TRUE, at =  data.frame(x1 = 0, x3 = 0, x2 = (14- (max(d3)+min(d3))/2)/((max(d3)-min(d3))/2)), main = " at 14")
contour(fit_6.10b, ~ x3 + x1, image=TRUE, at =  data.frame(x1 = 0, x3 = 0, x2 = (18- (max(d3)+min(d3))/2)/((max(d3)-min(d3))/2)), main = " at 18")

summary(fit_6.10b)
dat610[8,]

predict.6.10 = predict(fit_6.10b,fit_6.10b$canonical$xs, se.fit = TRUE)
predict.6.10



#The conditions for the maximum response in the design space are with time 12, temp 24, and Nickle content 18. The standard error in prediction here is 26.82 units.
 

