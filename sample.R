
data=vector(mode="numeric")
for(i in 1:1000)
{
  
  v=sample(c(3,4,5,6),4,replace=T)
  v[order(-v)][1:3]
  score=sum(v)
  data=c(data,score)
}

mean(data)
hist(data)
quantile(probs=c(.20,.8),data)
