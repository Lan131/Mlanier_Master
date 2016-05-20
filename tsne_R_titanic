library("Rtsne")
library(ggplot2)
library(plotly)

train=read.csv(file="train.csv",header=TRUE)
test=read.csv(file="test.csv",header=TRUE)
train[,1]=as.numeric(train[,1])
train[,1]
train<-na.omit(train)
train$Survived=as.numeric(train$Survived)
train$Pclass=as.numeric(train$Pclass)
train$Parch=as.numeric(train$Parch)
train$SibSp=as.numeric(train$SibSp)
train$Ticket=as.numeric(train$Ticket)
train$Embarked=as.numeric(train$Embarked)
train$Sex=as.numeric(train$Sex)


set.seed(47) # Sets seed for reproducibility

#Create tsne object
tsne_out <- Rtsne(as.matrix(unique(train)),perplexity = 100, Verbose=TRUE,max_iter = 100) # Run TSNE

#plot x,y pairs

tsne_plot=plot(tsne_out$Y,col=c("blue","yellow"), main="tsne for Titanic data",
     xlab="p",
     ylab="q") # Plot the result

#try with different complexity in 3 dimensions
#tsne_out3
tsne_out3 <- Rtsne(as.matrix(unique(train)),perplexity = 50, dims=3,Verbose=TRUE) # Run TSNE
plot(tsne_out3$Y,col=rainbow(length(unique(train$Survived)))) # Plot the result
tsne_out


plot_ly(tsne_out$Y, x = tsne_out$Y[,1], y =tsne_out$Y[,2], text = paste("p: ", tsne_out$Y[,1]),
        mode = "markers", color = rainbow(length(unique(train$Survived))) )
