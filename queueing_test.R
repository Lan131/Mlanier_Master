#install.packages("queueing")
#?queueing
help.search("NewInput")
library("queueing")
#example(queueing)

c=100
W=1/120
repeat
{
  modelMMntest=QueueingModel(NewInput.MMC(lambda=36, mu=6, c=c, n=0, method=0))
  W= modelMMntest$Wqq
  c=c-1
  print(c)
  print(W)
  
  if(W > 1/60)
  {break}
  
}
