library(dplyr)
library(ggplot2)
set.seed(0)
n = 1000
x = rnorm(n,0,.9)
y = x + rnorm(n,2)
df=data.frame(cbind(x,y))
str(dat)
plot(x,y)
fit=lm(y~x)
summary(fit)
fit
Avg=c()
a1=0
a2=0
accept=c()
data_accept=data.frame(matrix(ncol=2,nrow=100))
for(i in 1:100)
{
  x_sam=sample_n(df, 10)
  f=lm(y~x,x_sam)
  a1=f$coef[1]+a1
  a2=f$coef[2]+a2
  accept=c(accept,a2/i)
  data_accept[i,]=data.frame(i,a2/i)
  Avg=c(a1/i,a2/i)
  print(Avg)
}

data_accept
p <- ggplot(data_accept, aes(data_accept[,1], data_accept[,2]))
p + geom_point()+geom_hline(yintercept=.985,colour="blue")+geom_hline(yintercept=1)


