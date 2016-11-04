
# The following two commands remove any previously installed H2O packages for R.
if ("package:h2o" %in% search()) { detach("package:h2o", unload=TRUE) }
if ("h2o" %in% rownames(installed.packages())) { remove.packages("h2o") }

# Next, we download packages that H2O depends on.
pkgs <- c("methods","statmod","stats","graphics","RCurl","jsonlite","tools","utils")
for (pkg in pkgs) {
  if (! (pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
}

# Now we download, install and initialize the H2O package for R.
install.packages("h2o", type="source", repos=(c("http://h2o-release.s3.amazonaws.com/h2o/rel-turing/3/R")))
library(h2o)

library(devtools)
#install_github("h2oai/h2o-3/h2o-r/ensemble/h2oEnsemble-package")
library(h2oEnsemble)
library(ggplot2)
library(caret) #preprocessing
library(dplyr) # data manipulation
library(rpart) # rpart for imputation
setwd("C:\\Users\\Lanier\\Desktop\\Kaggle\\Allstate")
#Load Data



# Read the data
train_master <-read.csv(file="train.csv",header=T,stringsAsFactors = TRUE )
train_master=train_master[,-1]

attach(train_master)
#fit=lm(loss~.,data=train_master)
#summary(fit)
#anova(fit)




#Start up h20 cluster for deep learning

h2o.shutdown(prompt = TRUE)

h2o.init(nthreads = -1, max_mem_size="14g")
dat_h2o = as.h2o(train_master) #Convert to h2o dataframe


#train_master=train_master[,-132]
# Split up train and test data


splits = h2o.splitFrame(dat_h2o, c(0.6,0.2), seed=1234) #split into train and test
train  = h2o.assign(splits[[1]], "train.hex") # 60%
valid  = h2o.assign(splits[[2]], "valid.hex") # 20%  #For hyperparam search
test   = h2o.assign(splits[[3]], "test.hex")  # 20%



response <- "loss"
predictors <- setdiff(names(train), response)
predictors




#Try first model
m1 <- h2o.deeplearning(
  model_id="dl_model_first", 
  training_frame=train, 
  validation_frame=valid,   ## validation dataset: used for scoring and early stopping
  x=predictors,
  y=response,
  loss="Absolute",
  activation="Rectifier",  ## default
  hidden=c(200,200),       ## default: 2 hidden layers with 200 neurons each
  epochs=3,
  nfolds = 5,
  variable_importances=T    ## not enabled by default
)


#examine model
plot(m1)
summary(m1)


#1181.3048 v mae






mboost <- h2o.gbm(training_frame=train,   model_id="mboost",
                  validation_frame=valid,   
                  x=predictors,   
                  y=response,
                  seed=1591,
                  balance_classes=TRUE,
                  nfolds=5
                  
                  
                  , ntrees = 300, max_depth = 7, min_rows = 10,learn_rate=.043,
                  stopping_metric="AUTO",   stopping_tolerance=0.01)
print(mboost)
plot(mboost)


#MAE:  1236


#Autoencoder

auto = h2o.deeplearning(x = names(train), training_frame = train,
                               autoencoder = TRUE,activation="TanhWithDropout",
                               hidden = c(10,5,10), epochs = 5)

summary(auto)

dat.anon = h2o.anomaly(auto, train, per_feature=FALSE)
head(dat.anon)
err <- as.data.frame(dat.anon)
plot(sort(err$Reconstruction.MSE), main='Reconstruction Error')

train_df_auto <- train_master[err$Reconstruction.MSE < 0.04,]
recon<- train_master[err$Reconstruction.MSE > 0.04,]
write.csv(recon ,"recon.csv")
write.csv(train_df_auto,"denoised.csv")
train=as.h2o(train_df_auto)
set.seed(1234)



m0 <- h2o.deeplearning(
  model_id="dl_model_first", 
  training_frame=train, 
  validation_frame=valid,   ## validation dataset: used for scoring and early stopping
  x=names(train),
  y="loss",
  loss="Absolute",
  activation="Rectifier",  ## default
  hidden=c(200,200),       ## default: 2 hidden layers with 200 neurons each
  epochs=1,
  nfolds = 2,
  variable_importances=T    ## not enabled by default
)

plot(m0)
summary(m0)




m3 <- h2o.deeplearning(
  model_id="dl_model_first", 
  training_frame=train, 
  validation_frame=valid,   ## validation dataset: used for scoring and early stopping
  x=names(train),
  y="loss",
  loss="Absolute",
  activation="MaxoutWithDropout",  ## default
  hidden=c(400,200,50),       ## default: 2 hidden layers with 200 neurons each
  epochs=10,
  nfolds = 5,
  l1=1e-4,
  l2=1e-4,
  variable_importances=T
    ## not enabled by default
)

plot(m3)
summary(m3)





#### Random Hyper-Parameter Search

hyper_params <- list(
  activation=c("Rectifier","Tanh","Maxout","RectifierWithDropout","TanhWithDropout","MaxoutWithDropout"),
  hidden=list(c(20,20),c(100,75,50),c(25,25,25,25),c(2,4,6,8,6,4,2),c(2000,1000,500)),
  input_dropout_ratio=seq(.4,.6,by=.01), #For ensemble effect see Hinton's work for explaination
  l1=seq(0,1e-4,1e-6),
  l2=seq(0,1e-4,1e-6),               
  rate=seq(0.001,.7,by=.001) ,
  rate_annealing=seq(0,2e-4,by= 1e-5)
  
)
hyper_params


## Stop once the top 5 models are within 1% of each other (i.e., the windowed average varies less than 1%)
search_criteria = list(strategy = "RandomDiscrete", max_runtime_secs = 360, max_models = 3, seed=1234567, stopping_rounds=3, stopping_tolerance=1e-2)
dl_random_grid <- h2o.grid(
  algorithm="deeplearning",
  grid_id = "dl_grid_random",
  training_frame=train,
  validation_frame=valid, 
  x=predictors, 
  y=response,
  epochs=1,
  loss="Absolute",
  stopping_metric="AUTO",
  stopping_tolerance=1e-3,        ## stop when logloss does not improve by >=1% for 2 scoring events
  stopping_rounds=3,
  score_validation_samples=500, ## downsample validation set for faster scoring
  score_duty_cycle=0.025,         ## don't score more than 2.5% of the wall time
  max_w2=5,                      ## can help improve stability for Rectifier
  hyper_params = hyper_params,
  search_criteria = search_criteria,
  variable_importances=T,
  standardize=TRUE

)            

#error in stopping_tolerence

#examine grid
grid <- h2o.getGrid("dl_grid_random",sort_by="mse",decreasing=TRUE)
grid

grid@summary_table[1,]
best_model <- h2o.getModel(grid@model_ids[[1]]) ## model with highest accuracy
plot(best_model)

#Try second model
m2 <- h2o.deeplearning(
  model_id="dl_model_second", 
  training_frame=train, 
  validation_frame=valid,   ## validation dataset: used for scoring and early stopping
  x=predictors,
  y=response,
  loss="Absolute",
  activation="MaxoutWithDropout",  ## defaultS
  hidden=c(400,200,50),       ## default: 2 hidden layers with 200 neurons each
  epochs=3,
  nfolds=5,
  l1=1e-4,
  l2=1e-4,    
  variable_importances=T    ## not enabled by default
)


#examine model
plot(m2)
summary(m2)







learner <- c("h2o.glm.wrapper", "h2o.randomForest.wrapper", 
             "h2o.gbm.wrapper", "h2o.deeplearning.wrapper")
metalearner <- "h2o.glm.wrapper"
fit <- h2o.ensemble(  x=predictors, 
                      y=response, 
                      training_frame = train, 
                      family = "AUTO", 
                      learner = learner, 
                      metalearner = metalearner,
                      cvControl = list(V = 5))

pred <- predict(fit, test)

predictions <- as.data.frame(pred$pred)  #third column is P(Y==1)

print=cbind(as.data.frame(pred$basepred),predictions,as.data.frame(test[,132]))
write.csv(print,"ensemble.csv")




test_master=read.csv(file="test.csv",header=T,stringsAsFactors = TRUE )
dat_h2o_final = as.h2o(test_master)
pred <- predict(fit, dat_h2o_final)

predictions <- as.data.frame(pred$pred)  

print=cbind(as.data.frame(dat_h2o_final [,1]),as.data.frame(pred$basepred),predictions)
write.csv(print,"ensemble_final.csv")


h2o.shutdown()


h2o_yhat_test_dl <- as.data.frame(h2o_yhat_test_dl) 
h2o_yhat_test_dl =test_agg [,-1]
h2o_yhat_test_dl =cbind(as.data.frame(test_id[,1]),h2o_yhat_test_dl )
colnames(h2o_yhat_test_dl)[1] <- "ID"
write.csv(h2o_yhat_test_dl,file="submission.csv", row.names=FALSE)
