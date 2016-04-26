
getwd()


setwd("C:/Users/Michael/Desktop/cardif")
library(h2o)
library(devtools)
#install_github("h2oai/h2o-3/h2o-r/ensemble/h2oEnsemble-package")
h2o.shutdown(prompt=FALSE)
h2o.removeAll() ## clean slate - just in case the cluster was already running
h2o.init(nthreads = -1)


dat=read.csv("train.csv",header=TRUE,quote="") #Load data
dat=dat[, -1]  # remove the ID column
dat_h2o = as.h2o(dat) #Convert to h2o dataframe
splits = h2o.splitFrame(dat_h2o, c(0.6,0.2), seed=1234) #split into train and test
train  = h2o.assign(splits[[1]], "train.hex") # 60%
valid  = h2o.assign(splits[[2]], "valid.hex") # 20%
test   = h2o.assign(splits[[3]], "test.hex")  # 20%
response <- "target"
predictors <- setdiff(names(dat_h2o), response)
predictors
train$target <- as.factor(train$target) ##make categorical
m1 <- h2o.deeplearning(
  model_id="dl_model_first", 
  training_frame=train, 
  validation_frame=valid,   ## validation dataset: used for scoring and early stopping
  x=predictors,
  y=response,
  #activation="Rectifier",  ## default
  #hidden=c(200,200),       ## default: 2 hidden layers with 200 neurons each
  epochs=1,
  variable_importances=T    ## not enabled by default
)
plot(m1)
plot(h2o.performance(m1))
summary(m1)
m2 <- h2o.deeplearning(
  model_id="dl_model_faster", 
  training_frame=train, 
  validation_frame=valid,
  activation="TanhWithDropout",
  x=predictors,
  y=response,
  hidden=c(32,32,32),                  ## small network, runs faster
  epochs=100,                        ## hopefully converges earlier...
  score_validation_samples=100,      ## sample the validation dataset (faster)
  stopping_rounds=2,
  l1=1e-5,                             ## add some L1/L2 regularization
  l2=1e-5,
  stopping_metric="misclassification", ## could be "MSE","logloss","r2"
  stopping_tolerance=0.01
)
summary(m2)
plot(m2)
plot(h2o.performance(m2))

m3 <- h2o.deeplearning(
  model_id="dl_model_faster", 
  training_frame=train, 
  validation_frame=valid,
  activation="RectifierWithDropout",
  input_dropout_ratio=.2,
  x=predictors,
  y=response,
  hidden=c(100,80,60,40),                ## small network, runs faster
  epochs=10,                        ## hopefully converges earlier...
  score_validation_samples=100,      ## sample the validation dataset (faster)
  stopping_rounds=2,
  l1=1e-5,                             ## add some L1/L2 regularization
  l2=1e-5,
  max_w2=10,  					##bound rectifier
  stopping_metric="misclassification", ## could be "MSE","logloss","r2"
  stopping_tolerance=0.01
)
summary(m3)
plot(m3)
plot(h2o.performance(m3))


dat2=read.csv("test.csv",header=TRUE,quote="") #Load data

nrow(dat2)
dat2=dat2[,-1]  # remove the ID column
dat_h2o_submit = as.h2o(dat2) #Convert to h2o dataframe

nrow(dat_h2o_submit)
## Using the DNN model for predictions
h2o_yhat_test <- h2o.predict(m3, dat_h2o_submit)
nrow(as.data.frame(h2o_yhat_test))
## Converting H2O format into data frame
df_yhat_test <- as.data.frame(h2o_yhat_test)
write.csv(df_yhat_test,file="submith2oCorrectNumber.csv")