

# Function to estimate maximum from sample "samp"
gTank &lt;- function(samp) {
	 max(samp) + max(samp)/length(samp) - 1
}
 
# A blank log-log plot to get us started
plot(100,100, xlim=c(100,10^7), ylim=c(100,10^7), log="xy",pch=".",col="white",frame.plot=F,xlab="True value",ylab="Predicted")
 
# Let's track residuals
trueTops = c()
resids = c()
sampleTops = c()
 
x = runif(100,2,6)
for(i in x) {
	trueTop = 10^i
	for(j in 1:50) {
		observeds = sample(1:trueTop, 20) # No replacement here
		guess = gTank(observeds)
 
		# Plot the true value vs the predicted one
		points(trueTop,guess,pch=".",col="blue",cex=2) 
 
		trueTops = c(trueTops, trueTop)
		resids = c(resids, trueTop - guess)
		sampleTops = c(sampleTops, max(observeds))
	}
}
 
# Platonic line of perfectly placed predictions
lines(c(100,10^6),c(100,10^6),lty = "dashed",col="gray",lwd=1)
 
# Plot residuals too
windows()
plot(trueTops,log="x",resids,pch=20,col="blue",xlab="True value",ylab="Residual",main="Residuals plot")
abline(h=0)
 
mean(abs(resids))
mean(trueTops-sampleTops)