#install.packages("queueing")
#?queueing
help.search("NewInput")
library("queueing")
#example(queueing)
find_staff=function(l,m)
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
  
 		 if(W > 60)
  		{break}
  
	}

}


find_staff(547,48)


