setwd("C:\\Users\\Lanier\\Desktop\\Red")
library(caret)
library(deepnet)
dat=read.csv(file="act_train_preproccess.csv",header=T,stringsAsFactors = TRUE )
head(dat,10)
max=max(dat$char_38)
min=min(dat$char_38)
dat$char_38=(dat$char_38-min)/(max-min)
attach(dat)
data=cbind(char_2,char_7,char_8,char_9,char_13,char_38,outcome)
data=as.data.frame(data)
attach(data)
#Split data
set.seed(10)
## 75% of the sample size
smp_size <- floor(0.50 * nrow(data))

## set the seed to make your partition reproductible
#make numbers factors
train_ind <- sample(seq_len(nrow(data)), size = smp_size)

train <- data[train_ind, ]
test <- data[-train_ind, ]
attach(train)

dnn <- dbn.dnn.train( as.matrix(train[,-train$outcome]), c(outcome), hidden = c(5, 5, 5))
attach(test)
nn.test(dnn, as.matrix(test[-test$outcome]), c(outcome),t=.5)
str(test
nn.predict(dnn, train[,-train$outcome])
