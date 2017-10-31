---
title: "Engineering Document"
author: "Michael Lanier"
date: "October 29, 2017"
output: html_document
---



```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```



```{r, echo=F}
#data_master=read.csv(file="Toms_data_consl.csv",header=TRUE)

#tot_reg=max(data_master$Fit_num)
library(plotly)
library(gvlma)
library(MASS)
library(car)
library(ggplot2)
library(corrplot)
diagPlot<-function(model){
    p1<-ggplot(model, aes(.fitted, .resid))+geom_point()
    p1<-p1+stat_smooth(method="loess")+geom_hline(yintercept=0, col="red", linetype="dashed")
    p1<-p1+xlab("Fitted values")+ylab("Residuals")
    p1<-p1+ggtitle("Residual vs Fitted Plot")+theme_bw()
       
    p2<-ggplot(model, aes(qqnorm(.stdresid)[[1]], .stdresid))+geom_point(na.rm = TRUE)+geom_smooth(method = "lm",se = TRUE)
    p2<-p2+geom_abline()+xlab("Theoretical Quantiles")+ylab("Standardized Residuals")
    p2<-p2+ggtitle("Normal Q-Q")+theme_bw()

    
    p3<-ggplot(model, aes(.fitted, sqrt(abs(.stdresid))))+geom_point(na.rm=TRUE)
    p3<-p3+stat_smooth(method="loess", na.rm = TRUE)+xlab("Fitted Value")
    p3<-p3+ylab(expression(sqrt("|Standardized residuals|")))
    p3<-p3+ggtitle("Scale-Location")+theme_bw()
    
    p4<-ggplot(model, aes(seq_along(.cooksd), .cooksd))+geom_bar(stat="identity", position="identity")
    p4<-p4+xlab("Obs. Number")+ylab("Cook's distance")
    p4<-p4+ggtitle("Cook's distance")+theme_bw()
    
    p5<-ggplot(model, aes(.hat, .stdresid))+geom_point(aes(size=.cooksd), na.rm=TRUE)
    p5<-p5+stat_smooth(method="loess", na.rm=TRUE)
    p5<-p5+xlab("Leverage")+ylab("Standardized Residuals")
    p5<-p5+ggtitle("Residual vs Leverage Plot")
    p5<-p5+scale_size_continuous("Cook's Distance", range=c(1,5))
    p5<-p5+theme_bw()+theme(legend.position="bottom")
    
    p6<-ggplot(model, aes(.hat, .cooksd))+geom_point(na.rm=TRUE)+stat_smooth(method="loess", na.rm=TRUE)
    p6<-p6+xlab("Leverage hii")+ylab("Cook's Distance")
    p6<-p6+ggtitle("Cook's dist vs Leverage hii/(1-hii)")
    p6<-p6+geom_abline(slope=seq(0,3,0.5), color="gray", linetype="dashed")
    p6<-p6+theme_bw()
    
    return(list(rvfPlot=p1, qqPlot=p2, sclLocPlot=p3, cdPlot=p4, rvlevPlot=p5, cvlPlot=p6))
    col1 <- colorRampPalette(c("#7F0000","red","#FF7F00","yellow","white", 
                           "cyan", "#007FFF", "blue","#00007F"))
col2 <- colorRampPalette(c("#67001F", "#B2182B", "#D6604D", "#F4A582", "#FDDBC7",
                           "#FFFFFF", "#D1E5F0", "#92C5DE", "#4393C3", "#2166AC", "#053061"))  
col3 <- colorRampPalette(c("red", "white", "blue")) 
col4 <- colorRampPalette(c("#7F0000","red","#FF7F00","yellow","#7FFF7F",  "cyan", "#007FFF", "blue","#00007F"))   

}
 wb <- c("white","black")
```


