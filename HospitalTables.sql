
-- create and select the database
DROP DATABASE IF EXISTS hospital_1;
CREATE DATABASE hospital_1;
USE hospital_1;

-- create the tables for the database
CREATE TABLE employee (
    employeeID	 INT  	     AUTO_INCREMENT  PRIMARY KEY,
    SSN 		 INT(9)  	 NOT NULL,
    first_name   VARCHAR(60) NOT NULL,
	last_name   VARCHAR(60) NOT NULL,
	employee_type VARCHAR(20) NOT NULL,
	UNIQUE INDEX employee (SSN)
);

CREATE TABLE physician (
    employeeID   INT NOT NULL,
    specialization varchar(255) default null,
    primary key (employeeID),
    foreign key (employeeID) references employee (employeeID)
);

CREATE TABLE nurse (
    employeeID INT NOT NULL,
    registered BOOLEAN NOT NULL,
    primary key (employeeID),
    foreign key (employeeID) references employee (employeeID)
);

CREATE TABLE room (
	roomID			 INT AUTO_INCREMENT PRIMARY KEY,
    room_number		 INT NOT NULL,
    room_type	     VARCHAR(60) DEFAULT NULL,
    buildingFloor 	 INT NOT NULL,
    buildingCode	 INT NOT NULL,
    available		 BOOLEAN NOT NULL
);

CREATE TABLE patient (
    patientID 		INT AUTO_INCREMENT PRIMARY KEY,
    patient_name    VARCHAR(60) NOT NULL,
    address		    varchar(100) DEFAULT NULL,
    phone 			varchar(15) DEFAULT NULL,
    insuranceID	    INT DEFAULT NULL,
	UNIQUE INDEX patient (insuranceID)
);

CREATE TABLE stay (
    stayID		 INT AUTO_INCREMENT PRIMARY KEY,
    roomID	     INT NOT NULL,
    stay_start 	 DATETIME NOT NULL,
    stay_end 	 DATETIME DEFAULT NULL,
	foreign key (roomID) references room (roomID)
);

CREATE TABLE procedures (
    procedureCode   INT AUTO_INCREMENT PRIMARY KEY,
    patientID  	    INT NOT NULL,
    stayID		    INT NOT NULL,
    procedure_date  DATETIME NOT NULL,
    physicianID     INT NOT NULL,
    nurseID	  	    INT NOT NULL,
	foreign key (patientID) references patient (patientID),
	foreign key (stayID) references stay (stayID),
	foreign key (physicianID) references employee (employeeID),
	foreign key (nurseID) references employee (employeeID)
);

create table medication (
	medicationID INT auto_increment primary key,
    medication_name varchar(255),
    brand			varchar(255),
    med_desciption	varchar(255)
);

CREATE TABLE appointment (
    appointmentID 	INT AUTO_INCREMENT PRIMARY KEY,
    patientID 		INT not null,
    nurseID 		INT not null,
    physicianID	    INT not null,
    start_date		DATETIME NOT NULL,
    end_date 		DATETIME NOT NULL,
    examinationroom INT,
    foreign key (patientID) references patient (patientID),
	foreign key (nurseID) references employee (employeeID),
    foreign key (physicianID) references employee (employeeID)
);
    
create table prescription (
	prescriptionID INT auto_increment primary key,
    physicianID		int not null,
    patientID		int not null,
    medicationID	int not null,
    dose			varchar(255),
    foreign key (physicianID) references employee (employeeID),
    foreign key (patientID) references patient (patientID),
    foreign key (medicationID) references medication (medicationID)
);

-- insert data into tables
insert INTO employee (SSN, first_name, last_name, employee_type) VALUES
(254387947, 'Kim', 'Jones', 'physician'),
(876436894, 'Jim', 'Smith', 'nurse'),
(789346758, 'John', 'Clease', 'physician'),
(583799774, 'Edward', 'Van Halen', 'nurse');

insert into physician values
((SELECT employeeID FROM employee WHERE SSN = 254387947),'General'),
((SELECT employeeID FROM employee WHERE SSN = 789346758),'Cardiologist');

insert into nurse values
((SELECT employeeID FROM employee WHERE SSN = 876436894),true),
((SELECT employeeID FROM employee WHERE SSN = 583799774),false);

