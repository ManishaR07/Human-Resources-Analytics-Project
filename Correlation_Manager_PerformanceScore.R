## importing the libraries
library(ggplot2)
library(caret)
library(car)
library(dplyr)
library(lubridate)
library(GGally)

## Loading the data
hr.data <- read.csv("HRDataset_v14.csv",header = TRUE,sep=",",stringsAsFactors = FALSE)

## Exploring the data
str(hr.data) ##311 obs with 36 variables
summary(hr.data)
names(hr.data)

## Checking for missing data
colSums(is.na(hr.data))
hr.data[hr.data==""] <- NA
## 8 missing data in ManagerID and Date of Termination - 207 missing

## EXPLORATORY DATA ANALYSIS
### Removing redundant columns
hr.data.opt <- hr.data %>%
  dplyr::select(-EmpID, -MaritalStatusID, -GenderID, -EmpStatusID, -DeptID, -PerfScoreID, -PositionID, -Zip, -MarriedID)

str(hr.data.opt) ## 311 obs with 26 variables

## Calculating age from DOB column
hr.data.opt$DOB <- as.Date(hr.data.opt$DOB,"%m/%d/%y")
x_date   <- Sys.Date()
hr.data.opt$Age <- trunc((hr.data.opt$DOB %--% x_date) / years(1))
head(hr.data.opt$Age)

## Calculating tenure from Date of Hire column
hr.data.opt$DateofHire <- as.Date(hr.data.opt$DateofHire,"%m/%d/%y")
x_date   <- Sys.Date()

## Calculating yearsworked from Date of Termination column
hr.data.opt$DateofTermination <- as.Date(hr.data.opt$DateofTermination,"%m/%d/%y")
hr.data.opt$Tenure <- ifelse(is.na(hr.data.opt$DateofTermination),(trunc((hr.data.opt$DateofHire %--% x_date) / years(1))),(trunc((hr.data.opt$DateofHire %--% hr.data.opt$DateofTermination) / years(1))))
head(hr.data.opt$Tenure)

## Analysing if there is any relationship between who a person works for and their performance score?
## Converting ManagerId and PerformanceScore into factor variables
hr.data.opt$ManagerID <- as.numeric(hr.data.opt$ManagerID)
hr.data.opt$PerformanceScore <- as.numeric(hr.data.opt$PerformanceScore)
hr.data.cor <- subset(hr.data.opt,select=c(ManagerID,PerformanceScore))

#Calculating factor frequencies
GGally::ggpairs(hr.data.cor)

## From the GGally plot we see that there is no correlation between Manager and the Performance Score