select * from new_schema.diabetes_prediction;

#Retrieve the Patient_id and ages of all patients

alter table new_schema.diabetes_prediction
add column age int;

set sql_safe_updates=0;

UPDATE new_schema.diabetes_prediction
SET age = TIMESTAMPDIFF(YEAR, STR_TO_DATE(`D.O.B`, '%d-%m-%Y'), CURDATE());

#Select all female patients who are older than 30.

select Patient_id,age from new_schema.diabetes_prediction;
select Patient_id,age from new_schema.diabetes_prediction where gender='Female'and age>30;

#Calculate the average BMI of patients.

select avg(BMI) from new_schema.diabetes_prediction;

#List patients in descending order of blood glucose levels

select EmployeeName,blood_glucose_level from new_schema.diabetes_prediction
order by blood_glucose_level desc;

#Find patients who have hypertension and diabetes.

select EmployeeName as PatientName from new_schema.diabetes_prediction where hypertension=1 and diabetes=1;

#Determine the number of patients with heart disease

select count(*) as patient_with_heart_disease from new_schema.diabetes_prediction where heart_disease=1;

#Group patients by smoking history and count how many smokers and nonsmokers there are.

SELECT smoking_history,
    COUNT(CASE WHEN smoking_history = 'current' THEN 1 ELSE NULL END) AS smokers,
    COUNT(CASE WHEN smoking_history != 'current' THEN 1 ELSE NULL END) AS non_smokers
FROM diabetes_prediction GROUP BY smoking_history;

#Retrieve the Patient_id of patients who have a BMI greater than the average BMI

select Patient_id 
from new_schema.diabetes_prediction 
where bmi>(select avg(bmi) from new_schema.diabetes_prediction);


#Find the patient with the highest HbA1c level and the patient with the lowest HbA1clevel.

SELECT Patient_id, HbA1c_level
FROM new_schema.diabetes_prediction
WHERE HbA1c_level = (SELECT MAX(HbA1c_level) FROM new_schema.diabetes_prediction)
union all
SELECT Patient_id, HbA1c_level
FROM diabetes_prediction
WHERE HbA1c_level = (SELECT MIN(HbA1c_level) FROM new_schema.diabetes_prediction);

#Calculate the age of patients in years (assuming the current date as of now).

SELECT Patient_id, `D.O.B`,
       TIMESTAMPDIFF(YEAR, STR_TO_DATE(`D.O.B`, '%d-%m-%Y'), CURDATE()) AS age
FROM new_schema.diabetes_prediction
LIMIT 0, 100000;

#Rank patients by blood glucose level within each gender group

SELECT patient_id,gender,blood_glucose_level,
    RANK() OVER (PARTITION BY gender ORDER BY blood_glucose_level DESC) AS rank_within_gender
FROM new_schema.diabetes_prediction;

#Update the smoking history of patients who are older than 40 to "Ex-smoker."

set sql_safe_updates=0;
update new_schema.diabetes_prediction set smoking_history="Ex-smoker" where age>40;
select age,smoking_history from new_schema.diabetes_prediction where age>40;

#Insert a new patient into the database with sample data.

Insert into diabetes_prediction values ("Shreyas", "PT100101", "Male","1995-02-06", 0, 1, "never", 22.15, 6.1, 150, 0,23);
Select * from diabetes_prediction where Patient_id = "PT100101";

#Delete all patients with heart disease from the database.

Delete from new_schema.diabetes_prediction where heart_disease =1 ;
select * from new_schema.diabetes_prediction where heart_disease =1;

#Find patients who have hypertension but not diabetes using the EXCEPT operator.

#EXCEPT is supported in SQL Server and PostgreSQL, not in MySQL.

SELECT p1.Patient_id, p1.hypertension, p1.diabetes
FROM new_schema.diabetes_prediction p1
LEFT JOIN new_schema.diabetes_prediction p2 
    ON p1.Patient_id = p2.Patient_id AND p2.diabetes = 1
WHERE p1.hypertension = 1
  AND p2.Patient_id IS NULL
LIMIT 1000;

#Define a unique constraint on the "patient_id" column to ensure its values are unique.

Alter table new_schema.diabetes_prediction add constraint patient_id UNIQUE(Patient_id);
describe new_schema.diabetes_prediction;

#Create a view that displays the Patient_ids, ages, and BMI of patients.

CREATE VIEW new_view as Select Patient_id, age, bmi from diabetes_prediction;
Select * from new_view;




























