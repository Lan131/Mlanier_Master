import keras
from keras.models import Sequential
from keras.utils import np_utils
from keras.layers.core import Dense, Activation, Dropout

import pandas as pd
import numpy as np

# Read data
train = pd.read_csv('C:\Users\\Michael\\Desktop\\titanic\\train_prepro.csv')
labels = train.ix[:,0].values.astype('int32')
X_train = (train.ix[:,1:].values).astype('float32')
X_test = (pd.read_csv('C:\\Users\\Michael\\Desktop\\titanic\\test_prepro.csv').values).astype('float32')

# convert list of labels to binary class matrix
y_train = np_utils.to_categorical(labels) 

# pre-processing: divide by max and substract mean
scale = np.max(X_train)
X_train /= scale
X_test /= scale

mean = np.std(X_train)
X_train -= mean
X_test -= mean

input_dim = X_train.shape[1]
nb_classes = y_train.shape[1]

# Here's a Deep Dumb MLP (DDMLP)
model = Sequential()

model.add(Dense(20, input_dim=input_dim))
model.add(Activation('sigmoid'))
model.add(Dropout(0.15))
keras.layers.noise.GaussianNoise(1)
keras.layers.recurrent.SimpleRNN(input_dim, init='glorot_uniform', inner_init='orthogonal', activation='sigmoid', W_regularizer=.001, U_regularizer=.001, b_regularizer=.001, dropout_W=0.01, dropout_U=0.1)
keras.layers.recurrent.GRU(input_dim, init='glorot_uniform', inner_init='orthogonal', activation='sigmoid', inner_activation='hard_sigmoid', W_regularizer=None, U_regularizer=None, b_regularizer=None, dropout_W=0.0, dropout_U=0.0)



model.add(Dense(nb_classes))
model.add(Activation('sigmoid'))

# we'll use categorical xent for the loss, and RMSprop as the optimizer
keras.optimizers.Adadelta(lr=.7, rho=0.95, epsilon=1e-06)
model.compile(loss='mae',class_mode='binary', optimizer='adadelta')

print("Training...")
model.fit(X_train, y_train, nb_epoch=1000, batch_size=100, validation_split=0.2, show_accuracy=True, verbose=2)

print("Generating test predictions...")
preds = model.predict_classes(X_test, verbose=0)

def write_preds(preds, fname):
    pd.DataFrame({"ImageId": list(range(1,len(preds)+1)), "Label": preds}).to_csv(fname, index=False, header=True)

write_preds(preds, "keras-RNN.csv")