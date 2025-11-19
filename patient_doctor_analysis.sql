create table patient ( patient_id int ,name varchar(50),age int,gender varchar (40),disease varchar (50),admit_date Date,discharge_date date,bill_amount Decimal(10,2));
INSERT INTO patient 
(patient_id, name, age, gender, disease, admit_date, discharge_date, bill_amount)
VALUES
(1, 'Arun Kumar', 32, 'Male', 'Fever', '2024-01-05', '2024-01-08', 3500.00),
(2, 'Priya Shah', 27, 'Female', 'Asthma', '2024-02-11', '2024-02-15', 8200.00),
(3, 'Rahul Singh', 45, 'Male', 'Diabetes', '2024-03-20', '2024-03-28', 15000.00),
(4, 'Meena R', 60, 'Female', 'Heart Disease', '2024-04-02', '2024-04-20', 42000.00),
(5, 'Vijay Kumar', 50, 'Male', 'Fracture', '2024-05-10', '2024-05-25', 23000.00),
(6, 'Anitha M', 36, 'Female', 'Migraine', '2024-06-01', '2024-06-03', 2500.00),
(7, 'Karthik R', 29, 'Male', 'Dengue', '2024-06-18', '2024-06-25', 18000.00),
(8, 'Sangeetha', 40, 'Female', 'Thyroid', '2024-07-12', '2024-07-19', 9000.00),
(9, 'Mahesh', 55, 'Male', 'Kidney Stone', '2024-08-03', '2024-08-10', 12000.00),
(10, 'Divya', 22, 'Female', 'Allergy', '2024-09-01', '2024-09-03', 1800.00);

select * from patient;

select name, gender from patient group by gender;

#the total bill amount of  each male 
select name,sum(bill_amount) from  patient where gender = "Male"group by name;

#the patient who have fever 
select name from patient where disease ="Fever" group by name ;

#patients who stayed more than 5 days
select * from patient where datediff(discharge_date,admit_date)>5;

 #patients who stayed less than 5 days
 select * from patient where datediff(discharge_date,admit_date)<5;
 
 SELECT name, disease
FROM patient
WHERE bill_amount BETWEEN 5000 AND 20000;

SELECT patient_id, name, age
FROM patients
WHERE gender <> 'Male';

#Names of patients with the maximum bill amount

SELECT name
FROM patient
WHERE bill_amount = (
    SELECT MAX(bill_amount)
    FROM patient
);

#top5 most expensive patients bill

select  * from patient order by bill_amount desc limit 5;

# who are the youngest patients 
select * from patient  where age < 30 order by age asc ;
#names in order 
select * from patient order by name asc ;

#fetching the second highest bill 

SELECT DISTINCT bill_amount
FROM patient
ORDER BY bill_amount DESC
LIMIT 1 OFFSET 1;

#the number of patients in each disease where age > 30

select disease , count(*) as total_number from patient where age <30 group by disease ;

#diseases that have more than 2 patients.

select disease ,count(*) as total_patients from patient group by disease having count(*)>2;

#male patients per disease, but show only diseases with more than 1 male patient
select disease,count(*) as total from patient where gender="Male" group by disease having count(*)>1;

 #diseases that have both male and female patients.
SELECT disease FROM patient GROUP BY disease HAVING COUNT(DISTINCT gender) = 2;

ALTER TABLE patient ADD COLUMN doctor_id INT;
CREATE TABLE doctor (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(50),
    specialization VARCHAR(50),
    experience INT
);

INSERT INTO doctor VALUES
(1, 'Dr. Kumar', 'Cardiology', 12),
(2, 'Dr. Riya', 'General Medicine', 7),
(3, 'Dr. Arjun', 'Orthopedics', 10),
(4, 'Dr. Sneha', 'Dermatology', 5);

SET SQL_SAFE_UPDATES = 0;

UPDATE patient SET doctor_id = 1 WHERE patient_id IN (1, 2);
UPDATE patient SET doctor_id = 2 WHERE patient_id IN (3, 4);
UPDATE patient SET doctor_id = 3 WHERE patient_id IN (5, 6);
UPDATE patient SET doctor_id = 4 WHERE patient_id IN (7, 8);



SELECT p.name AS patient_name,
       d.doctor_name
FROM patient p
INNER JOIN doctor d
ON p.doctor_id = d.doctor_id;

#show each patient’s name, disease, bill amount, and the doctor who treated them.

SELECT p.name,
       p.disease,
       p.bill_amount,
       d.doctor_name
FROM patient p
INNER JOIN doctor d
ON p.doctor_id = d.doctor_id;

#fetch patient name, doctor name, and specialization for all patients treated by doctors with more than 5 years experience.

