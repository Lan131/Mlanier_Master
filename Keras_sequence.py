model = Sequential()
model.add(Masking(0, input_shape=(260, 100)))
model.add(LSTM(input_dim=100, output_dim=128, return_sequences=True))
model.add(TimeDistributedDense(input_dim=128, output_dim=1))
model.add(Activation('softmax'))

model.compile(loss='MSE', optimizer='adam')

model.fit(x_train, y_train, nb_epoch=40, batch_size=16)
score = model.evaluate(x_test, y_test, batch_size=16, show_accuracy=True)