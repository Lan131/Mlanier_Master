import h2o
from h2o.estimators.deeplearning import H2ODeepLearningEstimator
from h2o.estimators.deepwater import H2ODeepWaterEstimator
from h2o.estimators.gbm import H2OGradientBoostingEstimator
from h2o.estimators.random_forest import H2ORandomForestEstimator
import sys, os
import h2o
from h2o.estimators.deepwater import H2ODeepWaterEstimator
import os.path
import pandas as pd
import random
import os.path


!nvidia-smi

PATH=os.path.expanduser("~/default/")

h2o.init(nthreads=-1)
if not H2ODeepWaterEstimator.available(): exit



frame = h2o.import_file(PATH + "data_path")
submit_frame=h2o.import_file(PATH + "data_path")
print(frame.dim)
print(frame.head(5))



r = frame.runif(seed=123)
trial_frame = frame[r  < 0.01]                 ## 10% for trial run
train_ensemble=frame[r  < 0.8] 
test_ensemble=frame[r  > 0.8] 

frame=trial_frame  #Comment this out later


print(frame.dim)



lnet = H2ODeepWaterEstimator(epochs=500, network = "lenet",mini_batch_size=16,nfolds=5,GPU=True)
lnet.train(x=[0],y=1,training_frame=frame)
lnet.show()
error_l = lenet.model_performance(train=True).mean_per_class_error()

gnet = H2ODeepWaterEstimator(epochs=500, network = "googlenet",mini_batch_size=16,nfolds=5,GPU=True)
gnet.train(x=[0],y=1, training_frame=frame)
gnet.show()
error_g = gnet.model_performance(train=True).mean_per_class_error()

inet = H2ODeepWaterEstimator(epochs=500, network = "inception_bn",mini_batch_size=16,nfolds=5,GPU=True)
inet.train(x=[0],y=1, training_frame=frame)
inet.show()
error_i = inet.model_performance(train=True).mean_per_class_error()


anet = H2ODeepWaterEstimator(epochs=500, network = "alexnet",mini_batch_size=16,nfolds=5,GPU=True)
anet.train(x=[0],y=1, training_frame=frame)
anet.show()
error_a = anet.model_performance(train=True).mean_per_class_error()


#Find rank from the 4 networks and take a weighted average.

l=lnet.train(x=[0],y=1,training_frame=train_ensemble)
g=gnet.train(x=[0],y=1, training_frame=train_ensemble)
i=inet.train(x=[0],y=1, training_frame=train_ensemble)
a=anet.train(x=[0],y=1, training_frame=train_ensemble)

predict=0.1*(4*a.predict(test_ensemble)+3*g.predict(test_ensemble)+1*i.predict(test_ensemble)+2*a.predict(test_ensemble))[2])


h2o.make_metrics(actual=test[response],predicted=predict[2]).logloss()

submit_predict=0.1*(4*a.predict(submit_frame)+3*g.predict(submit_frame)+1*i.predict(submit_frame)+2*a.predict(submit_frame))[2])

df = pd.DataFrame( 'prob': submit_predict[1]})
df.to_csv('predictions.csv', index = True)




