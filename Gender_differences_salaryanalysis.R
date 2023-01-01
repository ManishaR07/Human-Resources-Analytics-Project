## Project Over view - Analyze if gender differences are related to pay inequality
library(ggplot2)

## Loading the data
hr.data <- read.csv("HRDataset_v14.csv",header = TRUE,sep=",",stringsAsFactors = FALSE)

str(hr.data)

#Assumption 1 - Salary normally distributed
hist(x=hr.data$Salary)
shapiro.test(x=hr.data$Salary) ##As p-vale is less than 0.05 so data is not normally distributed

## We cannot use T-test as the data is non parametric. Hence we use Mann Whitney U Test
wilcox.test(hr.data$GenderID, hr.data$Salary)

## As the p-value is <0.05 so we can reject the null hypothesis and we accept the alternate hypothesis that the average of one gender is considerably greater than that of the other gender
