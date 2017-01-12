import h2o
from h2o.estimators.deeplearning import H2OAutoEncoderEstimator
h2o.init()

import matplotlib
import numpy as np
import matplotlib.pyplot as plt
import os.path
PATH = os.path.expanduser("~/h2o-3/")



train_ecg = h2o.import_file(PATH + "smalldata/anomaly/ecg_discord_train.csv")
test_ecg = h2o.import_file(PATH + "smalldata/anomaly/ecg_discord_test.csv")


train_ecg.shape
# transpose the frame to have the time serie as a single colum to plot
train_ecg.as_data_frame().T.plot(legend=False, title="ECG Train Data", color='blue'); # don't display the legend


model = H2OAutoEncoderEstimator( 
        activation="Tanh", 
        hidden=[50], 
        l1=1e-5,
        score_interval=0,
        epochs=100
)

model.train(x=train_ecg.names, training_frame=train_ecg) 



model

reconstruction_error = model.anomaly(test_ecg)

#Now the question is: Which of the test_ecg time series are most likely an anomaly?
#We can select the top N that have high error rate

df = reconstruction_error.as_data_frame()

df['Rank'] = df['Reconstruction.MSE'].rank(ascending=False)

df_sorted = df.sort_values('Rank')


anomalies = df_sorted[ df_sorted['Reconstruction.MSE'] > 1.0 ]
anomalies

data = test_ecg.as_data_frame()
data.T.plot(legend=False, title="ECG Test Data", color='blue')


ax = data.T.plot(legend=False, color='blue')
data.T[anomalies.index].plot(legend=False, title="ECG Anomalies in the Data", color='red', ax=ax)


df_sorted
