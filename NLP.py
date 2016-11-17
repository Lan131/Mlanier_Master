#NLP.py
import pandas as pd
import indicoio
import numpy as np
data=read_csv("train_class.csv",nrows=100)
data=pd.read_csv("train_class.csv",nrows=100)
indicoio.config.api_key = ''
tweets=data.ix[:,1]
 tweets=np.array(tweets)
 t=tweets.tolist()
T=indicoio.sentiment(t)
%store T >>text.txt
