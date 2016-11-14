import matplotlib as plt
import numpy as np
import pandas as pd

dat=pd.read_csv('Voters.csv').as_matrix()
x=dat[:,0]
y=dat[:,1]
plt.scatter(x,y)
plt.show()
plt.hist(x)
plt.hist(y,bins=15)


#images
train=pd.read_csv('test.csv')
M=train.as_matrix()
im=M[0,1:]
im=im.reshape(28,28)
M=train.as_matrix()
plt.imshow(im)
plt.show()
plt.imshow(im,cmap="gray")


from scipy.stats import norm
norm.pdf(0)
norm.pdf(0,loc=5, scale=10)
r=np.random.randn(10)
norm.pdf(r)
norm.cdf(r)
r=10*np.random.randn(10000)+5
plt.hist(r,bins=100)

r=np.random.randn(10000,2)
plt.scatter(r[:,0],r[:,1])
r[:,1]=5*r[:,1]+2
plt.scatter(r[:,0],r[:,1])

cov = np.array([[1,.8],[.8,3]])
from scipy.stats import multivariate_normal as mvn
mu=np.array([0,2])
r = mvn.rvs(mean=mu,cov=cov, size=1000)
plt.scatter(r[:,0],r[:,1])
plt.axis('equal')
plt.show()



