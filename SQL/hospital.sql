-- CREATE DATABASE hemodialysisApp;
-- drop database hemodialysisApp;
-- set search_path to hemodialysisApp, public;
CREATE TYPE appointment_statuses AS ENUM ('booked', 'rejected by hospital', 'rejected by doctor','canceled','fulfilled');

-- drop tables;
drop table hospital cascade;
drop table app_user cascade;
drop table doctor cascade;
drop table appointment cascade;
drop table patient cascade;
drop table medical_record cascade;
drop table dialysis_machine cascade;

drop sequence hospital_sequence;
drop sequence doctor_sequence;
drop sequence appointment_sequence;
drop sequence patient_sequence;
drop sequence medical_record_sequence;
drop sequence dialysis_machine_sequence;


create sequence patient_sequence start with 1000000 maxvalue 1999999;
create sequence doctor_sequence start with 2000000 maxvalue 2999999;
create sequence hospital_sequence start with 3000000 maxvalue 3999999;
create sequence dialysis_machine_sequence start with 4000000 maxvalue 4999999;
create sequence medical_record_sequence start with 5000000 maxvalue 5999999;
create sequence appointment_sequence start with 6000000 maxvalue 6999999;

CREATE TABLE hospital
(
    hospital_id   int unique primary key not null default nextval('hospital_sequence'),
    hospital_name varchar(255),
    address       varchar(255),
    phone_number  varchar(255),
    email         varchar(255),
    city          varchar(255),
    area          varchar(255),
    username      varchar(64),
    password      varchar(64)
);

-- I change user -> app_user because:
-- 'user' is a reserved keyword and should be quoted

CREATE TABLE app_user
(
    user_id      int unique primary key not null,
    first_name   varchar(255),
    last_name    varchar(255),
    phone_number varchar(255),
    gender       char,
    email        varchar(255),
    user_type    char,
    username     varchar(64),
    password     varchar(64)
);

CREATE table patient
(
    patient_id int unique not null primary key,
    birthday   DATE,
    foreign key (patient_id) references app_user (user_id)
);

CREATE table doctor
(
    doctor_id   int unique not null,
    hospital_id int        not null,
    availability        bool DEFAULT true,
    foreign key (hospital_id) references hospital (hospital_id),
    foreign key (doctor_id) references app_user (user_id),
    primary key (doctor_id)
);

CREATE table dialysis_machine
(
    dialysis_machine_id int unique not null primary key default nextval('dialysis_machine_sequence'),
    hospital_id         int        not null,
    start_time          int,
    time_slot           int,
    slots_number        int,
    price               int,
    availability        bool DEFAULT true,
    foreign key (hospital_id) references hospital (hospital_id)
);

CREATE table appointment
(
    appointment_id      int unique not null primary key default nextval('appointment_sequence'),
    dialysis_machine_id int        not null,
    hospital_id         int        not null,
    patient_id          int        not null,
    doctor_id           int        not null,
    status              appointment_statuses,
    time                date,
    slot                int,
    foreign key (dialysis_machine_id) references dialysis_machine (dialysis_machine_id),
    foreign key (hospital_id) references hospital (hospital_id),
    foreign key (doctor_id) references doctor (doctor_id),
    foreign key (patient_id) references patient (patient_id)
);

CREATE table medical_record
(
    doctor_diagnose varchar(255),
    record_id       int unique not null primary key default nextval('medical_record_sequence'),
    appointment_id  int        not null,
    patient_id      int        not null,
    doctor_id       int        not null,
    foreign key (appointment_id) references appointment (appointment_id),
    foreign key (patient_id) references patient (patient_id),
    foreign key (doctor_id) references doctor (doctor_id)
);

-- INSERT INTO public.app_user (user_id, first_name, last_name, phone_number, gender, email, user_type, username, password)
-- VALUES (2000000, 'tom', 'tommy', '01020304060', 'm', 'potato@tomato.com', 'd', 'tomBlue', 'p@ss020');
--
-- INSERT INTO public.app_user (user_id, first_name, last_name, phone_number, gender, email, user_type, username, password)
-- VALUES (1000000, 'potato', 'tomato', '01020304050', 'm', 'potato@tomato.com', 'p', 'potato010', 'p@ss010');

INSERT INTO public.app_user (user_id, first_name, last_name, phone_number, gender, email, user_type, username, password)
VALUES (2000000, 'tom', 'tommy', '01020304060', 'm', 'potato@tomato.com', 'd', '0ea6e0a739c5bdea8e67685c1061f84de9f4895e790cf443861681e0f175aded', 'e4c94027fdbddef50178f9e1ffad46adc2a1275cc3dd62fcc43131195bc0e48d');

INSERT INTO public.app_user (user_id, first_name, last_name, phone_number, gender, email, user_type, username, password)
VALUES (1000000, 'potato', 'tomato', '01020304050', 'm', 'potato@tomato.com', 'p', 'b31c7dd68580fe443d114b8536a969024b6cccf9122dc4e77b6b36b96bf8b2b8', '9a1893a082c6ea59f56a2dd38b0776afd338ae0546e575720ac93b66bd4c062b');

