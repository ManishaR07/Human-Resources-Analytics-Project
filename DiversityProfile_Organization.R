
## importing the libraries
library(ggplot2)
library(caret)
library(car)
library(dplyr)


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

## EXPLORATORY DATA ANALYSIS
### Removing redundant columns
hr.data.opt <- hr.data %>%
  dplyr::select(-EmpID, -MaritalStatusID, -GenderID, -EmpStatusID, -DeptID, -PerfScoreID, -PositionID, -Zip, -ManagerID, -MarriedID)

## Analysing the diversity profile of the organization on Age, Gender, Citizen status, Race, Hispanic or Not, Marital Status, State

## Analyzing Gender Distribution in dataset
ggplot(hr.data.opt,aes(x=Sex))+
  geom_bar(fill = "green")+
  xlab("Gender")+
  ylab("Count")+
  geom_text(stat='count', aes(label=..count..), vjust=-1)+
  ggtitle("Distribution by Gender")

prop.table(table(hr.data.opt$Sex))
## 57% Males and 43% Females

##Analyzing Distribution by Marital Status 
ggplot(hr.data.opt,aes(x=MaritalDesc))+
  geom_bar(fill = "green")+
  xlab("Marital Status")+
  ylab("Count")+
  geom_text(stat='count', aes(label=..count..), vjust=-1)+
  ggtitle("Distribution by Marital Status")

prop.table(table(hr.data.opt$MaritalDesc))
## Single (44%), Married (40%), Divorced (10%), Separated (4%), Widowed (3%)

## Analyzing distribution by Race in dataset
ggplot(hr.data.opt,aes(x=RaceDesc))+
  geom_bar(fill = "green")+
  xlab("Race")+
  ylab("Count")+
  geom_text(stat='count', aes(label=..count..), vjust=-1)+
  ggtitle("Distribution by Race")

prop.table(table(hr.data.opt$RaceDesc))
## White (60%), Black or African American(26%), Asian (9%),

## Analyzing distribution by citizenship status in dataset
ggplot(hr.data.opt,aes(x=CitizenDesc))+
  geom_bar(fill = "green")+
  xlab("Citizen Status")+
  ylab("Count")+
  geom_text(stat='count', aes(label=..count..), vjust=-1)+
  ggtitle("Distribution by Citizen Status")

prop.table(table(hr.data.opt$CitizenDesc))
## 95% (US Citizens), 4%(Eligible Noncitizen), 1%(Non-citizen)

## Analyzing distribution by Age
hist(hr.data.opt$Age, breaks = 10)

## We have maximum employees with 304-40 yrs of age followed by 40-50yrs age group

## Analyzing distribution by state of residence dataset
ggplot(hr.data.opt,aes(x=State))+
  geom_bar(fill = "green")+
  xlab("State")+
  ylab("Count")+
  geom_text(stat='count', aes(label=..count..), vjust=-1)+
  ggtitle("Distribution by State of Residence")

prop.table(table(hr.data.opt$State))
## 88% of employees live in MA and 2% employees live in CT


