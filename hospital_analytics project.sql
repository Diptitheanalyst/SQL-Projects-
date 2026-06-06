SELECT * FROM hospital_db.encounters;


SELECT DISTINCT encounterclass
FROM encounters;

SELECT DISTINCT 
COUNT(id) as total_encoutner,
encounterclass
FROM encounters
GROUP BY encounterclass
ORDER BY count(id) DESC;


#. How many total encounters occurred each year?
SELECT * from encounters;
SELECT YEAR(START) as Year,
 COUNT(id)as total_encoutner
FROM encounters
GROUP BY YEAR(START)
ORDER BY COUNT(id) DESC;

#For each year, what percentage of all encounters belonged to each encounter class
SELECT YEAR(START) as Year,
encounterclass,
 COUNT(id)as total_encoutner
FROM encounters
GROUP BY YEAR(START), encounterclass
ORDER BY YEAR(START) DESC;

SELECT YEAR(START) as Year,
encounterclass,
count(id) as total_encounter
FROM encounters
WHERE YEAR(start)='2022'
GROUP BY YEAR(START), encounterclass
;
SELECT YEAR(start) as Year,
encounterclass,
count(id) as total_encounter,
SUM(count(id)) OVER() as Yearly_total,  # use SUM () OVER() to see the numbers in each row - it will not give me just one number like SUM 
ROUND(count(id)/SUM(count(id)) OVER()*100,2) as percentage
FROM encounters
WHERE YEAR(start)='2022'
GROUP BY YEAR(START), encounterclass
;

SELECT YEAR(start) as Year,
encounterclass,
count(id) as total_encounter,
SUM(count(id)) OVER(PARTITION BY YEAR (start)) as Yearly_total,
ROUND(count(id)/SUM(count(id)) OVER(PARTITION BY YEAR (start))*100,2) as percentage #using Partiion by year give us result for each line 
FROM encounters
GROUP BY YEAR(START), encounterclass
ORDER BY YEAR, percentage DESC
;


-- c. What percentage of encounters were over 24 hours versus under 24 hours?
WITH duration as 
(Select id,
		CASE WHEN TIMESTAMPDIFF(HOUR,START,STOP)>=24 
        THEN 'Over 24 hrs' ELSE 'UNDER 24 hrs'
END AS duration_category  
from encounters)
SELECT 
count(id) as total_encounter,
duration_category,
ROUND(count(id)/SUM(count(id)) OVER()*100,2) as percentage # USE over() when you want grand total for evertything and USE Partition by when you want seperate totals per group 
FROM duration
GROUP BY duration_category;

# OBJECTIVE 2: COST & COVERAGE INSIGHTS
-- a. How many encounters had zero payer coverage, and what percentage of total encounters does this represent?
SELECT count(id)  as zero_payer_coverage
FROM encounters
WHERE PAYER_COVERAGE=0;
WITH zero_payer AS
(SELECT count(id)  as zero_payer_coverage,
(SELECT count(id) FROM encounters) as total_encounters
FROM encounters 
WHERE PAYER_COVERAGE=0)

SELECT 
total_encounters,
zero_payer_coverage,
ROUND(zero_payer_coverage/total_encounters*100,2) as percentage
FROM zero_payer;

-- b. What are the top 10 most frequent procedures performed and the average base cost for each?
SELECT 
description as procedure_description,
count(code) as total_procedures, 
ROUND(AVG(Base_cost),2) as avg_base_cost 
FROM procedures
GROUP BY description
ORDER BY total_procedures DESC
LIMIT 10;

#c. What are the top 10 procedures with the highest average base cost and the number of times they were performed?
SELECT 
description as procedure_description,
count(code) as total_procedures, 
ROUND(AVG(Base_cost),2) as avg_base_cost 
FROM procedures
GROUP BY description  # never use aggregation in Group by because group by perform before aggreggation --> get data-->Group by-->agreegate-->sort data 
ORDER BY avg_base_cost DESC
LIMIT 10;

-- d. What is the average total claim cost for encounters, broken down by payer?
SELECT * FROM hospital_db.encounters;
SELECT 
p.name as Payer_Name,
ROUND(AVG(total_claim_cost),2) as Avg_Claim_Cost 
FROM encounters e
LEFT JOIN payers p ON e.payer=p.Id  #Using left join will give us all encounters even if any payer is NULL 
GROUP by p.name
ORDER BY avg_claim_cost DESC;

-- OBJECTIVE 3: PATIENT BEHAVIOR ANALYSIS

-- a. How many unique patients were admitted each quarter over time?

SELECT 
YEAR(START),
quarter(START),
COUNT(DISTINCT patient) as Unique_patients
FROM encounters
GROUP BY YEAR(START),
quarter(START);


-- b. How many patients were readmitted within 30 days of a previous encounter?
WITH readmission as 
(SELECT patient,
STOP,
LEAD(START) OVER (PARTITION BY patient ORDER BY START) as NEXT_START   #LEAD will give us next line data where LAG() will give us previous row data 
FROM encounters)  # ORDER BY START will pick  earliest to latest date--> rearrange for Lead

SELECT 
COUNT(DISTINCT patient) as readmitted_patients
FROM readmission
WHERE TIMESTAMPDIFF(Day,STOP, NEXT_START)<30;   #TIMESTAMPDIFF formula is (Unit, Earlier date, later date)

#--C. Which patients had the most readmissions?
WITH readmission AS 
(SELECT 
    e.patient,
    e.STOP,
    p.PREFIX,
    p.FIRST,
    p.LAST,
    LEAD(START) OVER(PARTITION BY e.patient ORDER BY e.START) AS next_start  
FROM encounters e
LEFT JOIN patients p ON e.patient = p.id)

SELECT 
    patient,
    PREFIX,
    FIRST,
    LAST,
    COUNT(*) AS total_readmissions
FROM readmission
WHERE TIMESTAMPDIFF(DAY, STOP, next_start) < 30
GROUP BY patient, PREFIX, FIRST, LAST
ORDER BY total_readmissions DESC
LIMIT 10;




