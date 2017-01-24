
#https://plot.ly/python/getting-started/

import quandl
import numpy as np
import h2o

fin_dat=quandl.get("YAHOO/INDEX_DJI", authtoken="J7GJqf6vWm-teqU4ysfy", start_date="2014-01-23")


h2o.init(nthreads = -1, max_mem_size = 8)

data=h20.import_file(fin_dat)
data=h2o.data.drop(1)
Lag1=data[range(2,dim(data),1),:]
Lag2=data[range(3,dim(data),1),:]
Lag3=data[range(4,dim(data),1),:]
data=h20.cbind(data,Lag1,Lag2,Lag3)

myX=[**col names**]
model_fit_GBM <- h2o.gbm(x=myX,y="Close",data,nfolds=5,seed=1234,ntrees=100, max_depth=3, learn_rate=0.1)
