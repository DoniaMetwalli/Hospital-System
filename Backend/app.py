from fastapi import FastAPI,  Depends, HTTPException
from fastapi.responses import FileResponse
from fastapi import HTTPException, Request
from pydantic import BaseModel
import psycopg2

app = FastAPI()

dbInfo = {"database":"postgres",  
          "host":"db.cfzgdevqdufdyilypaha.supabase.co",
          "user":"postgres",
          "password":"u=fH]Cu&)2u4^hS",
          "port":"5432"}

@app.get("/")
async def root():
    return {"message": "Welcome to Potato API"}

@app.get("/health")
async def health():
    return {"message": "OK"}


class LoginInfo(BaseModel):
    hashedUsername: str
    hashedPassword: str
    class Config:
        schema_extra = {
            "example": {
                "hashedUsername": "16f78a7d6317f102bbd95fc9a4f3ff2e3249287690b8bdad6b7810f82b34ace3",
                "hashedPassword": "5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8"
            }
        }

class Hospital(BaseModel):
    id: int
    name: str
    address: str
    phone_number: str
    email: str
    city: str
    area: str
    class Config:
        schema_extra = {
            "example": {
                "hospital_id": 1,
                "hospital_name": "Hospital A",
                "address": "1234 Main St",
                "phone_number": "1234567890",
                "email": "",
                "city": "City A",
                "area": "Area A"
            }
        }

class PatientInfo(BaseModel):
    user_id: int
    firstName: str
    lastName: str
    email: str
    phone_number: str
    birthdate: str
    gender: str
    class Config:
        schema_extra = {
            "example": {
                "user_id": 1,
                "firstName": "John",
                "lastName": "Doe",
                "email": "",
                "phone_number": "",
                "birthdate": "1999-01-01",
                "gender" : "M"
            }
        }

class DoctorInfo(BaseModel):
    user_id: int
    firstName: str
    lastName: str
    email: str
    phone_number: str
    gender: str
    hospital_id: int
    availability: bool
    class Config:
        schema_extra = {
            "example": {
                "user_id": 1,
                "firstName": "John",
                "lastName": "Doe",
                "email": "test",
                "phone_number": "00111555",
                "gender" : "M",
                "availability": True,
                "hospital_id": 1
            }
        }

class DialysisMachine(BaseModel):
    startTime: int
    time_slot: int
    price: int
    slotCount: int
    dialysis_machine_id: int
    hospital_id: int
    availability:bool
    class Config:
        schema_extra = {
            "example": {
                "startTime": 0,
                "time_slot": 0,
                "slotCount": 0,
                "price": 0,
                "dialysis_machine_id": 0,
                "hospital_id": 0,
                "availability": True
            }
        }

class Appointment(BaseModel):
    appointment_id: int
    patient_id: int
    doctor_id: int
    hospital_id: int
    dialysis_machine_id: int
    status: str
    time: str
    slot: int
    class Config:
        schema_extra = {
            "example": {
                "appointment_id": 0,
                "patient_id": 0,
                "dialysis_machine_id": 0,
                "doctor_id": 0,
                "hospital_id": 0,
                "status": "pending",
                "time": "2021-01-01 00:00:00",
                "slot": 0
            }
        }

class MedicalRecordEntry(BaseModel):
    Diagnosis: str
    record_id: int
    appointment_id: int
    patient_id: int
    doctor_id: int    
    class Config:
        schema_extra = {
            "example": {
                "Diagnosis": "COVID-19",
                "record_id": 0,
                "appointment_id": 0,
                "patient_id": 0,
                "doctor_id": 0
            }
        }

@app.post("/Login")
async def Login(loginInfo: LoginInfo):
    query = "SELECT u.user_type, u.user_id, u.first_name, u.last_name, u.phone_number, u.gender, u.email FROM app_user u WHERE u.username = %s AND u.password = %s;"
    data = (loginInfo.hashedUsername, loginInfo.hashedPassword)
    conn = psycopg2.connect(**dbInfo)
    cnx = conn.cursor()
    cnx.execute(query, data)
    result = cnx.fetchone()  
    if result == None:
        conn.close()
        raise HTTPException(status_code=404, detail="User not found")
    
    if result[0] == 'p':
        query = "SELECT p.birthday FROM patient p WHERE p.patient_id = %s;"
        data = (result[1],)
        cnx.execute(query, data)
        pResult = cnx.fetchone()
        conn.close()
        return PatientInfo(user_id= result[1], firstName= result[2], lastName= result[3], phone_number= result[4], gender= result[5], email= result[6], birthdate= str(pResult[0]))
    
    elif result[0] == 'd':
        query = "SELECT d.hospital_id FROM doctor d WHERE d.doctor_id = %s;"
        data = (result[1],)
        cnx.execute(query, data)
        dResult = cnx.fetchone()
        conn.close()
        return DoctorInfo(user_id= result[1], firstName= result[2], lastName= result[3], phone_number= result[4], gender= result[5], email= result[6], hospital_id= dResult[0])
    

