
#https://plot.ly/python/getting-started/

import quandl
import numpy as np
import h2o

fin_dat=quandl.get("YAHOO/INDEX_DJI", authtoken="J7GJqf6vWm-teqU4ysfy", start_date="2014-01-23")


h2o.init(nthreads = -1, max_mem_size = 8)

data=h20.import_file(fin_dat)
data=h2o.data.drop(1)
idx=range(1,dim(data),1)
data=h20.cbind(idx,data)
