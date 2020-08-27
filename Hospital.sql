-- create and select the database
DROP DATABASE IF EXISTS hospital_1;
CREATE DATABASE hospital_1;
USE hospital_1;

-- create the tables for the database
CREATE TABLE employee (
    employeeID	 INT  	     AUTO_INCREMENT  PRIMARY KEY,
    physicianID  INT		 REFERENCES physician (physicianID),
    nurseID		 INT		 references nurse (nurseID),
    SSN 		 INT(9)  	 NOT NULL,
    first_name   VARCHAR(60) NOT NULL
);

CREATE TABLE physician (
    employeeID   INT NOT NULL REFERENCES employee (physicianID),
    physicianID  INT AUTO_INCREMENT PRIMARY KEY,
    specialization text default null
);

CREATE TABLE nurse (
    employeeID INT NOT NULL REFERENCES employee (physicianID),
    nurseID    INT AUTO_INCREMENT PRIMARY KEY,
    registered boolean not null
);

CREATE TABLE on_call (
    nurseID 	INT NOT NULL REFERENCES nurse (nurseID),
    room_number INT NOT NULL REFERENCES room (room_number),
    start 		DATETIME NOT NULL,
    end		    DATETIME NOT NULL
);

CREATE TABLE room (
    room_number		 INT AUTO_INCREMENT PRIMARY KEY,
    type	         VARCHAR(60) DEFAULT NULL,
    buildingFloor 	 INT NOT NULL,
    buildingCode	 INT NOT NULL,
    available		 BOOLEAN NOT NULL
);

CREATE TABLE procedure_table (
    procedureCode INT AUTO_INCREMENT PRIMARY KEY,
    patientID  	  INT NOT NULL,
    stayID		  INT NOT NULL,
    date		  DATETIME NOT NULL,
    physicianID   INT NOT NULL REFERENCES physician (physicianID),
    nurseID	  	  INT NOT NULL REFERENCES nurse (nurseID)
);

CREATE TABLE patient (
    patientID 		INT AUTO_INCREMENT PRIMARY KEY,
    patient_name    VARCHAR(60) NOT NULL,
    address		    varchar(100) DEFAULT NULL,
    phone 			int(11) DEFAULT NULL,
    insuranceID	    INT DEFAULT NULL,
    procedureCode   INT NOT NULL REFERENCES procedure_table (procedureCode)
);

CREATE TABLE stay (
    stayID		 INT AUTO_INCREMENT PRIMARY KEY,
    patientID	 INT NOT NULL REFERENCES patient (patientID),
    room_number	 INT NOT NULL REFERENCES room (room_number),
    start 		 DATETIME NOT NULL,
    end 		 DATETIME DEFAULT NULL
);

CREATE TABLE appointment (
    appointmentID 	INT AUTO_INCREMENT PRIMARY KEY,
    patientID 		INT NOT NULL REFERENCES patient (patientID),
    nurseID 		INT NOT NULL REFERENCES nurse (nurseID),
    physicianID	    INT NOT NULL REFERENCES physician (physicianID),
    start 			DATETIME NOT NULL,
    end 			DATETIME NOT NULL,
    examinationroom INT
);

CREATE TABLE medication (
    medication_code INT AUTO_INCREMENT PRIMARY KEY,
    name		    VARCHAR(100) NOT NULL,
    brand 			VARCHAR(100) NOT NULL,
    description	    TEXT DEFAULT NULL
);

CREATE TABLE prescription (
    physicianID		 INT NOT NULL REFERENCES physician (physicianID),
    patientID 		 INT NOT NULL REFERENCES patient (patientID),
    medication_code	 INT NOT NULL REFERENCES medication (medication_code),
    appointmentID 	 INT NOT NULL REFERENCES appointment (appointmentID),
    dose 			 INT DEFAULT NULL
);

-- insert data into tables

insert into appointment (patientID, nurseID, physicianID, start,end,examinationroom) values
(1,1,1, '1111-11-11 11:11:11', '1022-12-22 22:22:22', 1);

insert INTO employee (employeeID, physicianID, nurseID, SSN, first_name) VALUES
(1,NULL, 1, 111111111, 'nurse1'),
(2, 1, NULL, 111111112, 'doc1'),
(3, 2, NULL, 111111113, 'doc2'),
(4, 3, NULL, 111111114, 'doc3'),
(5, 4, NULL, 11111115, 'doc4'),
(6, null, 2, 111111116, 'nurse2'),
(7, null, 3, 111111117, 'nurse3'),
(8, null, 4, 111111118, 'nurse4');

insert into medication (medication_code, name,brand,description) values
(1, 'name_a', 'brand_a', 'descrition'),
(2, 'name_b', 'brand_b', 'description');

insert into nurse (employeeID, nurseID, registered) values
(1,1,1),
(6,2,1),
(7,3,0),
(8,4,0);

insert into on_call (nurseID,room_number,start,end) values
(1,1,'1111-11-11 11:11','1112-11-11 11:11');

insert into patient (patientID, patient_name, address, phone, insuranceID, procedureCode) values
(1, 'patient1', 'address1', 111111111, 1, 1 );

insert into physician (employeeID, physicianID) values
(2, 1),
(3, 2),
(4, 3),
(5, 4);

insert into prescription (physicianID, patientID, medication_code, appointmentID, dose) values
(1, 1, 1, 1, 0);

insert into procedure_table (procedureCode, patientID, stayID, date, physicianID, nurseID) values
(1, 1, 1, '1111-11-11 11:11', 1, 1);

insert into room (room_number, type, buildingFloor, buildingCode, available) values
(1, 'normal', 1, 1, 0);

insert into stay(stayID, patientID, room_number, start, end) values
(1, 1, 1, '1111-11-11 11:11', null);