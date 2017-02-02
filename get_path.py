import pandas as pd
import os

df = pd.DataFrame([,], columns=list('XY'))
dir_path = os.path.dirname(os.path.realpath(__file__))
folders = ['ALB', 'BET', 'DOL', 'LAG', 'NoF', 'OTHER', 'SHARK', 'YFT']
 

for fld in folders
    dir=os.listdir(dir_path + "\"+fld)
    data = pd.DataFrame({dir: fld})
    df.append(data)
