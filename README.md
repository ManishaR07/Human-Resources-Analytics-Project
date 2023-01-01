# Human-Resources-Analytics-Project

Project Overview 
The dataset is taken from Kaggle (https://www.kaggle.com/datasets/rhuebner/human-resources-data-set) and is about a fictitious company and the core data set contains names, DOBs, age, gender, marital status, date of hire, 
reasons for termination, department, whether they are active or terminated, position title, pay rate, manager name, absences, employee engagement score and performance score.

Following analysis have been conducted on the dataset
1) Is there any relationship between who a person works for and their performance score?
2) What is the overall diversity profile of the organization?
3) What are our best recruiting sources if we want to ensure a diverse organization?
4) Are there areas of the company where pay is not equitable?

METHODOLOGY
Exploratry data anlysis is conduted on the data to understand and clean the data. there are 311 observations with 36 variables. We remove the redudant columns - EmpId,MaritalStatusID, GenderIs, ManagerID, EmpstatusId,
DepartmentID, PerfScoreID, Zip, PositionID, Married ID and we are left with 26 variables. Using the DOB, Dateof Hire and DateofTermination columns we calculate Age and Tenure of employees
using Lubridate library. 

1) To analyse if there is a relationship between who a person works for and their performance score we use library GGally and function ggpairs to calculate correlation
coefficient between ManagerID and PerformanceScore
2) To analyse the overall diversity of the organization we use ggplot2 to analyse variables Gender, RaceDesc, CitizenDesc, Age to understand how diverse the organization is
3) To analyse the best recruiting sources through whpm we get maximum diverse candidates we use Gender, Citizen status, Race description to calculate a Diversity Score. We compare the diversity scores of the various recruitment channels.
4) To analyse if there is a Gender pay inequality we use Mann Whitney U test as the data is non-parametric so we cannot use Student's T-test

RESULTS
1) From the GGally plot we see that there is no correlation between Manager and the Performance Score, the correlation coefficient is 0.084
2) Gender diversity - 57% Males and 43% Females, Diversity by Race - White (60%), Black or African American(26%), Asian (9%), diversity by citizenship status - 
95% (US Citizens), 4%(Eligible Noncitizen), 1%(Non-citizen), Diversity by Age - We have maximum employees with 30-40 yrs of age followed by 40-50yrs age group
3) We find maximum diversity candidates through Indeed, followed by Linkedin and Google Search
4) Salary Analysis by Gender - Null hypothesis is that there is no difference in average salary of Male and Female. As the p-value is <0.05 
so we can reject the null hypothesis and we accept the alternate hypothesis that the average of one gender is considerably greater than that of the other gender
