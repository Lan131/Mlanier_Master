import pybrain
from __future__ import print_function
from pybrain.datasets import SequentialDataSet
from itertools import cycle
from pybrain.tools.shortcuts import buildNetwork
from pybrain.structure.modules import LSTMLayer
from pybrain.supervised import RPropMinusTrainer
from sys import stdout
import matplotlib.pyplot as plt


#data = [1] * 3 + [2] * 3
#data *= 3
#print(data)

#Try some real data


#data=

ds = SequentialDataSet(1, 1)
for sample, next_sample in zip(data, cycle(data[1:])):
    ds.addSample(sample, next_sample)
    


net = buildNetwork(1, 5, 1, 
                   hiddenclass=LSTMLayer, outputbias=False, recurrent=True)  
        
                   
                   


trainer = BackpropTrainer(net, ds, learningrate = 0.001, momentum = 0.99)
train_errors = [] # save errors for plotting later
EPOCHS_PER_CYCLE = 2
CYCLES = 10

trainer.trainUntilConvergence(verbose=True)

EPOCHS = EPOCHS_PER_CYCLE * CYCLES
for i in xrange(CYCLES):
    trainer.trainEpochs(EPOCHS_PER_CYCLE)
    train_errors.append(trainer.testOnData())
    epoch = (i+1) * EPOCHS_PER_CYCLE
    print("\r epoch {}/{}".format(epoch, EPOCHS), end="")
    stdout.flush()


print("final error =", train_errors[-1])

plt.plot(range(0, EPOCHS, EPOCHS_PER_CYCLE), train_errors)
plt.xlabel('epoch')
plt.ylabel('error')
plt.show()

for sample, target in ds.getSequenceIterator(0):
    print("               sample = %4.1f" % sample)
    print("predicted next sample = %4.1f" % net.activate(sample))
    print("   actual next sample = %4.1f" % target)
    print()
    




