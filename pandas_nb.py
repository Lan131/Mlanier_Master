def answer_one(data):
    data=df
    answer=max(data['Gold'])
    data=data[data['Gold']==answer]
    j=data.index.tolist()
    string=str(j)[2:len(j)-3]
    return string
answer_one(df)



def answer_two(data):
    data=df
    diff=abs(data['Gold']-data['Gold.1'])
    answer=max(diff)
    data=diff[diff[0:]==answer]
    j=data.index.tolist()
    string=str(j)[2:len(j)-3]
    return string
answer_two(df)



def answer_three(data):
    data=df
    data=data[(data['Gold.1']>0) & (data['Gold.2']>0)]
    diff=(abs(data['Gold']-data['Gold.1']))/(data['Combined total'])
    answer=max(diff)
    data=diff[diff[0:]==answer]
    j=data.index.tolist()
    string=str(j)[2:len(j)-3]
    return string
answer_three(df)


def Points(data):
    series=data['Gold.2']*3+data['Silver.2']*2+data['Bronze.2']*1
    return series
Points(df)
