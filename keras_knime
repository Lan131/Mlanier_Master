

import keras
from keras.models import Sequential
from keras.utils import np_utils
from keras.layers.core import Dense, Activation, Dropout

import pandas as pd
import numpy as np
X_test=(input_table_2.ix[:,1:].values).astype('float32')
labels = input_table_1.ix[:,0].values.astype('int32')
X_train = (input_table_1.ix[:,1:].values).astype('float32')
y_train = np_utils.to_categorical(labels) 
input_dim = X_train.shape[1]
nb_classes = y_train.shape[1]
y_train = np_utils.to_categorical(labels) 
# Here's a Deep Dumb MLP (DDMLP)
model = Sequential()

model.add(Dense(flow_variables['n'], input_dim=input_dim))
model.add(Activation('tanh'))
model.add(Dropout(flow_variables['Drop']))

keras.layers.noise.GaussianNoise(flow_variables['N'])
keras.layers.recurrent.SimpleRNN(input_dim, init='glorot_uniform', inner_init='orthogonal', activation='tanh', W_regularizer=.001, U_regularizer=.001, b_regularizer=.001, dropout_W=0.01, dropout_U=0.1)
keras.layers.recurrent.GRU(input_dim, init='glorot_uniform', inner_init='orthogonal', activation='tanh', inner_activation='hard_sigmoid', W_regularizer=None, U_regularizer=None, b_regularizer=None, dropout_W=0.0, dropout_U=0.0)



model.add(Dense(nb_classes))
model.add(Activation('sigmoid'))

# we'll use mean abs error for the loss, and adadelta as the optimizer
keras.optimizers.Adadelta(lr=flow_variables['lr'], rho=.5, epsilon=.00001,clipnorm=0.1)
model.compile(loss='mae', class_mode='binary',optimizer='adadelta')
model.fit(X_train, y_train, nb_epoch=50, batch_size=100, validation_split=0.2, show_accuracy=True, verbose=2)


preds= model.predict_classes(X_test, verbose=0)
output_table = pd.DataFrame(preds)
