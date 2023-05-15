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
    class Config:
        schema_extra = {
            "example": {
                "user_id": 1,
                "firstName": "John",
                "lastName": "Doe",
                "email": "",
                "phone_number": "",
                "birthdate": "1999-01-01",
                "hospital_id": 1
            }
        }

class DialysisMachine(BaseModel):
    startTime: int
    time_slot: int
    price: int
    dialysis_machine_id: int
    hospital_id: int
    class Config:
        schema_extra = {
            "example": {
                "startTime": 0,
                "time_slot": 0,
                "price": 0,
                "dialysis_machine_id": 0,
                "hospital_id": 0
            }
        }

class Appointment(BaseModel):
    appointment_id: int
    patient_id: int
    doctor_id: int
    hospital_id: int
    dialysis_machine_id: int
    class Config:
        schema_extra = {
            "example": {
                "appointment_id": 0,
                "patient_id": 0,
                "dialysis_machine_id": 0,
                "doctor_id": 0,
                "hospital_id": 0
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

@app.put("/Login")
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
        return PatientInfo(user_id= result[1], firstName= result[2], lastName= result[3], phone_number= result[4], gender= result[5], email= result[6], birthdate= pResult[0])
    
    elif result[0] == 'd':
        query = "SELECT d.hospital_id FROM doctor d WHERE d.doctor_id = %s;"
        data = (result[1],)
        cnx.execute(query, data)
        dResult = cnx.fetchone()
        conn.close()
        return DoctorInfo(user_id= result[1], firstName= result[2], lastName= result[3], phone_number= result[4], gender= result[5], email= result[6], hospital_id= dResult[0])
    

@app.post("/SignUp")
async def SignUp(patientInfo: PatientInfo, loginInfo:LoginInfo)-> bool:
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
        return True
    except:
        conn.close()
        return False

@app.get("/GetHospitalList")
async def GetHospitalList(name:str = None, city:str = None, area:str = None)-> list[Hospital]:
    pass

@app.get("/GetMedicalRecord")
async def GetMedicalRecord(patient_id:int)-> list[MedicalRecordEntry]:
    pass

@app.post("/MakeAppointment")
async def MakeAppointment(appointment: Appointment)-> bool:
    pass

@app.get("/GetAppointments")
async def GetAppointments(patient_id:int, unFullfilledOnly:bool)-> list[Appointment]:
    pass

@app.post("/ChangeAppointment")
async def ChangeAppointment(appointment: Appointment)-> bool:
    pass

@app.post("/EditPatientInfo")
async def EditPatientInfo(patientInfo: PatientInfo)-> bool:
    pass

@app.post("AppendMedicalRecord")
async def AppendMedicalRecord(medicalRecordEntry: MedicalRecordEntry)-> bool:
    pass

@app.post("AddDialysisMachine")
async def AddDialysisMachine(dialysisMachine: DialysisMachine)-> bool:
    pass

@app.post("EditDialysisMachine")
async def EditDialysisMachine(dialysisMachine: DialysisMachine)-> bool:
    pass

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