```{r , echo=FALSE,warning =F,messages=F,errors=F}
##General Notes and Summary

#* Linear regressions are performed.
#* Linked Function failure indicates non linearity. In this case a quadratic regression is fit.
#* Quadratic fits have adjusted X values such that Xadj=X-mean(X). This is to prevent a regression issue around colinear predictors. Equations are given in terms of Xadj because the author is lazy.
#* Regression 23, 38, 46, 64 , 77 are insignificent. Ie There is no evidence for a relationship between X and Y.
#* Regression 37, 69 have a insignifient X but a significent X^2. It is not logically possible for this to occur. Both are included in this case.
#* In the event that the predictor is non significent (asterisks next to predictors indicate significence), no relationship may exist or a simple average is the best predictor.
#* Loess is locally weighted scatter plot smoothing. It is essentially a smoother moving average. It is included to highlight the fit.
#* No regression is done if the response is constant. The equation would just be y=constant. Similarly no constant predictor is included because it's coefficent is 0.
# for( i in 1:tot_reg)
#   
#   
# {
# 
# 
#   sub=subset(data_master,data_master$Fit_num==i)
# 
#   if(var(sub$Y)>0)
#   {
#   fit=lm(Y~X1,data=sub)
#   print(paste("Fit for Regression",i,sep=" "))
#   titl1=paste("Regression Equation: y=",toString(round(fit$coefficients[[2]],digits=3)),"x+",toString(round(fit$coefficients[[1]],digits=3)),sep="")
#     if(gvlma(fit)$GlobalTest$DirectionalStat3[[3]]==1)
#       {
#       #if(min(sub$Y)<0)
#       #{
#       #  offset=1+-1*min(sub$Y)
#       #  sub$Y= sub$Y+offset
#      # }else{offset=0}
#      # df=boxcox(fit, lambda = seq(-2, 2, 1/10),data=sub)
#      # L=df$x[which.max(df$y)]
#       #if(L<0)
#       #{sub=subset(sub,sub$Y!=0)}
#       #depvar.transformed <- yjPower(sub$Y, L)
#       sub$X1=sub$X1-mean(sub$X1)
#       fit=lm(Y~X1+I(X1^2),data=sub) 
#       #titl2= paste("Regression Equation: (y-",toString(offset),")^",round(L,digits=3),"=",toString(round(fit$coefficients[[2]],digits=3)),"x",L,toString(round(fit$coefficients[[1]],digits=3)),sep="")
#       titl2= paste("Regression Equation: y=",toString(round(fit$coefficients[[3]],digits=3)),"xadj^2+",toString(round(fit$coefficients[[2]],digits=3)),"xadj+",toString(round(fit$coefficients[[1]],digits=3)),sep="")
#       
#       summary(gvlma(fit) )
#       g=ggplot(data = sub, aes(x = X1, y = Y)) +
#       stat_smooth(method = 'glm', aes(colour = 'lm'),formula=y ~ poly(x, 2)) +
#       stat_smooth(method = 'loess', aes(colour = 'loess')) +
#       geom_point(size=2, shape=23)+
#       labs(title = titl2 )
#     print(g) 
#         }else{
#   
#     summary(fit)
#       print(summary(fit))
#       g=ggplot(data = sub, aes(x = X1, y = Y)) +
#       stat_smooth(method = 'lm', aes(colour = 'linear'), se = T) +
#       stat_smooth(method = 'loess', aes(colour = 'loess')) +
#       geom_point(size=2, shape=23)+
#       labs(title = titl1 )
#     print(g)}
# 
#   
#   
#   }else{
#     
#     
#     print(paste("Variance in response is zero for fit",i,sep=" "))
#   }
#   
# }

```


```{r , echo=FALSE,warning =F,messages=F,errors=F}


data01=read.csv("01_Stiffness.csv",header=T)
data02=read.csv("02_Onset Yield Moment.csv",header=T)
data03=read.csv("03_Wall Stress UL.csv",header=T)
```

##View the data
```{r , echo=FALSE,warning =F,messages=F,errors=F}

head(data01) #Stiffness.of.Connection
head(data02) #Onset.Yield.Moment
head(data03) #Von.Mises.Stress.Under.Unit.Load
```



##Notes
* Cooks Distance > 1 indicates an influential or outlier. None of these models have this.
* All Models are significent and their factors are significent at at least an alpha=.1 level.
* VIF test for multicolinearity is problematic with VIF values above 10. No factors had this issue.
* Breusch-Pagan Test Non-constant Variance showed no data with non constant variance.
* Durbin Watson Test for autocorrelation showed no autocorrelation amoung data.
* crPlots give partial fits for individual predictors onto response.



