#Ho: u1=u2
#Ha: otherwise


x=c(86,114,88,83,102)
s=13.06902
xmean=mean(x)

#Sapling monthly
t=(xmean-928/12)/(s/(length(x))^.5)

1-.05/2
t.half.alpha = qt(.975, df=4) 
t.half.alpha
t
t>t.half.alpha

1-pt(t,df=4)