INSERT INTO public.hospital (hospital_id, hospital_name, address, phone_number, email, city, area, username, password)
VALUES (3000000, 'jerry''s hospital', 'Giza / 6October / 1st', '01020304070', 'jerry@hospital.com', 'giza', '6-october',
        'jerry', 'jerry1234');

INSERT INTO public.doctor (doctor_id, hospital_id)
VALUES (2000000, 3000000);


INSERT INTO public.patient (birthday, patient_id)
VALUES ('2000-05-15', 1000000);

INSERT INTO public.dialysis_machine (start_time, time_slot, slots_number, price, availability, dialysis_machine_id,
                                     hospital_id)
VALUES (7, 60, 3, 320, true, 4000000, 3000000);

INSERT INTO public.appointment (status, time, slot, appointment_id, dialysis_machine_id, hospital_id, patient_id,
                                doctor_id)
VALUES ('booked', '2023-05-15', 2, 6000000, 4000000, 3000000, 1000000, 2000000);


INSERT INTO public.medical_record (doctor_diagnose, record_id, appointment_id, patient_id, doctor_id)
VALUES ('eat less potato', 5000000, 6000000, 1000000, 2000000);

SELECT m.doctor_diagnose, CONCAT(d.first_name,' ',d.last_name) AS doctor_name, a.time AS diagnosis_time, h.hospital_name FROM medical_record AS m,app_user AS d, appointment AS a, hospital AS h WHERE m.doctor_id = d.user_id AND a.appointment_id = m.appointment_id AND a.hospital_id = h.hospital_id AND m.patient_id = 1000000;

SELECT a.appointment_id, a.dialysis_machine_id, a.patient_id, a.doctor_id, a.hospital_id, a.time, a.status, a.slot, h.hospital_name, h.address, h.phone_number, h.email, h.city, h.area, d.first_name, d.last_name, d.phone_number FROM appointment a, hospital h, app_user d WHERE a.doctor_id = 2000000 and a.hospital_id = h.hospital_id and a.doctor_id = d.user_id;

SELECT a.appointment_id,a.doctor_id, a.patient_id, a.time, a.status, a.slot,concat(p.first_name,' ',p.last_name) as patient_name, pa.birthday, p.gender ,p.phone_number ,a.dialysis_machine_id,a.hospital_id FROM appointment a, app_user p ,patient pa WHERE p.user_id = a.patient_id  and a.patient_id = pa.patient_id and a.doctor_id = 2000000;

SELECT CONCAT(d.first_name, ' ', d.last_name) AS doctor_name, COUNT(a.doctor_id) AS number_of_appointments, h.hospital_name, a.status, a.time
FROM app_user AS d
INNER JOIN appointment AS a ON d.user_id = a.doctor_id
INNER JOIN hospital AS h ON a.hospital_id = h.id
GROUP BY a.doctor_id ORDER BY number_of_appointments ASC;


-- used sql in doc user and pass : test
INSERT INTO public.app_user (user_id, first_name, last_name, phone_number, gender, email, user_type, username, password)
VALUES (2000000, 'Yusuf', 'Alsayed', '01020304060', 'm', 'y.alsayed@example.com', 'd', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08');

INSERT INTO public.app_user (user_id, first_name, last_name, phone_number, gender, email, user_type, username, password)
VALUES (1000000, 'Sabry', 'Alsawah', '01020304050', 'm', 's.alsawah@example.com', 'p', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08');

INSERT INTO public.app_user (user_id, first_name, last_name, phone_number, gender, email, user_type, username, password)
VALUES (2000001, 'Manar', 'Omar', '01020304050', 'f', 'm.omar@example.com', 'd', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08');


INSERT INTO public.hospital (hospital_id, hospital_name, address, phone_number, email, city, area, username, password)
VALUES (3000000, 'Metwally''s hospital', 'Giza / 6-October / 1st', '01020304070', 'contact@metwally_hospital.com', 'giza', '6-october',
        '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08');
       
INSERT INTO public.hospital (hospital_id, hospital_name, address, phone_number, email, city, area, username, password)
VALUES (3000001, 'Moustafa''s hospital', 'Cairo / Nasr City / 1st', '01020304070', 'contact@moustafa_hospital.com', 'cairo', 'Nasr City',
        '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08', '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08');
        
INSERT INTO public.doctor (doctor_id, hospital_id)
VALUES (2000000, 3000000);

INSERT INTO public.doctor (doctor_id, hospital_id)
VALUES (2000001, 3000000);

INSERT INTO public.patient (birthday, patient_id)
VALUES ('2000-05-15', 1000000);

INSERT INTO public.dialysis_machine (start_time, time_slot, slots_number, price, availability, dialysis_machine_id,
                                     hospital_id)
VALUES (7, 60, 3, 320, true, 4000000, 3000000);