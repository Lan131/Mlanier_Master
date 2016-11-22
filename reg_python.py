# -*- coding: utf-8 -*-
"""
Created on Tue Nov 22 14:52:49 2016

@author: Lanier
"""

import matplotlib.pyplot as plt
import numpy as np
import statsmodels.formula.api as smf
import pandas as pd


data=pd.read_csv("With_interaction.csv")
data1=pd.get_dummies(data)
data.head()
data1.head()
data1.to_csv("dum_dat.csv")
data=np.asarray(data1)


X, y = data[:, 0:132], data[:, 132]


mod = smf.OLS(y, X)
res = mod.fit()
print res.summary()
