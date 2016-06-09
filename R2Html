setwd("path")
library(R2HTML)
library(ggplot2)
history=read.csv(file="history.csv",header=TRUE)
invisible(attach(history))
HTMLStart(outdir="path", file="name",
   extension="html", echo=FALSE,autobrowse=FALSE, HTMLframe=FALSE,CSSFile = "R2HTML.css")
invisible(HTML.title("Appeals History 1/2014-5/2016", HR=1))
invisible(HTML.title("title", HR=2))
ggplot(data = history,main="Appeals", aes(x = Month, y = total, colour = J5)) + geom_point(aes(text = paste("Month:", J5)), size = 1) + stat_smooth(aes(colour = J5, fill = J5,n=80,span = 0.3,level=.90), size = 0.1)
invisible(HTMLplot())
qplot(Month, J5, size=J8,main="J5 Month over Month, sized to J8")
invisible(HTMLplot())
HTML.title("data", HR=3)
history
HTML.title("Summary Statistics", HR=3)
summary(history)[-7,]
HTMLhr()
HTMLStop() 