@app.post("/SignUp")
async def SignUp(patientInfo: PatientInfo, loginInfo:LoginInfo)-> int:
    try:
        conn = psycopg2.connect(**dbInfo)
        cnx = conn.cursor()
        query = "INSERT INTO app_user (user_id,first_name, last_name, phone_number, gender, email, user_type, username, password) VALUES(nextval('patient_sequence'),%s, %s, %s, %s, %s, 'p', %s, %s);"
        data = (patientInfo.firstName,patientInfo.lastName,patientInfo.phone_number,patientInfo.gender,patientInfo.email,loginInfo.hashedUsername,loginInfo.hashedPassword)
        cnx.execute(query, data)
        conn.commit()
        query = "SELECT currval('patient_sequence');"
        cnx.execute(query)
        result = cnx.fetchone()
        patientInfo.user_id = result[0]
        query = "INSERT INTO patient (patient_id, birthday) VALUES(%s, %s);"
        data = (patientInfo.user_id, patientInfo.birthdate)
        cnx.execute(query, data)
        conn.commit()
        conn.close()
        return patientInfo.user_id
    except:
        conn.close()
        return -1

@app.get("/GetHospitalList")
async def GetHospitalList(Name:str = None, City:str = None, Area:str = None)-> list[Hospital]:
    params = []
    conn = psycopg2.connect(**dbInfo)
    cnx = conn.cursor()
    if Name != None and len(Name)>0:
        params.append(("hospital.hospital_name = %s",Name))
    if City != None and len(City)>0:
        params.append(("hospital.city = %s",City))
    if Area != None and len(Area)>0:
        params.append(("hospital.area = %s",Area))

    query = "SELECT hospital.hospital_id, hospital.hospital_name, hospital.address, hospital.phone_number, hospital.email, hospital.city, hospital.area FROM hospital"
    results = []
    if len(params) > 0:
        query += " WHERE " + " AND ".join([param[0] for param in  params]) + ';'
        cnx.execute(query, tuple(param[1] for param in params))
    else:
        query += ";"
        cnx.execute(query)  
    results = cnx.fetchall()
    Hospitals = []
    for result in results:
        Hospitals.append(Hospital(id=result[0], name=result[1], address=result[2], phone_number=result[3], email=result[4], city=result[5], area=result[6]))
    conn.close()
    return Hospitals


@app.get("/GetMedicalRecord")
async def GetMedicalRecord(patient_id:int)-> list[MedicalRecordEntry]:
    query = "SELECT m.record_id, m.appointment_id, m.patient_id, m.doctor_id, m.doctor_diagnose FROM medical_record m WHERE m.patient_id = %s;"
    data = (patient_id,)
    conn = psycopg2.connect(**dbInfo)
    cnx = conn.cursor()
    cnx.execute(query, data)
    results = cnx.fetchall()
    medicalRecords = []
    for result in results:
        medicalRecords.append(MedicalRecordEntry(record_id=result[0], appointment_id=result[1], patient_id=result[2], doctor_id=result[3], Diagnosis=result[4]))
    conn.close()
    return medicalRecords

@app.post("/MakeAppointment")
async def MakeAppointment(appointment: Appointment)-> bool:
    try:
        query = "INSERT INTO appointment (appointment_id, dialysis_machine_id, patient_id, doctor_id,hospital_id, time, status, slot) VALUES(nextval('appointment_sequence'), %s, %s, %s, %s, %s, 'unfulfilled', %s);"
        data = (appointment.dialysis_machine_id, appointment.patient_id, appointment.doctor_id, appointment.hospital_id, appointment.time, appointment.slot)
        conn = psycopg2.connect(**dbInfo)
        cnx = conn.cursor()
        cnx.execute(query, data)
        conn.commit()
        conn.close()
        return True
    except Exception as e:
        print(e)
        conn.close()
        return False

