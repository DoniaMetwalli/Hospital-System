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

INSERT INTO public.app_user (user_id, first_name, last_name, phone_number, gender, email, user_type, username, password)
VALUES (2000000, 'tom', 'tommy', '01020304060', 'm', 'potato@tomato.com', 'd', 'tomBlue', 'p@ss020');

INSERT INTO public.app_user (user_id, first_name, last_name, phone_number, gender, email, user_type, username, password)
VALUES (1000000, 'potato', 'tomato', '01020304050', 'm', 'potato@tomato.com', 'p', 'potato010', 'p@ss010');

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
