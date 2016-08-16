setwd("C:\\Users\\0019091\\Desktop\\Tableau Reports")

pc=read.csv("C:/Users/0019091/Desktop/Tableau Reports/20160815SupP203.csv")
completes= read.csv("C:/Users/0019091/Desktop/Tableau Reports/20160815 Completed Inventory.csv")


#install.packages("sqldf")
#install.packages("PASWR")
options(scipen=999)
library(sqldf)
library(PASWR)
library(dplyr)
str(completes)
head(pc)
head(completes)
data=inner_join(pc, completes, by =  c("CCN" = "CCN") )
write.csv(file="joined_p2.csv",data)

sqldf('select Avg(Total.Time) from data group by PROC order by Avg(Total.Time)')