@app.get("/GetAppointments")
async def GetAppointments(patient_id:int, unFullfilledOnly:bool)-> list[Appointment]:
    query = "SELECT a.appointment_id, a.dialysis_machine_id, a.patient_id, a.doctor_id, a.hospital_id, a.time, a.status, a.slot FROM appointment a WHERE a.patient_id = %s"
    if unFullfilledOnly:
        query += " AND a.status = 'unfulfilled'"
    query += ";"
    data = (patient_id,)
    conn = psycopg2.connect(**dbInfo)
    cnx = conn.cursor()
    cnx.execute(query, data)
    results = cnx.fetchall()
    appointments = []
    for result in results:
        appointments.append(Appointment(appointment_id=result[0], dialysis_machine_id=result[1], patient_id=result[2], doctor_id=result[3], hospital_id=result[4], time=str(result[5]), status=result[6], slot=result[7]))
    conn.close()
    return appointments

@app.post("/ChangeAppointment")
async def ChangeAppointment(appointment: Appointment)-> bool:
    query = "UPDATE appointment SET status = %s, time = %s, slot = %s, dialysis_machine_id = %s, hospital_id = %s, doctor_id = %s WHERE appointment_id = %s;"
    data = (appointment.status, appointment.time, appointment.slot, appointment.dialysis_machine_id, appointment.hospital_id, appointment.doctor_id, appointment.appointment_id)
    conn = psycopg2.connect(**dbInfo)
    cnx = conn.cursor()
    cnx.execute(query, data)
    conn.commit()
    conn.close()

@app.post("/EditUserInfo")
async def EditUserInfo(loginInfo:LoginInfo, patientInfo: PatientInfo = None, doctorInfo:DoctorInfo = None)-> bool:
    try:
        query = "UPDATE app_user SET first_name = %s, last_name = %s, email = %s, phone_number = %s, gender = %s WHERE user_id = %s;"
        query2 = ""
        data = ()
        data2 = ()
        if patientInfo != None:
            query2 = "UPDATE patient SET birthday = %s WHERE patient_id = %s;"
            data = (patientInfo.firstName, patientInfo.lastName, patientInfo.email, patientInfo.phone_number, patientInfo.gender,patientInfo.user_id) 
            data2 = (patientInfo.birthdate, patientInfo.user_id)
        elif doctorInfo != None:
            query2 = "UPDATE doctor SET hospital_id = %s WHERE doctor_id = %s;"
            data = (doctorInfo.firstName, doctorInfo.lastName, doctorInfo.email,doctorInfo.phone_number, doctorInfo.gender,doctorInfo.user_id) 
            data2 = (doctorInfo.hospital_id, doctorInfo.user_id)
        conn = psycopg2.connect(**dbInfo)
        cnx = conn.cursor()
        cnx.execute(query2, data2)
        cnx.execute(query, data)
        conn.commit()
        conn.close()
        return True
    except Exception as e:
        print(e)
        conn.close()
        return False
    
@app.post("/AppendMedicalRecord")
async def AppendMedicalRecord(medicalRecordEntry: MedicalRecordEntry)-> bool:
    try:
        query = "INSERT INTO medical_record (record_id, appointment_id, patient_id, doctor_id, doctor_diagnose) VALUES(nextval('medical_record_sequence'), %s, %s, %s, %s);"
        data = (medicalRecordEntry.appointment_id, medicalRecordEntry.patient_id, medicalRecordEntry.doctor_id, medicalRecordEntry.Diagnosis)
        conn = psycopg2.connect(**dbInfo)
        cnx = conn.cursor()
        cnx.execute(query, data)
        conn.commit()
        conn.close()
        return True
    except Exception as e:
        print(e)
        conn.close()
        return False

@app.post("/AddDialysisMachine")
async def AddDialysisMachine(dialysisMachine: DialysisMachine)-> bool:
    try:
        query = "INSERT INTO dialysis_machine (dialysis_machine_id, hospital_id, start_time, time_slot, slots_number, price, availability) VALUES(nextval('dialysis_machine_sequence'), %s, %s, %s, %s, %s, %s);"
        data = (dialysisMachine.hospital_id, dialysisMachine.startTime, dialysisMachine.time_slot, dialysisMachine.slotCount, dialysisMachine.price, dialysisMachine.availability)
        conn = psycopg2.connect(**dbInfo)
        cnx = conn.cursor()
        cnx.execute(query, data)
        conn.commit()
        conn.close()
        return True
    except Exception as e:
        print(e)
        conn.close()
        return False
    
