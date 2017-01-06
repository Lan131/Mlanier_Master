library(GA)
library(plotly)

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

    
  
    current_solution=median(marginal)/mean(marginal)*var(marginal)^.5
    
     if(sum(income)>budget)   #don't exceed budget
          {
       current_solution=.00001*current_solution
       
     }
   
    return(current_solution)
    
}



maxit=500
GAmodel = ga(seed=123,type="real-valued",popSize=1500,maxiter=maxit, fitness = evalFunc, min = rep(32000,length(data)), max = rep(60000,length(data)), monitor = NULL,keepBest=TRUE)#parallel=TRUE)
summary(GAmodel)
plot(GAmodel)
solution=GAmodel@bestSol[[maxit]]






sol=sort(GAmodel@bestSol[[maxit]],decreasing=TRUE)

if(sum(sol)>budget)
{
  
  sol=sol-(sum(sol)-budget)/length(sol)
  
}else{
  
  sol=sol+(budget-sum(sol))/length(sol)
  
  
  
}

scaled_sol=sort(sol)/max(solution)


base <- qplot(scaled_sol, geom = "density",xlim=c(.7,1))
base +
  geom_point(aes( scaled_sol,0,  label = round(scaled_sol,1), vjust = -1), size = 3)

write(sol,"solution.txt")

