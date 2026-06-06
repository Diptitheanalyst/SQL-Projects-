# 🏥 Hospital Analytics Project - SQL

## 👋 About This Project
This is my first documented SQL project on GitHub.
I used this real-world healthcare dataset to 
practice and apply SQL skills. Through this project
I moved beyond basic queries and started thinking
analytically about data problems.

---
## 📊 About the Dataset
A synthetic healthcare dataset containing hospital 
records across 4 main tables:

| Table | Description | Rows |
|-------|-------------|------|
| `encounters` | Patient hospital visits and claims | 27,953 |
| `patients` | Patient demographic information | 973 |
| `payers` | Insurance payer details | 10 |
| `procedures` | Medical procedures performed | 514 |

The dataset covers hospital records from 
**2011 to 2022** across multiple encounter 
classes including ambulatory, outpatient, 
inpatient, wellness, urgentcare and emergency.

---

## 🎯 Project Objectives

This project is divided into 3 main objectives:

**Objective 1 — Encounters Overview**
Understanding how many encounters happened, 
broken down by year, encounter class, and duration.

**Objective 2 — Cost & Coverage Insights**
Analysing payer coverage, procedure costs, 
and claim costs across different payers.

**Objective 3 — Patient Behavior Analysis**
Understanding patient admission patterns, 
readmissions, and identifying high-risk patients.

---

## 🛠️ Tools Used
- MySQL Workbench 8.0
- MySQL 8.0
- GitHub

---

## 💡 ## 💡 Key Discoveries While Practicing

These are things I figured out while actually 
writing queries on real data:

**1. SUM() vs SUM() OVER()**
> `SUM()` gives just one number and collapses all rows.
> `SUM() OVER()` shows the total on every single row 
> so you can still see all the detail.

**2. OVER() vs PARTITION BY**
> Use `OVER()` when you want the grand total 
> for everything.
> Use `PARTITION BY` when you want separate 
> totals per group (e.g. per year, per category).

**3. Never use aggregation in GROUP BY**
> GROUP BY runs before aggregation so it does 
> not know what AVG() or COUNT() is yet.
> SQL execution order is:
> GET DATA → GROUP BY → AGGREGATE → SORT

**4. LEFT JOIN vs INNER JOIN**
> LEFT JOIN keeps all rows from the left table 
> even if there is no matching record in the 
> right table (NULL values are kept).
> INNER JOIN would drop those rows completely.

**5. LEAD() vs LAG()**
> `LEAD()` gives the value from the NEXT row.
> `LAG()` gives the value from the PREVIOUS row.
> Both are used to compare rows within the 
> same patient's visit history.

**6. ORDER BY inside OVER()**
> `ORDER BY START` inside `OVER()` arranges dates 
> from earliest to latest so LEAD/LAG reads 
> rows in the correct sequence.
> This is completely different from ORDER BY 
> at the end of a query which just sorts 
> your final results for display.

**7. TIMESTAMPDIFF formula**
> Always: `TIMESTAMPDIFF(Unit, Earlier date, Later date)`
> Getting the order wrong gives negative numbers!

---

## 📄 Files
- `hospital_analytics.sql` — all SQL queries
- `README.md` — project documentation

---

*This project was completed as part of my SQL 
practice journey. All data is synthetic 
healthcare data.*
