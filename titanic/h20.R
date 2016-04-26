
getwd()
setwd("C:/Users/Michael/Desktop/titanic")

# The following two commands remove any previously installed H2O packages for R.
 if ("package:h2o" %in% search()) 
{ detach("package:h2o", unload=TRUE) }
 if ("h2o" %in% rownames(installed.packages()))
 { remove.packages("h2o") } 
 # Next, we download, install and initialize the H2O package for R.

install.packages("h2o", repos=(c("http://s3.amazonaws.com/h2o-release/h2o/master/1497/R", getOption("repos"))))

 library(h2o)


library(devtools)
#install_github("h2oai/h2o-3/h2o-r/ensemble/h2oEnsemble-package")
h2o.shutdown(prompt=FALSE)
h2o.removeAll() ## clean slate - just in case the cluster was already running
h2o.init(nthreads = -1,min_mem_size="1G",max_mem_size="1G")


dat=read.csv("train.csv",header=TRUE,quote="") #Load data

names(dat)
dat
dat_h2o = as.h2o(dat) #Convert to h2o dataframe
splits = h2o.splitFrame(dat_h2o, c(0.6,0.2), seed=1234) #split into train and test
train  = h2o.assign(splits[[1]], "train.hex") # 60%
valid  = h2o.assign(splits[[2]], "valid.hex") # 20%
test   = h2o.assign(splits[[3]], "test.hex")  # 20%

predictors <- setdiff(names(dat_h2o), response)
predictors
train$Survived <- as.factor(train$Survived) ##make categorical
train$Pclass <- as.factor(train$Pclass) ##make categorical
train$Sex <- as.factor(train$Sex ) ##make categorical
train$SibSp <- as.factor(train$SibSp) ##make categorical
train$Cabin <- as.factor(train$Cabin) ##make categorical
train$Embarked <- as.factor(train$Embarked) ##make categorical
response <- "Survived"
dat_h2o 
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
  model_id="dl_model_faster2", 
  training_frame=train, 
  validation_frame=valid,
  activation="TanhWithDropout",
  x=predictors,
  y=response,
  hidden=c(100,100,100,100,50),                  ## small network, runs faster
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
  activation="TanhWithDropout",
  input_dropout_ratio=.05,
  x=predictors,
  y=response,
  hidden=c(200,100,80,60,40),                ## small network, runs faster
  epochs=25,                        ## hopefully converges earlier...
  score_validation_samples=50,      ## sample the validation dataset (faster)
  stopping_rounds=2,
  l1=1e-5,                             ## add some L1/L2 regularization
  l2=1e-5,
  max_w2=10,  					##bound rectifier
  stopping_metric="misclassification", ## could be "MSE","logloss","r2"
  stopping_tolerance=0.1
)
summary(m3)
plot(m3)
plot(h2o.performance(m3))





m6 <- h2o.deeplearning(  
 training_frame=train,   
 validation_frame=valid,   
 x=predictors,   
 y=response,
 activation="TanhWithDropout",
 hidden=c(50,30,20),          ## more hidden layers -> more complex interactions 
 epochs=100,                      ## to keep it short enough  
 score_validation_samples=100, ## downsample validation set for faster scoring   
           
 l1=1e-5,                        ## add some L1/L2 regularization  
 l2=1e-5,  
 max_w2=10 ,
  variable_importances=T  ,
  stopping_metric="misclassification", ## could be "MSE","logloss","r2"
  stopping_tolerance=0.1  )                   ## helps stability for Rectifier
 summary(m6)

plot(m6)




mboost <- h2o.gbm(training_frame=train,   
 validation_frame=valid,   
 x=predictors,   
 y="Survived",
seed=159
   , ntrees = 500, max_depth = 10, min_rows = 10,learn_rate=.0001,
  stopping_metric="misclassification",   stopping_tolerance=0.1)

summary(mboost)
plot(mboost)


hyper_parameters <- list(
ntrees=c(50,100,150),
max_depth=c(5,10,15),
learn_rate=c(.25,.5,.75,1)
)


