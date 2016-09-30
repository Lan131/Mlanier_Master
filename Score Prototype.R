#Ranking plots

library(ggplot2)
library(plotly)
data=read.csv("rank920.csv")
Score=(data[,2]-mean(data[,2]))/var(data[,2])^.5

Score


base <- qplot(Score, geom = "density",xlim=c(-2,2))
base + stat_function(fun = dnorm, colour = "blue")+
  geom_vline(xintercept=Score)+
  geom_text(aes( Score,0,  label = round(Score,1), vjust = -1), size = 3)

