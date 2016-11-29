
library(randomForest)
library(corrplot)
library(dplyr)
data=read.csv('Cleaned_year_end1516.csv')
head(data)

data=na.roughfix(data)

col1 <- colorRampPalette(c("#7F0000","red","#FF7F00","yellow","white", 
                           "cyan", "#007FFF", "blue","#00007F"))
col2 <- colorRampPalette(c("#67001F", "#B2182B", "#D6604D", "#F4A582", "#FDDBC7",
                           "#FFFFFF", "#D1E5F0", "#92C5DE", "#4393C3", "#2166AC", "#053061"))  
col3 <- colorRampPalette(c("red", "white", "blue")) 
col4 <- colorRampPalette(c("#7F0000","red","#FF7F00","yellow","#7FFF7F", 
                           "cyan", "#007FFF", "blue","#00007F"))   

M=cor(data[,c(3,4,6,7,8)])

corrplot.mixed(M, upper="ellipse", lower="number",col=col3(200))
wb <- c("white","black")
corrplot(M, order="hclust", addrect=2, col=wb, bg="gold2")

for(i in 1:34)
{
  if(data[i,6]==1)
  {
    data[i,6]='True'
  }else{
    
    data[i,6]='False'
  }
  
}

for(i in 1:34)
{
  if(data[i,7]==1)
  {
    data[i,7]='True'
  }else{
    
    data[i,7]='False'
  }
  
}


for(i in 1:34)
{
  if(data[i,8]==1)
  {
    data[i,8]='True'
  }else{
    
    data[i,8]='False'
  }
  
}
data=data[,-5]
attach(data)
fit=randomForest(x=sapply(data,as.numeric)[,-c(2,5)],y=as.factor(data[,5]),data=data)
info=fit$importance
info=info[order(fit$importance),]
varImpPlot(fit)

library(plotly)
p <- plot_ly(data=data,
  x = c("SLA Met 2 month prior","SLA Met 1 month prior","Date", "Daily J8 Volume", "Daily J5 Volume"),
  y = as.vector(info),
  name = "Importance",
  type = "bar"
)%>%
  layout(title = "Factor Importance in Meeting Appeals SLA",
         xaxis = list(title = "Factors"),
         yaxis = list(title = "Importance"))


p
