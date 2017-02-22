---
title: "Pay for Performance Densities v2"
author: "Michael Lanier"
date: "February 22, 2017"
output: word_document
---


## Definitions and terms used

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

Score_=as.data.frame(cbind(S=scores,D=dnorm(scores)))

base <- ggplot(Score_, aes(S,D),xlim=c(-2,2))+ geom_point()+geom_smooth()+
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

This shows the various departments distributions in comparison.



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

print(q)


```


