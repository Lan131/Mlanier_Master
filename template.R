library(randomForest)
library(corrplot)
library(dplyr)
library(plotly)
library(caret)
library(xgboost)
library(RCurl)
library(darch)
library(e1071)
library(devtools)
#install_github("h2oai/h2o-3/h2o-r/ensemble/h2oEnsemble-package")
library(h2oEnsemble)
library(ggplot2)
library(rpart) # rpart for imputation



if ("package:h2o" %in% search()) { detach("package:h2o", unload=TRUE) }
if ("h2o" %in% rownames(installed.packages())) { remove.packages("h2o") }

# Next, we download packages that H2O depends on.
pkgs <- c("methods","statmod","stats","graphics","RCurl","jsonlite","tools","utils")
for (pkg in pkgs) {
  if (! (pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
}


install.packages("h2o", type="source", repos=(c("http://h2o-release.s3.amazonaws.com/h2o/rel-turing/3/R")))
library(h2o)


set.seed(1234)


#Correlation plot and importances
data=read.csv("C:\\Users\\Lanier\\Desktop\\Tab.csv",header=T)
data=data[,-c(1,2,3)]


data=na.roughfix(data)

col1 <- colorRampPalette(c("#7F0000","red","#FF7F00","yellow","white", 
                           "cyan", "#007FFF", "blue","#00007F"))
col2 <- colorRampPalette(c("#67001F", "#B2182B", "#D6604D", "#F4A582", "#FDDBC7",
                           "#FFFFFF", "#D1E5F0", "#92C5DE", "#4393C3", "#2166AC", "#053061"))  
col3 <- colorRampPalette(c("red", "white", "blue")) 
col4 <- colorRampPalette(c("#7F0000","red","#FF7F00","yellow","#7FFF7F", 
                           "cyan", "#007FFF", "blue","#00007F"))   

M=cor(sapply(data[,1:6],as.numeric))

corrplot.mixed(M, upper="ellipse", lower="number",col=col3(200))
wb <- c("white","black")
corrplot(M, order="hclust", addrect=2, col=wb, bg="gold2")


attach(data)
fit=randomForest(x=sapply(data,as.numeric)[,1:5],y=as.factor(data[,6]),data=data)
info=fit$importance
info=info[order(fit$importance),]
varImpPlot(fit)


p <- plot_ly(data=data,
             x = c("1","2","3","4","5"),
             y = as.vector(info),
             name = "Importance",
             type = "bar"
)%>%
  layout(title = "Factor Importance",
         xaxis = list(title = "Factors"),
         yaxis = list(title = "Importance"))


p

#Pricipal Component analysis

fit2 <- princomp(data, cor=TRUE)
summary(fit2) # print variance accounted for 
loadings(fit2) # pc loadings 
plot(fit,type="lines") # scree plot 
fit2$scores # the principal components
biplot(fit)

#Autoencoder to find outliers

h2o.init(nthreads = -1, max_mem_size="11g")

train=as.h2o(data)

response <- "response"
predictors <- setdiff(names(train), response)

auto = h2o.deeplearning(x = names(train), training_frame = train,
                        autoencoder = TRUE,activation="TanhWithDropout",
                        hidden = c(10,5,10), epochs = 3)

summary(auto)

dat.anon = h2o.anomaly(auto, train, per_feature=FALSE)
head(dat.anon)
err <- as.data.frame(dat.anon)
plot(sort(err$Reconstruction.MSE), main='Reconstruction Error')

train_df_auto <- train_master[err$Reconstruction.MSE < quantile(err$Reconstruction.MSE,.9),]
recon<- train_master[err$Reconstruction.MSE > quantile(err$Reconstruction.MSE,.9),]
write.csv(recon ,"recon.csv")
write.csv(train_df_auto,"denoised.csv")


h2o.shutdown(prompt = TRUE)


#Prototype models with Caret


fitControl <- trainControl(## 5-fold CV
  method = "cv",
  number = 5,
  summaryFunction = twoClassSummary,classProbs = TRUE,summaryFunction = twoClassSummary,
  search = "random"
)



xgbFit <- train(response ~ ., data = data,
                method = "xgbTree"
                ,preProc = c("center", "scale")
                ,na.action=na.omit,metric='ROC',trControl = fitControl
                ,tuneLength = 15)      


deep <- train(response  ~ ., data = data, 
              method = "deepboost", 
              trControl = fitControl,preProc = c("center", "scale"),tuneLength = 15
              ,na.action=na.omit,metric='ROC')             

bayesFit <- train(response ~ ., data = data, 
                  method = "bayesglm", 
                  trControl = fitControl,preProc = c("center", "scale")
                  ,na.action=na.omit,metric='ROC') 


pls <-  train(response  ~ ., data = data,   
              method = "pls", 
              trControl = fitControl,preProc = c("center", "scale")
              ,na.action=na.omit,metric='ROC')                         



nnet <- train(response  ~ ., data = data,   
              method = "avNNet", 
              trControl = fitControl,preProc = c("center", "scale")
              ,na.action=na.omit,metric='ROC')     