insert into patient (patient_name, address, phone, insuranceID) values
('John', '12345 Poly St. Pomona CA 92345', 6266324715, 1234),
('Steven', '12346 University St. Pomona CA 92345', 9093673647, 8756),
('Joe', '12346 University St. Pomona CA 92345', 6268473654, 8546),
('Jerry', '12347 CPP St. Pomona CA 92345', 9093279413, 87563);

insert into room (room_number, room_type, buildingFloor, buildingCode, available) values
(1, 'normal', 1, 1, 0),
(2, 'normal', 1, 1, 1),
(3, 'normal', 1, 1, 0),
(4, 'normal', 1, 1, 1);

insert into stay (roomID, stay_start, stay_end) values
((SELECT roomID FROM room WHERE room_number = 1), '2018-12-3 09:40', null),
((SELECT roomID FROM room WHERE room_number = 2), '2018-12-6 07:45', null),
((SELECT roomID FROM room WHERE room_number = 3), '2018-12-7 09:40', null),
((SELECT roomID FROM room WHERE room_number = 4), '2018-12-8 09:40', null);

insert into procedures (patientID, stayID, procedure_date, physicianID, nurseID) values
((SELECT patientID FROM patient WHERE insuranceID = 1234),
 (SELECT stayID FROM stay WHERE roomID = (SELECT roomID FROM room WHERE room_number = 1) AND stay_start = '2018-12-3 09:40'),
 '2018-12-06 08:00',
 (SELECT employeeID FROM employee WHERE SSN = 254387947),
 (SELECT employeeID FROM employee WHERE SSN = 876436894)),
((SELECT patientID FROM patient WHERE insuranceID = 8756),
 (SELECT stayID FROM stay WHERE roomID = (SELECT roomID FROM room WHERE room_number = 2) AND stay_start = '2018-12-6 07:45'),
 '2018-12-06 08:00',
 (SELECT employeeID FROM employee WHERE SSN = 789346758),
 (SELECT employeeID FROM employee WHERE SSN = 583799774));
 
 insert into medication (medication_name,brand,med_desciption) values
 ('abacavir sulfate','drug brand a','does something for headches'),
 ('sermorelin acetate','drug brand b','blood pressure'),
 ('entacapone','drug brand c','chronic pain'),
 ('kayexalate','drug brand d','sleep aid');
 
 insert into appointment(patientID,nurseID,physicianID,start_date,end_date,examinationroom) values
 ((SELECT patientID FROM patient WHERE insuranceID = 1234),(SELECT employeeID FROM employee WHERE SSN = 583799774),
 (SELECT employeeID FROM employee WHERE SSN = 789346758),'2018-12-3 09:40','2018-12-3 09:40',5),
 ((SELECT patientID FROM patient WHERE insuranceID = 8756),(SELECT employeeID FROM employee WHERE SSN = 583799774),
 (SELECT employeeID FROM employee WHERE SSN = 254387947),'2018-12-3 09:40','2018-12-3 09:40',5),
 ((SELECT patientID FROM patient WHERE insuranceID = 8546),(SELECT employeeID FROM employee WHERE SSN = 876436894),
 (SELECT employeeID FROM employee WHERE SSN = 789346758),'2018-12-3 09:40','2018-12-3 09:40',5),
 ((SELECT patientID FROM patient WHERE insuranceID = 87563),(SELECT employeeID FROM employee WHERE SSN = 876436894),
 (SELECT employeeID FROM employee WHERE SSN = 254387947),'2018-12-3 09:40','2018-12-3 09:40',5);
 
 insert into prescription(physicianID, patientID, medicationID, dose) values
 ((SELECT employeeID FROM employee WHERE SSN = 254387947),(SELECT patientID FROM patient WHERE insuranceID = 1234),
 (SELECT medicationID FROM medication WHERE medication_name ='abacavir sulfate'),'take 2 per day with food and water'),
 ((SELECT employeeID FROM employee WHERE SSN = 254387947),(SELECT patientID FROM patient WHERE insuranceID = 8756),
 (SELECT medicationID FROM medication WHERE medication_name ='sermorelin acetate'),'take 1 when about to go to sleep'),
 ((SELECT employeeID FROM employee WHERE SSN = 789346758),(SELECT patientID FROM patient WHERE insuranceID = 8546),
 (SELECT medicationID FROM medication WHERE medication_name ='entacapone'),'take whenever need'),
 ((SELECT employeeID FROM employee WHERE SSN = 789346758),(SELECT patientID FROM patient WHERE insuranceID = 87563),
 (SELECT medicationID FROM medication WHERE medication_name ='kayexalate'),'take as needed');