@app.post("/EditDialysisMachine")
async def EditDialysisMachine(dialysisMachine: DialysisMachine)-> bool:
    try:
        query = "UPDATE dialysis_machine SET hospital_id = %s, start_time = %s, time_slot = %s, slots_number = %s, price = %s, availability = %s WHERE dialysis_machine_id = %s;"
        data = (dialysisMachine.hospital_id, dialysisMachine.startTime, dialysisMachine.time_slot, dialysisMachine.slotCount, dialysisMachine.price, dialysisMachine.availability, dialysisMachine.dialysis_machine_id)
        conn = psycopg2.connect(**dbInfo)
        cnx = conn.cursor()
        cnx.execute(query, data)
        conn.commit()
        conn.close()
        return True
    except Exception as e:
        print(e)
        conn.close()
        return False

@app.post("/LoginHospital")
async def LoginHospital(hospitalLogin: LoginInfo)-> Hospital:
    query = "SELECT h.hospital_id, h.hospital_name, h.address, h.phone_number, h.email, h.city, h.area FROM hospital h WHERE h.username = %s AND h.password = %s;"
    data = (hospitalLogin.hashedUsername, hospitalLogin.hashedPassword)
    conn = psycopg2.connect(**dbInfo)
    cnx = conn.cursor()
    cnx.execute(query, data)
    result = cnx.fetchone()
    conn.close()
    if result == None:
        raise HTTPException(status_code=404, detail="Hospital not found")
    return Hospital(id=result[0], name=result[1], address=result[2], phone_number=result[3], email=result[4], city=result[5], area=result[6])
@app.post("/AddDoctor")
async def AddDoctor(doctor: DoctorInfo, login: LoginInfo)-> bool:
    try:
        query = "INSERT INTO app_user (user_id, first_name, last_name, phone_number, gender, email, username, password, user_type) VALUES(nextval('doctor_sequence'), %s, %s, %s, %s, %s, %s, %s, 'd');"
        query2 = "INSERT INTO doctor (doctor_id, hospital_id, availability) VALUES(currval('doctor_sequence'), %s, %s);"
        data = (doctor.firstName,doctor.lastName,doctor.phone_number,doctor.gender,doctor.email,login.hashedUsername,login.hashedPassword) 
        data2 = (doctor.hospital_id, doctor.availability)
        conn = psycopg2.connect(**dbInfo)
        cnx = conn.cursor()
        cnx.execute(query, data)
        cnx.execute(query2, data2)
        conn.commit()
        conn.close()
        return True
    
    except Exception as e:
        print(e)
        conn.close()
        return False


@app.get("/GetDoctors")
async def GetDoctors(hospitalID: int)-> list[DoctorInfo]:
    query = "SELECT u.user_id, u.first_name, u.last_name, u.phone_number, u.gender, u.email from app_user u join doctor d on u.user_id = d.doctor_id where d.hospital_id = %s and d.availability = true;"
    data = (hospitalID,)
    conn = psycopg2.connect(**dbInfo)
    cnx = conn.cursor()
    cnx.execute(query, data)
    results = cnx.fetchall()
    doctors = []
    conn.close()
    if results == None:
        raise HTTPException(status_code=404, detail="No doctors found")
    for result in results:
        doctors.append(DoctorInfo(user_id=result[0],firstName=result[1],lastName=result[2],phone_number=result[3],gender=result[4],email=result[5],availability=True,hospital_id=hospitalID))
    return doctors

@app.get("/GetDialysisMachines")
async def GetDialysisMachines(hospitalID: int)-> list[DialysisMachine]:
    query = "SELECT d.dialysis_machine_id, d.hospital_id, d.start_time, d.time_slot, d.slots_number, d.price, d.availability FROM dialysis_machine d WHERE d.hospital_id = %s and d.availability = true;"
    data = (hospitalID,)
    conn = psycopg2.connect(**dbInfo)
    cnx = conn.cursor()
    cnx.execute(query, data)
    results = cnx.fetchall()
    dialysisMachines = []
    conn.close()
    if results == None:
        raise HTTPException(status_code=404, detail="No dialysis machines found")
    for result in results:
        dialysisMachines.append(DialysisMachine(dialysis_machine_id=result[0],hospital_id=result[1],startTime=result[2],time_slot=result[3],slotCount=result[4],price=result[5],availability=True))
    return dialysisMachines

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

