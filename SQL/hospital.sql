CREATE DATABASE hemodialysisApp;
USE hemodialysisApp;

CREATE TABLE hospital (
    hospital_id BIGINT UNSIGNED unique primary key not null,
    email varchar(255),
    phone_number varchar(255),
    city varchar(255),
    state varchar(255),
    address varchar(255)
);

CREATE TABLE user (
    user_id BIGINT UNSIGNED unique primary key not null,
    first_name varchar(255),
    last_name varchar(255),
    phone_number varchar(255),
    email varchar(255),
    user_type char
);

CREATE table patient (
    birthday DATE,
    gender char,
    patient_id bigint unsigned unique not null,
    foreign key (patient_id) references user (user_id),
    primary key (patient_id)
);
CREATE table doctor (
    birthday DATE,
    gender char,
    doctor_id bigint unsigned unique not null,
    hospital_id bigint unsigned unique not null,
    foreign key (hospital_id) references hospital (hospital_id),
    foreign key (doctor_id) references user (user_id),
    primary key (doctor_id)
);

CREATE table dialysis_machine (
    price int,
    availability bool,
    dialysis_machine_id bigint unsigned unique not null primary key,
    hospital_id bigint unsigned unique not null,
    foreign key (hospital_id) references hospital (hospital_id)
);

CREATE table medical_record (
    doctor_diagnose varchar(255),
    record_id bigint unsigned unique not null primary key,
    appointment_id bigint unsigned unique not null,
    patient_id bigint unsigned unique not null,
    doctor_id bigint unsigned unique not null,
    foreign key (appointment_id) references appointment(appointment_id)
    foreign key (patient_id) references patient(patient_id)
    foreign key (doctor_id) references doctor(doctor_id)

);

CREATE table appointment (
    status varchar(255),
    time DATETIME,
    appointment_id bigint unsigned unique not null primary key,
    record_id bigint unsigned unique not null primary key,
    dialysis_machine_id bigint unsigned unique not null,
    hospital_id bigint unsigned unique not null,
    patient_id bigint unsigned unique not null,
    doctor_id bigint unsigned unique not null,
    foreign key (dialysis_machine_id) references dialysis_machine(dialysis_machine_id),
    foreign key (hospital_id) references hospital(hospital_id),
    foreign key (doctor_id) references doctor(doctor_id),
    foreign key (patient_id) references patient(patient_id)
);