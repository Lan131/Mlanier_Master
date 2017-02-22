---
title: "Pay for Performance Densities v2"
author: "Michael Lanier"
date: "February 22, 2017"
output: 
  html_document:
    theme: journal
    toc: true
    toc_float: true
---


## Definitions and terms used
The standardized score is the production score minus the unit average divided by the standard deviation of the group. A score of zero corresponds to the unit average.

The density refers the probability density. This represents the likelihood of finding an individual at a particular score if an individual was randomly selected from the group.



## Individual Plots
```{r setup, echo=F, include=F}
options(warn=-1)
setwd("C:\\Users\\0019091\\Desktop\\Project")
library(ggplot2)
library(plotly)
require(qpcR)

data=read.csv("nurses.csv")

partA_MR=data[1:15,]
partB_MR=data[16:25,]
partA_Appeals=data[26:40,]
partA_mixed=data[41:82,]
partB_mixed=data[83:124,]
All=data[124:length(data),]

```



```{r helper functions, echo=F,include=F }


Score=function(data)
{
  Score=(data[,2]-mean(data[,2]))/var(data[,2])^.5
  return(Score)
  
}


graph=function(scores,data)   
{

Score_=as.data.frame(cbind(Standarized_Score=scores,Density=dnorm(scores)))

base <- ggplot(Score_, aes(Standarized_Score,Density),xlim=c(-2,2))+ geom_point()+geom_smooth()+
labs(title = paste("The Unit Average is",round(mean(data[,2]),2)))
return(base)

}

```

##Part A MR production

```{r Graph1, echo=F,warning = FALSE}

graph(Score(partA_MR),partA_MR)
```

##Part B MR production

```{r Graph2, echo=F}
graph(Score(partB_MR),partB_MR)

```

##All Nurses

```{r Graph3, echo=F}
graph(Score(All),All)
```

##Part A Mixed

```{r Graph4, echo=F}
graph(Score(partA_mixed),partA_mixed)
```



##Part B Mixed

```{r Graph5, echo=F}
graph(Score(partB_mixed),partB_mixed)
```



##Comparison

This shows the various departments distributions in comparison. Values are the percentage of the RE. The way to read this is that the value on the bottom is the corresponding percentile on the y axis. For instance 120 is the 75th percentile for nurses. Which means 75% of nurses had production of 120% the RE or worse. 120% of the RE is approximately the 90th percentile for part A appeals.



```{r Comparison_cdf,echo=F}


df2= qpcR:::cbind.na(A_MR=as.vector(partA_MR[,2]),
                    B_MR=as.vector(partB_MR[,2]),
                    A_APPEALS=as.vector(partA_Appeals[,2]),
                    Nurses=as.vector(All[,2]),
                    A_MIXED=as.vector(partA_mixed[,2]),
                    B_MIXED=as.vector(partB_mixed[,2]))
df2 = stack(as.data.frame(df2))
df2=na.omit(df2)

Avgs= aggregate(df2[,1], list(df2$ind), mean)

q <- ggplot(df2, aes(x = values),facets=ind) +labs(title = "Precentiles")+
  stat_ecdf(geom = "line",aes(group = ind, color = ind),position="identity")+ facet_grid(ind ~ .)+ scale_y_continuous(labels = scales::percent)
ggplotly(q)



```

Here are the unscaled estimates.

```{r}

p <- ggplot(df2, aes(x = values)) + 
  geom_density(aes(fill = ind), alpha = 0.5) + 
  ggtitle("Kernel Density estimates by group")

ggplotly(p)

```