grid <- h2o.grid("gbm", 
hyper_params = hyper_parameters, 
y = response, x = predictors, distribution="bernoulli", 
training_frame =train, validation_frame = valid)



#### Random Hyper-Parameter Search
#Often, hyper-parameter search for more than 4 parameters can be done more efficiently with random parameter search than with grid search. Basically, chances are good to find one of many good models in less time than performing an exhaustive grid search. We simply build up to `max_models` models with parameters drawn randomly from user-specified distributions (here, uniform). For this example, we use the adaptive learning rate and focus on tuning the network architecture and the regularization parameters. We also let the grid search stop automatically once the performance at the top of the leaderboard doesn't change much anymore, i.e., once the search has converged.
#
hyper_params <- list(
  activation=c("Rectifier","Tanh","Maxout","RectifierWithDropout","TanhWithDropout","MaxoutWithDropout"),
  hidden=list(c(20,20),c(50,50),c(30,30,30),c(25,25,25,25)),
  input_dropout_ratio=c(0,0.05),
  l1=seq(0,1e-4,1e-6),
  l2=seq(0,1e-4,1e-6)
)
hyper_params

## Stop once the top 5 models are within 1% of each other (i.e., the windowed average varies less than 1%)
search_criteria = list(strategy = "RandomDiscrete", max_runtime_secs = 360, max_models = 100, seed=1234567, stopping_rounds=5, stopping_tolerance=1e-2)
dl_random_grid <- h2o.grid(
  algorithm="deeplearning",
  grid_id = "dl_grid_random",
  training_frame=train,
  validation_frame=valid, 
  x=predictors, 
  y=response,
  epochs=1,
  stopping_metric="misclassification",
  stopping_tolerance=1e-2,        ## stop when misclassification does not improve by >=1% for 2 scoring events
  stopping_rounds=2,
  score_validation_samples=100, ## downsample validation set for faster scoring
  score_duty_cycle=0.025,         ## don't score more than 2.5% of the wall time
  max_w2=10,                      ## can help improve stability for Rectifier
  hyper_params = hyper_params,
  search_criteria = search_criteria
)                                
grid <- h2o.getGrid("dl_grid_random",sort_by="accuracy",decreasing=FALSE)
grid

grid@summary_table[1,]
best_model <- h2o.getModel(grid@model_ids[[1]]) ## model with lowest logloss
best_model
#  
#Let's look at the model with the lowest validation misclassification rate:
#
grid <- h2o.getGrid("dl_grid",sort_by="err",decreasing=FALSE)
best_model <- h2o.getModel(grid@model_ids[[1]]) ## model with lowest classification error (on validation, since it was available during training)
h2o.confusionMatrix(best_model,valid=T)
best_params <- best_model@allparameters
best_params$activation
best_params$hidden
best_params$input_dropout_ratio
best_params$l1
best_params$l2
#    






dat2=read.csv("test.csv",header=TRUE,quote="") #Load data
dat2
nrow(dat2)

dat_h2o_submit = as.h2o(dat2) #Convert to h2o dataframe

nrow(dat_h2o_submit)
## Using the DNN model for predictions
h2o_yhat_test <- h2o.predict(mboost, dat_h2o_submit)
nrow(as.data.frame(h2o_yhat_test))
## Converting H2O format into data frame
df_yhat_test <- as.data.frame(h2o_yhat_test)
write.csv(df_yhat_test,file="submith2oboost.csv")




dat2=read.csv("test.csv",header=TRUE,quote="") #Load data
dat2
nrow(dat2)

dat_h2o_submit = as.h2o(dat2) #Convert to h2o dataframe

nrow(dat_h2o_submit)
## Using the DNN model for predictions
h2o_yhat_test <- h2o.predict(m6, dat_h2o_submit)
nrow(as.data.frame(h2o_yhat_test))
## Converting H2O format into data frame
df_yhat_test <- as.data.frame(h2o_yhat_test)
write.csv(df_yhat_test,file="submith2oCorrectNumber.csv")