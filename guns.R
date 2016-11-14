library(plotly)
library(ggplot2)

c_potential=runif(1)
g_potential=runif(1)
g_init=g_potential
c_init=c_potential

set.seed(123)

itr=500
x=c(runif(1),runif(1),runif(1))
data=as.data.frame(matrix(ncol=2,nrow=itr))
history=as.data.frame(matrix(ncol=2,nrow=itr))
names(history)=c("c_potential","g_potential")
1=1

for(i in 1:itr)
{
  x=c(runif(1),runif(1))
  data[i,]=x
  history[i,]=c(c_potential,g_potential)
  #case 1
  if(data[i,2]<g_potential   && data[i,1]<c_potential)
  {
    g_potential=g_potential+rnorm(1,.005,.001)
    c_potential=c_potential-rnorm(1,.005,.001)
    if(g_potential<.0000000001)
    {
      g_potential=.01
      
      
    }
    
    if(c_potential<.0000000001)
    {
      c_potential=.01
      
      
    }
    
    
    
    if(c_potential>1)
    {
      c_potential=.99
      
    }
    
    if(g_potential>1)
    {
      g_potential=.99
      
    }
    
    
  }
  
  
  
  
  
  #case 2
  
  if(data[i,2]<g_potential   && data[i,1]>c_potential)
  {
    g_potential=g_potential-rnorm(1,.005,.001)
    c_potential=c_potential+rnorm(1,.005,.001)
    if(g_potential<.0000000001)
    {
      g_potential=.01
      
      
    }
    
    if(c_potential<.0000000001)
    {
      c_potential=.01
      
      
    }
    
    
    
    
    
    if(c_potential>1)
    {
      c_potential=.99
      
    }
    
    if(g_potential>1)
    {
      g_potential=.99
      
    }
    
  }
  
  
  
  
  
  #case 3
  if(data[i,2]>g_potential   && data[i,1]<c_potential)
  {
    g_potential=g_potential+rnorm(1,.005,.001)
    c_potential=c_potential+rnorm(1,.005,.001)
    if(g_potential<.0000000001)
    {
      g_potential=.01
      
      
    }
    
    if(c_potential<.0000000001)
    {
      c_potential=.01
      
      
    }
    
    
    
    
    if(c_potential>1)
    {
      c_potential=.99
      
    }
    
    if(g_potential>1)
    {
      g_potential=.99
      
    }
    
  }
  #case 4
  
  if(data[i,2]>g_potential   && data[i,1]>c_potential)
  {
    g_potential=g_potential-rnorm(1,.005,.001)
    c_potential=c_potential+rnorm(1,.005,.001)
    if(g_potential<.0000000001)
    {
      g_potential=.01
      
      
    }
    
    if(c_potential<.0000000001)
    {
      c_potential=.01
      
      
    }
    
    
    
    
    if(c_potential>1)
    {
      c_potential=.99
      
    }
    
    if(g_potential>1)
    {
      g_potential=.99
      
    }
    
  }
  
  
  
  
  
  
}
attach(history)
#c_potential vs itr
plot_ly (x = seq(1,itr,by=1),y=history[,1],type = 'scatter' ,mode = 'lines')
#g_potential vs itr
plot_ly (x = seq(1,itr,by=1),y=history[,2],type = 'scatter' ,mode = 'lines')
g_init
c_init



p <- ggplot(history[250:itr,], aes(c_potential, g_potential))
p + geom_point()+    geom_smooth(se=TRUE) 


history
