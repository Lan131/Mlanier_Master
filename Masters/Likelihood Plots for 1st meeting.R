rm(list = ls())

library(ggplot2)
#install.packages('ggfortify')
library(ggfortify)
   

theta<- seq(.01,.3,by=.001)




# Plot 1  x=5

like<- dbinom(5,100,theta)
like2<- like/max(like)


text(.055,.4,'x=5',cex=.8)


plot(c(0,.3),range(c(like2)),type='n',xlab=expression(theta),ylab='Likelihood')
lines(theta,like2)
text(.055,.4,'x=5',cex=.8)
lines(theta,like2,lty='dotted',lwd=1.5)


##Loop to find argmax
Mxinit=dbinom(5,100,theta[1])
Mx=0
argmx=0
for(i in 1:length(theta))
{
  Mx=dbinom(5,100,theta[i]) 
  if (Mx > Mxinit)
  {
    Mxinit=Mx
    argmx=theta[i]
    
  }
  
}
#END ARGMX loop
J=paste("The likelihood ratio is ",round(Mxinit/max(like),2)," at ",round(argmx,2), sep="")
title(J)





# Plot 2 Biomial x<11



like <- pbinom(10,100,theta)
  like1<- like/max(like)
  
  
  plot(c(0,.3),range(c(like1)),type='n',
                     xlab=expression(theta),
                     ylab='Likelihood')
       
       
       lines(theta,like1)
       
       text(.15,.4,'x<11',cex=.8)
       
  
  
  ##Loop to find argmax
  Mxinit=pbinom(10,100,theta[1])
  Mx=0
  argmx=0
  for(i in 1:length(theta))
  {
    Mx=pbinom(10,100,theta[i]) 
    if (Mx > Mxinit)
    {
      Mxinit=Mx
      argmx=theta[i]
      
    }
    
  }
  #END ARGMX loop
  J=paste("The likelihood ratio is ",round(Mxinit/max(like),2)," at ",argmx, sep="")
 title(J)
          
#Plot 3 Normal x bar= 2.5

 theta <- seq(-1,6,by=.01)
 n<- 5
 xbar<- 2.5

# sums=c()
#for(i in length(theta))
#    {  
#   sum=0
#        for(j in 1:n)
#         {
#            sum= sum+(xbar-theta)^2 
              
#        }
   
#    sums=rbind(sums,sum)
    
# }
 
 
 
 


 #llike <- log(n) + log (1/sqrt(2*pi))+-.5*sums
 like <- dnorm(xbar,mean=theta,sd=sqrt(1/n))

 
 
 
 plot(theta,like,type='n',
      xlab=expression(theta),
      ylab='Likelihood')
 
 lines(theta,like,lty='dotted',lwd=1.5)




##Loop to find argmax
Mxinit= dnorm(xbar,mean=theta[1],sd=sqrt(1/n))
Mx=0
argmx=-50
for(i in 1:length(theta))
{
  Mx=dnorm(xbar,mean=theta[i],sd=sqrt(1/n))
  if (Mx > Mxinit)
  {
    Mxinit=Mx
    argmx=theta[i]
    
  }
  
}
#END ARGMX loop
max(like)
J=paste("The likelihood ratio is ",1," at ",round(argmx,2), sep="")
title(J)






#Plot 4 Normal x max=3.5


theta <- seq(-1,6,by=.01)
theta
n<- 5
xn<- 3.5
llike <- log(dnorm(xn,mean=theta,sd=1)) + (n-1)*log(pnorm(xn,mean=theta,sd=1))+log(n)
like <- exp(llike-max(llike))

plot(theta,like,type='n',
     xlab=expression(theta),
     ylab='Likelihood')


lines(theta,like,lty='dotted',lwd=1.5)

##Loop to find argmax
Mxinit=exp(log(dnorm(xn,mean=theta,sd=1)) + (n-1)*log(pnorm(xn,mean=theta,sd=1))+log(n))
Mxinit
Mx=0
argmx=-50

for(i in 1:length(theta))
{
  Mx=exp(log(dnorm(xn,mean=theta[i],sd=1)) + (n-1)*log(pnorm(xn,mean=theta[i],sd=1))+log(n))

  if (Mx > Mxinit)
  {
    Mxinit=Mx
    argmx=theta[i]
    
  }
  
}

#END ARGMX loop
J=paste("The likelihood ratio is 1 at ",round(argmx,2), sep="")
title(J)


