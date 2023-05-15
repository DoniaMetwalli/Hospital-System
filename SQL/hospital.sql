-- CREATE DATABASE hemodialysisApp;
-- drop database hemodialysisApp;
-- set search_path to hemodialysisApp, public;

-- drop tables;
drop table hospital cascade;
drop table app_user cascade;
drop table doctor cascade;
drop table appointment cascade;
drop table patient cascade;
drop table medical_record cascade;
drop table dialysis_machine cascade;

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
    birthday   DATE,
    patient_id int unique not null primary key,
    foreign key (patient_id) references app_user (user_id)
);

CREATE table doctor
(
    doctor_id   int unique not null,
    hospital_id int unique not null,
    foreign key (hospital_id) references hospital (hospital_id),
    foreign key (doctor_id) references app_user (user_id),
    primary key (doctor_id)
);

CREATE table dialysis_machine
(
    start_time          int,
    time_slot           int,
    price               int,
    availability        bool,
    dialysis_machine_id int unique not null primary key default nextval('dialysis_machine_sequence'),
    hospital_id         int unique not null,
    foreign key (hospital_id) references hospital (hospital_id)
);

CREATE table appointment
(
    status              varchar(255),
    time                int,
    slot                int,
    appointment_id      int unique not null primary key default nextval('appointment_sequence'),
    dialysis_machine_id int unique not null,
    hospital_id         int unique not null,
    patient_id          int unique not null,
    doctor_id           int unique not null,
    foreign key (dialysis_machine_id) references dialysis_machine (dialysis_machine_id),
    foreign key (hospital_id) references hospital (hospital_id),
    foreign key (doctor_id) references doctor (doctor_id),
    foreign key (patient_id) references patient (patient_id)
);

CREATE table medical_record
(
    doctor_diagnose varchar(255),
    record_id       int unique not null primary key default nextval('medical_record_sequence'),
    appointment_id  int unique not null,
    patient_id      int unique not null,
    doctor_id       int unique not null,
    foreign key (appointment_id) references appointment (appointment_id),
    foreign key (patient_id) references patient (patient_id),
    foreign key (doctor_id) references doctor (doctor_id)
);