SELECT p.name,
       d.doctor_name,
       d.specialization
FROM patient p
INNER JOIN doctor d
ON p.doctor_id = d.doctor_id
WHERE d.experience > 5;

#Show all patients and the doctor treating them (even if no doctor assigned).

SELECT p.name AS patient_name,
       d.doctor_name
FROM patient p
LEFT JOIN doctor d
ON p.doctor_id = d.doctor_id;

#how all male patients and their doctor name.
#Even if male patient has no doctor, show them.**

SELECT p.name AS patient_name,
       d.doctor_name
FROM patient p
LEFT JOIN doctor d
ON p.doctor_id = d.doctor_id
WHERE p.gender = 'Male';

#Fetch details of patients who do NOT have a doctor assigned.

select p.name as patient_name,d.doctor_name from patient p left join doctor d on p.doctor_id = d.doctor_id where d.doctor_name is null; 

#Show each doctor and how many patients they have.
#Include doctors with zero patients

SELECT d.doctor_name,
       COUNT(p.patient_id) AS total_patients
FROM patient p
RIGHT JOIN doctor d
ON p.doctor_id = d.doctor_id
GROUP BY d.doctor_name;

#Show all cardiology doctors + their patients (even if no patients)

SELECT d.doctor_name,
       p.name AS patient_name
FROM patient p
RIGHT JOIN doctor d
ON p.doctor_id = d.doctor_id
WHERE d.specialization = 'Cardiology';


#Show all patients and doctors where the doctor specialization is 'Cardiology'.

SELECT p.name AS patient_name, d.doctor_name, d.specialization
FROM patient p
LEFT JOIN doctor d ON p.doctor_id = d.doctor_id
WHERE d.specialization = 'Cardiology'
UNION
SELECT p.name AS patient_name, d.doctor_name, d.specialization
FROM patient p
RIGHT JOIN doctor d ON p.doctor_id = d.doctor_id
WHERE d.specialization = 'Cardiology';

#Show all patients who don’t have a doctor AND all doctors who don’t have patients.

SELECT p.name AS patient_name, d.doctor_name
FROM patient p
LEFT JOIN doctor d ON p.doctor_id = d.doctor_id
WHERE d.doctor_id IS NULL

UNION

SELECT p.name AS patient_name, d.doctor_name
FROM patient p
RIGHT JOIN doctor d ON p.doctor_id = d.doctor_id
WHERE p.doctor_id IS NULL;

#Get the patient whose age is equal to the maximum age.

SELECT name 
FROM patient 
WHERE age = (SELECT MAX(age) FROM patient);

#to find the patient(s) admitted on the earliest admit_date:

SELECT *
FROM Patients
WHERE admit_date = (
    SELECT MIN(admit_date)
    FROM Patients
);

SELECT 
    name,
    bill_amount,
    row_number() OVER (ORDER BY bill_amount DESC) AS row_num
FROM patient;

select name,disease,bill_amount,avg(bill_amount) OVER (partition by disease)as avg_value from patient;


DELETE p
FROM patient p
JOIN (
    SELECT 
        patient_id,
        ROW_NUMBER() OVER (PARTITION BY name ORDER BY patient_id) AS rn
    FROM patient
) x ON p.patient_id = x.patient_id
WHERE x.rn > 1;



SET SQL_SAFE_UPDATES = 0;

SELECT 
    name,
    disease,
    bill_amount,
    RANK() OVER (ORDER BY bill_amount DESC) AS bill_rank
FROM patient;

SELECT *
FROM (
    SELECT 
        name,
        bill_amount,
        DENSE_RANK() OVER (ORDER BY bill_amount DESC) AS rnk
    FROM patient
) x
WHERE x.rnk <= 3;

SELECT 
    name,
    bill_amount,
    LAG(bill_amount) OVER (ORDER BY patient_id) AS previous_bill
FROM patient;

SELECT 
    name,
    bill_amount,
    LEAD(bill_amount) OVER (ORDER BY patient_id) AS next_bill
FROM patient;

SELECT 
    name,
    disease,
    admit_date,
    FIRST_VALUE(name) OVER (PARTITION BY disease ORDER BY admit_date) AS first_patient
FROM patient;


SELECT 
    name,
    disease,
    admit_date,
    LAST_VALUE(name) OVER (
        PARTITION BY disease 
        ORDER BY admit_date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS latest_patient
FROM patient;

SELECT 
    p.name,
    d.doctor_name,
    COUNT(*) OVER (PARTITION BY p.doctor_id) AS total_patients_under_doctor
FROM patient p
JOIN doctor d ON p.doctor_id = d.doctor_id;