```{r , echo=FALSE,warning =F,messages=F,errors=F}
fit=lm(Stiffness.of.Connection~.,data=data01)
```
### Correlation Matrix
```{r , echo=FALSE,warning =F,messages=F,errors=F}
M=cor(data01)
print(M)
```
### Correlation Plot

```{r , echo=FALSE,warning =F,messages=F,errors=F}
corrplot(M, order="hclust", addrect=2, col=wb, bg="gold2")
```
### Diagnostic Plots and Summary

```{r , echo=FALSE,warning =F,messages=F,errors=F}
p4<-ggplot(fit, aes(seq_along(.cooksd), .cooksd))+geom_bar(stat="identity", position="identity")
    p4<-p4+xlab("Obs. Number")+ylab("Cook's distance")
    p4<-p4+ggtitle("Cook's distance")+theme_bw()
    
 p4   
crPlots(fit)
#ceresPlots(fit)
#summary(gvlma(fit) )
#plot(gvlma(fit))
anova(fit)
summary(fit)
durbinWatsonTest(fit) #good
ncvTest(fit) #good
#spreadLevelPlot(fit)
#outlierTest(fit)
car::vif(fit)
influenceIndexPlot(fit)
#avPlots(fit)

```

```{r , echo=FALSE,warning =F,messages=F,errors=F}
fit=lm(Onset.Yield.Moment~.,data=data02)
```
### Correlation Matrix
```{r , echo=FALSE,warning =F,messages=F,errors=F}
M=cor(data01)
print(M)
```
### Correlation Plot

```{r , echo=FALSE,warning =F,messages=F,errors=F}
corrplot(M, order="hclust", addrect=2, col=wb, bg="gold2")
```
### Diagnostic Plots and Summary

```{r , echo=FALSE,warning =F,messages=F,errors=F}
M=cor(data02)
print(M)
corrplot(M, order="hclust", addrect=2, col=wb, bg="gold2")
#diagPlot(fit) #>1 = bad
p4<-ggplot(fit, aes(seq_along(.cooksd), .cooksd))+geom_bar(stat="identity", position="identity")
    p4<-p4+xlab("Obs. Number")+ylab("Cook's distance")
    p4<-p4+ggtitle("Cook's distance")+theme_bw()
    
 p4 
crPlots(fit)
#ceresPlots(fit)
#summary(gvlma(fit) )
#plot(gvlma(fit))
anova(fit)
summary(fit)
durbinWatsonTest(fit) #good
ncvTest(fit) #good
#spreadLevelPlot(fit)
#outlierTest(fit)
car::vif(fit)
influenceIndexPlot(fit)
#avPlots(fit)
```

```{r , echo=FALSE,warning =F,messages=F,errors=F}
fit=lm(Von.Mises.Stress.Under.Unit.Load~.,data=data03)
```
### Correlation Matrix
```{r , echo=FALSE,warning =F,messages=F,errors=F}
M=cor(data03)
print(M)
```
### Correlation Plot

```{r , echo=FALSE,warning =F,messages=F,errors=F}
corrplot(M, order="hclust", addrect=2, col=wb, bg="gold2")
```
### Diagnostic Plots and Summary

```{r , echo=FALSE,warning =F,messages=F,errors=F}

#diagPlot(fit) #>1 = bad
p4<-ggplot(fit, aes(seq_along(.cooksd), .cooksd))+geom_bar(stat="identity", position="identity")
    p4<-p4+xlab("Obs. Number")+ylab("Cook's distance")
    p4<-p4+ggtitle("Cook's distance")+theme_bw()
    
 p4 
crPlots(fit)
#ceresPlots(fit)
#summary(gvlma(fit) )
#plot(gvlma(fit))
anova(fit)
summary(fit)
print("Test for autocorrelation, low p value is good")
durbinWatsonTest(fit) #good
print("Homoscedasticity: Score Test for Non-Constant Error Variance. Low p value is good")
ncvTest(fit) #good
#spreadLevelPlot(fit)
#print("outlier test. Low p value is bad")
#outlierTest(fit)
car::vif(fit)
influenceIndexPlot(fit)
#avPlots(fit)
```