#Plot in one plot
n=5
theta <- seq(-1,6,by=.01)
like1 <- dnorm(2.5,mean=theta,sd=sqrt(1/n))
like1 <- dnorm(2.5,mean=theta,sd=sqrt(1/n))/max(like1)
llike <- log(dnorm(3.5,mean=theta,sd=1)) + (n-1)*log(pnorm(xn,mean=theta,sd=1))+log(n)
like2 <- exp(llike-max(llike))
df <- data.frame(theta,like1,like2)



ggplot(df, aes(theta)) +                    # basic graphical object
  geom_line(aes(y=like1 ,  colour="Sample Mean")) +  # first layer
  geom_line(aes(y=like2,  colour="Sample Max")) + # second layer
 labs(title= "Comparison of Highest Order Statistic and Sample Mean")+
  scale_colour_manual("", 
                      breaks = c("Sample Mean", "Sample Max"),
                      values = c("blue","red")) +
 ylab("Likelihood")

#profile likelihood vs plug in likelihood
theta <- seq(-1,8,by=.01)
theta
n= 5
sigma_=1
x_=4
Lpr=(1+((x_-theta)/sigma_)^2)^(-.5*n)
Lpi=exp((-n*(x_-theta)^2/(2*sigma_^2)))

df=data.frame(theta,Lpr,Lpi)




ggplot(df, aes(theta)) +                    # basic graphical object
  geom_line(aes(y=Lpr ,  colour="Profile Likelihood")) +  # first layer
  geom_line(aes(y=Lpi,  colour="Plug-in Likelihood")) + # second layer
  labs(title= "Comparison of Plug-in and Profile Likelihood")+
  scale_colour_manual("", 
                      breaks = c("Profile Likelihood", "Plug-in Likelihood"),
                      values = c("blue","red")) +
  ylab("Likelihood Ratio")

n=5
theta <- seq(-1,6,by=.01)
like1 <- dnorm(2.5,mean=theta,sd=sqrt(1/n))
LR <- dnorm(2.5,mean=theta,sd=sqrt(1/n))/max(like1)
LR
J=italic('c')
df=cbind(theta,LR)
mid=mean(LR)
ggplot(as.data.frame(df),aes(theta,LR,color=LR))+geom_point()+
scale_color_gradient2(midpoint=mid,low="yellow", mid="blue", high="red")+
geom_line()+
  geom_hline(yintercept = .15,  
             color = "black")+
  labs(title= "What should be the value of c?")  

X=c(1,2,-1,-2,0)
#example xbar=1
delta<- seq(0,4,by=.01)
#delta
n= 1
x_=1
for(x_ in X)
{
  if(x_>0)
    {
      LR=exp(-n/2*(x_-delta)^2)
      u=x_+1.96
      l=x_-1.96
        if(l<0)
        {
          l=0
        }
  }
  
  if(x_<0 || x_==0)
  {
    LR=exp(-n/2*(delta-x_)^2)/exp(-n/2*(x_)^2)
    l=0
    u=x_+1.96
  }

df=data.frame(delta,LR)
if(u>0)
{
    print(ggplot(as.data.frame(df),aes(delta,LR,color=LR))+geom_point()+labs(title=paste("Likelihood Ratio with sample difference ",x_,sep=""))+
        geom_hline(aes(yintercept=.15)) +
        geom_text(aes(0,.15,label = "  c=.15", vjust = -1))+
        geom_vline(xintercept = l, colour="red", linetype = "longdash")+
        geom_text(aes(l,0,label = "  L", vjust = -1))+
        geom_vline(xintercept = u, colour="red", linetype = "longdash")+
        geom_text(aes(u,0,label = "  U", vjust = -1))
        )
}
if(u<0)
{
  print(ggplot(as.data.frame(df),aes(delta,LR,color=LR))+geom_point()+labs(title=paste("Likelihood Ratio with sample difference ",x_,sep=""))+
          geom_hline(aes(yintercept=.15)) +
          geom_text(aes(0,.15,label = "  c=.15", vjust = -1))+
          geom_text(aes(0,.15,label = "  c=.15", vjust = -1))

             )
}

}

#Last plot

ggdistribution(dunif, seq(0, 1, 0.01), min = 0, max = 1)
ggdistribution(dlogis,seq(0, 1, 0.01), location = 0, scale = 1)

