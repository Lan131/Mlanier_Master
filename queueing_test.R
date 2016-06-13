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
  		c=c-1
  		print(c)
  		print(W)
  
 		 if(W > w)
  		{break}
		
  
	}

}

days_waited=function(l,m,c,w)
{
	k=exp(-c*m*(1-l/(c*m))*w)
	paste("Probability of waiting more than ",w," days is ", k)
}

find_staff(150,13,40)
days_waited(150,13,12,320)
