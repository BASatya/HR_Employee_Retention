
create database P811_1stweek;
use P811_1stweek;


CREATE TABLE HR_1 (
    Age INT,                                      
    Attrition VARCHAR(10),                        
    BusinessTravel VARCHAR(50),                   
    DailyRate INT,                                
    Department VARCHAR(50),                      
    DistanceFromHome INT,                         
    Education VARCHAR(50),                      
    EducationField VARCHAR(50),                   
    EmployeeCount INT,                           
    EmployeeNumber INT PRIMARY KEY,               
    EnvironmentSatisfaction INT,                  
    Gender VARCHAR(10),                           
    HourlyRate INT,                          
    JobInvolvement INT,                          
    JobLevel INT,                             
    JobRole VARCHAR(50),                         
    JobSatisfaction INT,                      
    MaritalStatus VARCHAR(10)                     
);
-- DROP TABLE HR_1;
SHOW TABLES;
desc hr_1;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/HR_1.csv' 
INTO TABLE HR_1 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

select * from hr_1;

CREATE TABLE HR_2 (
    EmployeeID INT NOT NULL,                  
    MonthlyIncome DECIMAL(10, 2),            
    MonthlyRate DECIMAL(10, 2),               
    NumCompaniesWorked INT,                  
    Over18 CHAR(1),                            
    OverTime CHAR(3),                         
    PercentSalaryHike DECIMAL(5, 2),          
    PerformanceRating INT,                    
    RelationshipSatisfaction INT,             
    StandardHours INT,                       
    StockOptionLevel INT,                     
    TotalWorkingYears INT,                    
    TrainingTimesLastYear INT,                
    WorkLifeBalance INT,                      
    YearsAtCompany INT,                      
    YearsInCurrentRole INT,               
    YearsSinceLastPromotion INT,             
    YearsWithCurrManager INT,               
    PRIMARY KEY (EmployeeID)                  
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/HR_2.csv' 
INTO TABLE HR_2 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

-- drop table hr_2;
show tables;
select * from hr_1;
select * from hr_2;

# Average Attrition rate for all Departments

select department,
concat(round(sum(case when attrition = 'yes' then 1 end) * 100.0 / COUNT(*),2),"%") as attritionrate
from hr_1
group by department
order by attritionrate;


# Average Hourly rate of Male Research Scientist
select * from hr_1;
select 
Gender,
Jobrole,
avg(hourlyrate) as Avg_Hourly_Rate
from hr_1
where Gender = 'Male'and
Jobrole = 'Research Scientist'
order by Avg_Hourly_Rate desc;

#Attrition rate Vs Monthly income stats
SELECT 
    h1.joblevel,
    AVG(h2.monthlyincome) AS avgmonthlyincome,
    -- CONCAT(ROUND(COUNT(CASE WHEN h1.attrition = 'yes' THEN 1 END) * 100.0 / COUNT(*), 2), "%") AS attritionrate,
    CASE 
        WHEN AVG(h2.monthlyincome) < 10000 THEN 'Low Salary'
        WHEN AVG(h2.monthlyincome) BETWEEN 10001 AND 20000 THEN 'Average Salary'
        WHEN AVG(h2.monthlyincome) BETWEEN 20001 AND 30000 THEN 'Medium Salary'
        WHEN AVG(h2.monthlyincome) BETWEEN 30001 AND 40000 THEN 'High Salary'
        WHEN AVG(h2.monthlyincome) BETWEEN 40001 AND 50000 THEN 'Very High Salary'
        ELSE 'Execellent Salary'
    END AS salary_bin
FROM 
    hr_1 h1
JOIN 
    hr_2 h2 ON h2.employeeid = h1.employeenumber
GROUP BY 
    h1.joblevel
ORDER BY 2;

#Average working years for each Department
select
Department,
avg(TotalWorkingYears) as avg_working_yrs 
from hr_1
join
hr_2
on hr_1.employeenumber = hr_2.employeeid
group by Department
order by 2;

#Job Role Vs Work life balance(avg,max,min,sum,count)
select jobrole,
avg(worklifebalance)
from hr_1
join
hr_2
on hr_1.employeenumber=hr_2.EmployeeID
group by jobrole
order by 2;

#Attrition rate Vs Year since last promotion relation
select 
YearsSinceLastPromotion,
concat(round(count(case when attrition = 'yes' then 1 end)/(count(*))*100,2),'%') as attrition_rate_percentage
from hr_1
join
hr_2
on hr_1.employeenumber = hr_2.employeeid
group by YearsSinceLastPromotion
order by 2;