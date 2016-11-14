library(plotly)


c_potential=runif(1)
g_potential=runif(1)
g_init=g_potential
c_init=c_potential



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

  





if(data[i,2]<g_potential   && data[i,1]>c_potential)
{
  g_potential=g_potential-rnorm(1,.005,.001)

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
  
  
if(data[i,2]>g_potential   && data[i,1]>c_potential)
{
  g_potential=g_potential-rnorm(1,.005,.001)
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






}
attach(history)
plot_ly (x = seq(1,itr,by=1),y=history[,1],type = 'scatter' ,mode = 'lines')
plot_ly (x = seq(1,itr,by=1),y=history[,2],type = 'scatter' ,mode = 'lines')
g_init
c_init
plot_ly (y=c_potential,x=g_potential)
plot_ly (x=history$c_potential,y=history$g_potential)

 plot(x=seq(1,itr,by=1),y=history[,1]) 
 plot(x=seq(1,itr,by=1),y=history[,2]) 
history
