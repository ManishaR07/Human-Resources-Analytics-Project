
## importing the libraries
library(ggplot2)
library(caret)
library(car)
library(dplyr)
library(purrr)


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

##Converting Recruitment Source into a factor variable
hr.data$RecruitmentSource <- as.factor(hr.data$RecruitmentSource)

## Calculating the Diversity Score
hr.data$Gender_score <- ifelse(hr.data$Sex == "M",0,1)
hr.data$Cit_Score <- ifelse(hr.data$CitizenDesc =="US Citizen",0,1)
hr.data$Race_score <- ifelse(hr.data$RaceDesc =="White",0,1)
hr.data <- hr.data %>%
  mutate(DivScore= rowSums(data.frame(Gender_score,Cit_Score,Race_score)))
View(hr.data)
## Calculating Average Diversity Score for each recruitment source

Rec_sum <- hr.data %>% group_by(RecruitmentSource) %>% summarise(Rec_sum = sum(DivScore))
Rec_sum

## We find maximum diversity candidates through Indeed, followed by Linkedin and Google Search
