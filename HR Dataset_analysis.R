## importing the libraries
library(ggplot2)
library(caret)
library(car)
library(dplyr)
library(lubridate)
library(anytime)

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
  dplyr::select(-EmpID, -MaritalStatusID, -GenderID, -EmpStatusID, -DeptID, -PerfScoreID, -PositionID, -Zip, -ManagerID, -MarriedID)

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




## Analyzing gender distribution in dataset
ggplot(hr.data.opt,aes(x=MaritalDesc))+
  geom_bar(fill = "green")+
  xlab("Marital Status")+
  ylab("Count")+
  geom_text(stat='count', aes(label=..count..), vjust=-1)+
  ggtitle("Distribution by Marital Status")

prop.table(table(hr.data.opt$MaritalDesc))
## 40% Married, Single (44%), divorced(10%)

## Analyzing distribution by citizenship status in dataset
ggplot(hr.data.opt,aes(x=CitizenDesc))+
  geom_bar(fill = "green")+
  xlab("Citizen Status")+
  ylab("Count")+
  geom_text(stat='count', aes(label=..count..), vjust=-1)+
  ggtitle("Distribution by Citizen Status")

prop.table(table(hr.data.opt$CitizenDesc))
## 95% (US Citizens), 4%(Eligible Noncitizen), 1%(Non-citizen)

## Analyzing distribution by Race in dataset
ggplot(hr.data.opt,aes(x=RaceDesc))+
  geom_bar(fill = "green")+
  xlab("Race")+
  ylab("Count")+
  geom_text(stat='count', aes(label=..count..), vjust=-1)+
  ggtitle("Distribution by Race")

prop.table(table(hr.data.opt$RaceDesc))
## White (60%), Black or African American(26%), Asian (9%),

## Analyzing distribution by Employment Status
ggplot(hr.data.opt,aes(x=EmploymentStatus))+
  geom_bar(fill = "green")+
  xlab("Race")+
  ylab("EmploymentStatus")+
  geom_text(stat='count', aes(label=..count..), vjust=-1)+
  ggtitle("Distribution by EmploymentStatus")

prop.table(table(hr.data.opt$EmploymentStatus))
## Active (67%), Terminated (29%), Terminated for cause(5%)

## Analyzing distribution by Termination reason
ggplot(hr.data.opt,aes(x=TermReason))+
  geom_bar(fill = "green")+
  xlab("Termination Reason")+
  ylab("Count")+
  geom_text(stat='count', aes(label=..count..), hjust=1)+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  ggtitle("Distribution by Termination Reason")

prop.table(table(hr.data.opt$TermReason))
## Another Position (6%), Unhappy (5%)

## Analyzing distribution by Department
ggplot(hr.data.opt,aes(x=Department))+
  geom_bar(fill = "green")+
  xlab("Department")+
  ylab("Count")+
  geom_text(stat='count', aes(label=..count..), hjust=1)+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  ggtitle("Distribution by Department")

prop.table(table(hr.data.opt$Department))
## 67% in Production, Sales (10%), IT/ITES (16%)

## Analyzing Attrition by Termination Reason and Department
ggplot(hr.data.opt,aes(x=TermReason))+
  geom_bar(fill = "Blue")+
  facet_wrap("Department")+
  xlab("Attrition")+
  ylab("Count")+
  geom_text(stat='count', aes(label=..count..), hjust=1)+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  ggtitle("Distribution by Attrition by Termination Reason and Department")

prop.table(table(hr.data.opt$Termd))
## 33.4% attrition

## Termination Reason and Gender
ggplot(hr.data.opt,aes(x=TermReason,fill=RaceDesc))+
  geom_bar()+
  facet_wrap("Sex")+
  theme(axis.text.x = element_text(angle = 90, hjust =1, vjust = 0.5))+
  xlab("Termination Reason")+
  ylab("Count")+
  geom_text(stat='count', aes(label=..count..), vjust=-1,check_overlap = TRUE)+
  ggtitle("Termination Reason by Gender")

prop.table(table(hr.data.opt$TermReason,hr.data.opt$Gender))

## Analyzing Attrition by Gender

prop.table(table(hr.data.opt$Termd,hr.data.opt$Sex))
## 19% Attrition in Females and 14$ in Females

## Analysing Attrition by Gender and Department
ggplot(hr.data.opt,aes(x=Department,fill=Sex))+
  geom_bar()+
  facet_wrap("Termd")+
  theme(axis.text.x = element_text(angle = 90, hjust =1, vjust = 0.5))+
  xlab("Department")+
  ylab("Count")+
  geom_text(stat='count', aes(label=..count..), vjust=-1,check_overlap = TRUE)+
  ggtitle("Attrition by Gender nd DEpartment")

prop.table(table(hr.data.opt$Termd,hr.data.opt$Sex,hr.data.opt$Department))

## Analyzing Engagement Survey results by Department
ggplot(data=hr.data.opt, mapping=aes(x=Department, y=EngagementSurvey))+geom_boxplot()

## Median of Admin Office is highest and sales is lowest with few outliers in Production







