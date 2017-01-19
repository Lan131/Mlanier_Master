library(GA)
library(plotly)

#First 5 reported, next 5 real

data=c(10,5,1,3,7)

#initialize data
current_solution=0
penalty=0

#Loss Function
evalFunc=function(data)
{
  report=data[1:5]
  real=c(2,3,1,3,7)
  a=runif(1)
  for(k in 1:5)
  {
    
    
    
      if(a<.10 && report[k]-real[k]>0){
        
        report[k]=-100000*report[k]
        
      }
      
    
    
  }
  
  current_solution=sum(report-real)+sum(.10*real)
  
  return(current_solution)
  
}



maxit=100
GAmodel = ga(seed=123,type="real-valued",popSize=500,maxiter=maxit,
             fitness = evalFunc, min = rep(5,length(data)),
             max = rep(100000,length(data)), monitor = NULL,keepBest=TRUE)
               #parallel=TRUE)
summary(GAmodel)
plot(GAmodel)
solution=GAmodel@bestSol[[maxit]]




