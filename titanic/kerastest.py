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
model.add(Dense(1280, input_dim=input_dim))
model.add(Activation('tanh'))
model.add(Dropout(0.05))
keras.layers.normalization.BatchNormalization(epsilon=1e-06, mode=0, axis=-1, momentum=0.9, weights=None, beta_init='zero', gamma_init='one')

model.add(Dense(1280))
model.add(Activation('tanh'))
model.add(Dropout(0.05))
keras.layers.normalization.BatchNormalization(epsilon=1e-06, mode=0, axis=-1, momentum=0.9, weights=None, beta_init='zero', gamma_init='one')

keras.layers.noise.GaussianNoise(1)

model.add(Dense(1100))
model.add(Activation('tanh'))
model.add(Dropout(0.05))
keras.regularizers.WeightRegularizer(l1=.01, l2=.01)

model.add(Dense(500))
model.add(Activation('tanh'))
model.add(Dropout(0.05))
keras.regularizers.WeightRegularizer(l1=.01, l2=.01)

model.add(Dense(200))
model.add(Activation('tanh'))
model.add(Dropout(0.05))
keras.layers.noise.GaussianNoise(1)

model.add(Dense(110))
model.add(Activation('tanh'))
model.add(Dropout(0.05))
keras.regularizers.WeightRegularizer(l1=.01, l2=.01)

model.add(Dense(50))
model.add(Activation('tanh'))
model.add(Dropout(0.05))
keras.regularizers.WeightRegularizer(l1=.01, l2=.01)

model.add(Dense(40))
model.add(Activation('tanh'))
model.add(Dropout(0.05))
keras.regularizers.WeightRegularizer(l1=.01, l2=.01)

model.add(Dense(20))
model.add(Activation('tanh'))
model.add(Dropout(0.05))
keras.regularizers.WeightRegularizer(l1=.01, l2=.01)

model.add(Dense(10))
model.add(Activation('tanh'))
model.add(Dropout(0.05))
keras.regularizers.WeightRegularizer(l1=.01, l2=.01)

keras.layers.noise.GaussianNoise(1)

model.add(Dense(5))
model.add(Activation('tanh'))
keras.regularizers.WeightRegularizer(l1=.01, l2=.01)


model.add(Dense(5))
model.add(Activation('tanh'))
keras.regularizers.WeightRegularizer(l1=.01, l2=.01)


model.add(Dense(3))
model.add(Activation('tanh'))
keras.regularizers.WeightRegularizer(l1=.01, l2=.01)

keras.layers.recurrent.SimpleRNN(input_dim, init='glorot_uniform', inner_init='orthogonal', activation='tanh', W_regularizer=.001, U_regularizer=.001, b_regularizer=.001, dropout_W=0.0, dropout_U=0.0)
keras.layers.recurrent.GRU(input_dim, init='glorot_uniform', inner_init='orthogonal', activation='tanh', inner_activation='hard_sigmoid', W_regularizer=None, U_regularizer=None, b_regularizer=None, dropout_W=0.0, dropout_U=0.0)

model.add(Dense(nb_classes))
model.add(Activation('softmax'))

# we'll use categorical xent for the loss, and RMSprop as the optimizer
model.compile(loss='binary_crossentropy', optimizer='Adadelta')

print("Training...")
model.fit(X_train, y_train, nb_epoch=100, batch_size=50, validation_split=0.2, show_accuracy=True, verbose=2)

print("Generating test predictions...")
preds = model.predict_classes(X_test, verbose=0)

def write_preds(preds, fname):
    pd.DataFrame({"ImageId": list(range(1,len(preds)+1)), "Label": preds}).to_csv(fname, index=False, header=True)

write_preds(preds, "keras-mlp.csv")