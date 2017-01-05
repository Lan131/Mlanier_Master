library(GA)
library(ggplot2)

#This is given by manager
data=c(61.54,   
       61.06,
       59.89,
       59.86,
       56.54,
       56.04,
       55.07,
       55.06,
       53.89,
       53.71,
       53.65,
       53.53,
       52.40,
       52.18,
       51.88)
budget=600000  

#initialize data
data=sort(data,decreasing=TRUE)
noise=rnorm(length(data),mean=5)
income=budget/length(data)+noise


#Loss Function
evalFunc=function(income)
{

  vec_frame=c(data,income)
  marginal=vector(mode="numeric",length=length(data))

  for(i in 1:length(data)-1)
      {
         marginal[i]=(vec_frame[i+1+length(data)]-vec_frame[i+length(data)])/(vec_frame[i+1]-vec_frame[i])
  
      }

    
  
    current_solution=median(marginal)/mean(marginal)
    if(all.equal(order(data),order(marginal))!=TRUE) #check that data is in same order
        {
            current_solution=.00000001*current_solution
      
          }
     if(sum(income)>budget)   #don't exceed budget
          {
       current_solution=.00001*current_solution
       
     }
    if(current_solution < -100000)
    {
      current_solution=0
      
    }
    if(current_solution > 100000)
    {
      current_solution=0
      
    }
    return(current_solution)
    
}




GAmodel = ga(type="real-valued",popSize=500,maxiter=100, fitness = evalFunc, min = rep(32000,length(data)), max = rep(60000,length(data)), monitor = NULL,keepBest=TRUE)#parallel=TRUE)
summary(GAmodel)
plot(GAmodel)

sol=sort(GAmodel$Solution,decreasing=TRUE)
