
-- Queries for the hospital_1 database.
-- Only run these queries one at a time.

-- List all procedures (can't include both the physician's and nurse's names)
SELECT procedures.procedure_date, patient.patient_name, patient.insuranceID, employee.first_name, employee.last_name, physician.specialization, room.room_number
FROM procedures JOIN patient ON patient.patientID = procedures.patientID
JOIN employee ON employee.employeeID = procedures.physicianID
JOIN physician ON physician.employeeID = procedures.physicianID
JOIN stay ON stay.stayID = procedures.stayID
JOIN room ON room.roomID = stay.roomID;

-- List all procedures attended by nurses (can't include the doctor).
SELECT employee.first_name as 'nurse first name', employee.last_name as 'nurse last name', procedures.procedure_date, patient.patient_name as 'patient', patient.insuranceID, nurse.registered, room.room_number
FROM procedures JOIN patient ON patient.patientID = procedures.patientID
JOIN employee ON employee.employeeID = procedures.nurseID
JOIN nurse ON nurse.employeeID = procedures.nurseID
JOIN stay ON stay.stayID = procedures.stayID
JOIN room ON room.roomID = stay.roomID;

-- List all appointments attended by physician
select patient.patient_name as 'patient name', employee.first_name as 'doctor first name', employee.last_name as 'doctor last name', appointment.start_date, appointment.end_date
from appointment
join employee on employee.employeeID = appointment.physicianID
join patient on patient.patientID = appointment.patientID;

-- List all prescription with physicians, patients, medication name, with the dosage
select patient.patient_name as 'patient name', employee.first_name as 'doctor first name', employee.last_name as 'doctor last name', medication.medication_name, medication.brand, prescription.dose
from prescription 
join medication on medication.medicationID = prescription.prescriptionID
join patient on patient.patientID = prescription.patientID
join employee on employee.employeeID = prescription.physicianID;

-- list all the nurse and their name
select employee.first_name, employee.last_name, nurse.registered
from nurse
join employee on employee.employeeID = nurse.employeeID;

-- list all the physician name and when is their specialization
select employee.first_name, employee.last_name, physician.specialization
from physician
join employee on employee.employeeID = physician.employeeID;