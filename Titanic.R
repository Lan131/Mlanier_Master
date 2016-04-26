install.packages("sqldf")
install.packages("PASWR")

library(sqldf)
library(PASWR)
library(ggplot2)

data(titanic3, package="PASWR")
colnames(titanic3)
head(titanic3)

sqldf('select age, count(*) from titanic3 where age is not null group by age')



DF=sqldf('select age from titanic3 where age != "NA"')
qplot(DF$age,data=DF, geom="histogram")

DF=sqldf('select count(*) total from titanic3 where age=29 group by survived')
DF2=t(DF)

colnames(DF2)=c('Died','Survived')
DF2


Survive= titanic3[,2]
Sex= titanic3[,4]
Sex

fit=glm(Survive~Sex, data=titanic3, family=binomial())
summary(fit)
anova(fit)

exp(fit$coef)[2]
