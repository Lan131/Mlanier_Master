setwd("C:\\Users\\0019091\\Desktop\\Project")
library(GA)
library(hydroPSO)
#First 5 reported, next 5 real
data=c(10,5,1,3,7)
#initialize data
current_solution=0
#Loss Function
evalFunc=function(data)
{
  report=data[1:5]
  real=c(2,3,1,3,7)
  a=runif(1)
  for(k in 1:5)
  {
    
    
    
      if(a<.05 && report[k]-real[k]>0 && report[k]<5*real[k] ){
        
        report[k]=-1*(report[k])^1.1
        
      }else {
      
    if( report[k]>5*real[k]){
      
      report[k]=-1*(report[k])^1.1
      
    }
      }
    
    
  }
  
  current_solution=sum(report-real)+sum(.03*real)
  
  return(current_solution)
  
}
maxit=500
GAmodel = ga(seed=123,type="real-valued",popSize=600,maxiter=maxit,
             fitness = evalFunc, min = rep(5,length(data)),
             max = rep(1000,length(data)), monitor = NULL,keepBest=TRUE)
               #parallel=TRUE)
summary(GAmodel)
plot(GAmodel)
solution=GAmodel@bestSol[[maxit]]
#Try partical swarm optimization
PSO=hydroPSO( fn= "evalFunc", 
         lower=rep(0,5), upper = rep(1000,5  )) 
setwd("C:\\Users\\0019091\\Desktop\\Project\\PSO.out")
particles <- read_particles()
# reading only the particles in 'Particles.txt' with a goodness-of-fit value
particles <- read_particles(beh.thr=1000, MinMax="min")
