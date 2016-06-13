#install.packages("queueing")
#?queueing
help.search("NewInput")
library("queueing")
#example(queueing)
find_staff=function(l,m,w)
{
	c=100 #initalize servers to large number
	W=1/120 #intialize wait time to small number
	repeat
	{
  		modelMMntest=QueueingModel(NewInput.MMC(lambda=l, mu=m, c=c, n=0, method=0))
  		W= modelMMntest$Wqq
		util=modelMMntest$RO
  		print(c)
  		print(W)
  		print(util)
		c=c-1
 		 if(W > w)
  		{break}
		
  
	}

}

days_waited=function(l,m,c,w)
{
	k=exp(-c*m*(1-l/(c*m))*w)
	paste("Probability of waiting more than ",w," periods is approx ", k)
}

find_staff(23922,1690,2)
days_waited(23922,1690,15,.0001)


