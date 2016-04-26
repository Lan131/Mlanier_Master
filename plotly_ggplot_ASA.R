library(ggplot2)
library(plotly)
#library(forecast)
#install.packages("forecast")

#install.packages("devtools")
#install.packages("curl")
#library(devtools)
#install_github('sinhrks/ggfortify')
dat=read.csv("workersASA.csv", header=TRUE)
Time=dat[,1]
Calls=dat[,3]
Dow=dat[,4]




qplot(Time,asa,data=dat,colour=Dow)
ggplotly()



 p=ggplot(data = dat, aes(x = Time, y = Calls, colour=Dow)) +
  geom_point(aes(text = paste("Day of week:", Dow)), size = 1) +
   stat_smooth(aes(colour = Dow,fill= Dow),size=.1)+
   scale_color_discrete()

(gg <- ggplotly(p))
