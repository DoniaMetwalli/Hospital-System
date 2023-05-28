import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'package:hemodialysis_csci305/backend/shared_variables.dart';

String apiLink = "https://305.nucoders.dev:8090";

List<String> appointmentStatus = [
  'booked',
  'rejected by hospital',
  'rejected by doctor',
  'canceled',
  'fulfilled'
];

String hashSha256(String input) {
  var firstChunk = utf8.encode(input);
  return sha256.convert(firstChunk).toString();
}

//OK
/*
  Output : [200, {user_id: 1000002, firstName: sesame, lastName: 1, email: sesame1@potato.com, phone_number: 01020304060, birthdate: 2021-01-17, gender: m}]
  I am lazy to write the same explaination go to getHospitals function you will understand :-)
  - You will find login example below in main funtion   
*/
Future<List> login({
  required String username,
  required String password,
}) async {
  Dio dio = Dio();
  try {
    username = hashSha256(username.trim());
    password = hashSha256(password.trim());

    final result = await dio.post(
      '$apiLink/Login',
      data: {"hashedUsername": username, "hashedPassword": password},
    );
    box.put("username", username);
    box.put("password", password);
    return [result.statusCode, result.data];
  } on DioError catch (e) {
    if (e.response != null) {
      return [e.response!.statusCode];
    }
    return [-1];
  }
}

// ok
/*
  Signup is for patient ONLY...
  Output : [200, 1000003]
  Output[0] {ex: 200} is the status code (tip: check if status is 200 then it's ok otherwise alert the user)
  Output[1] is the patient id we should store it as we will need it later in other requests
  - You will find SignUp example below in main funtion   
*/
Future<List> signup({
  required String firstName,
  required String lastName,
  required String email,
  required String phoneNumber,
  required String birthdate,
  required String gender,
  required String username,
  required String password,
}) async {
  Dio dio = Dio();
  try {
    username = hashSha256(username);
    password = hashSha256(password);

    final result = await dio.post(
      '$apiLink/SignUp',
      data: {
        "patientInfo": {
          "user_id": 1,
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "phone_number": phoneNumber,
          "birthdate": birthdate,
          "gender": gender
        },
        "loginInfo": {
          "hashedUsername": username,
          "hashedPassword": password,
        }
      },
    );
    box.put("username", username);
    box.put("password", password);
    return [result.statusCode, result.data];
  } on DioError catch (e) {
    if (e.response != null) {
      return [e.response!.statusCode];
    }
    return [-1];
  }
}

//ok
/*
  Get hospital list just call it :)
  output :
  [200, [{id: 3000000, name: jerry's hospital, address: Giza / 6October / 1st, phone_number: 01020304070, email: jerry@hospital.com, city: giza, area: 6-october}]]
  output[0] {ex: 200} is the status code (tip: check if status is 200 then it's ok otherwise alert the user)
  output[1] is the hospital list you can access any element in list in this way 
  output[1][hospital_index][hospital_data]
  output[1][0]["name"] will output jerry's hospital
  - You will find GetHospitals example below in main funtion 
*/
Future<List> getHospitals() async {
  Dio dio = Dio();
  try {
    final result = await dio.get('$apiLink/GetHospitalList');
    return [result.statusCode, result.data];
  } on DioError catch (e) {
    if (e.response != null) {
      return [e.response!.statusCode];
    }
    return [-1];
  }
}

//ok
/*
  Get Medical record of any patient it O_O
  Output : [200, [{"diagnosis": "eat less potato","doctor_name": "tom tommy","diagnosis_time": "2023-05-15","hospital_name": "jerry's hospital"}]]
  Output[0] {ex: 200} is the status code (tip: check if status is 200 then it's ok otherwise alert the user)
  Output[1] is the medical record for any given patient 
  - You will find GetMedicalRecord example below in main funtion   
*/
Future<List> getMedicalRecord({required int patientId}) async {
  Dio dio = Dio();
  try {
    final result =
        await dio.get('$apiLink/GetMedicalRecord?patient_id=$patientId');
    return [result.statusCode, result.data];
  } on DioError catch (e) {
    if (e.response != null) {
      return [e.response!.statusCode];
    }
    return [-1];
  }
}

//not ok
/*
  We will store patient data locally 
  Other data we will get it from patient search 
  - You will find MakeAppointment example below in main funtion   
*/
Future<List> makeAppointment({
  required int patientId,
  required int dialysisMachineId,
  required int doctorId,
  required int hospitalId,
  required String time,
  required int slot,
}) async {
  Dio dio = Dio();
  try {
    final result = await dio.post(
      '$apiLink/MakeAppointment',
      data: {
        "appointment_id": 0,
        "patient_id": patientId,
        "dialysis_machine_id": dialysisMachineId,
        "doctor_id": doctorId,
        "hospital_id": hospitalId,
        "status": "booked",
        "time": time,
        "slot": 0
      },
    );

    return [result.statusCode];
  } on DioError catch (e) {
    if (e.response != null) {
      return [e.response!.statusCode];
    }
    return [-1];
  }
}

//ok
/*
  Output : [200, [{appointment_id: 6000000, patient_id: 1000000, doctor_id: 2000000, hospital_id: 3000000, dialysis_machine_id: 4000000, status: booked, time: 2023-05-15, slot: 2}]]
  - You will find GetAppointments example below in main funtion   
*/
Future<List> getAppointments({
  required int patientId,
  String status = "",
}) async {
  Dio dio = Dio();
  try {
    final result = await dio.get(
        '$apiLink/GetAppointments?patient_id=$patientId${status.isEmpty ? "" : "&status=$status"}');
    return [result.statusCode, result.data];
  } on DioError catch (e) {
    if (e.response != null) {
      return [e.response!.statusCode];
    }
    return [-1];
  }
}

/*{
    "appointment_id": 6000000,
    "doctor_id": 2000000,
    "patient_id": 1000000,
    "time": "2023-05-15",
    "status": "canceled",
    "patient_name": 0,
    "birthdate": "potato tomato",
    "gender": "2000-05-15"
}*/
Future<List> getDoctorAppointments({
  required int doctorId,
  String status = "",
}) async {
  Dio dio = Dio();
  try {
    final result = await dio.get(
        '$apiLink/GetDoctorAppointments?doctor_id=$doctorId${status.isEmpty ? "" : "&status=$status"}');
    return [result.statusCode, result.data];
  } on DioError catch (e) {
    if (e.response != null) {
      return [e.response!.statusCode];
    }
    return [-1];
  }
}

//ok
/*
  Output : [200]
  - You will find changeAppointment example below in main funtion   
*/
Future<List> changeAppointment({
  required int appointmentId,
  required int patientId,
  required int dialysisMachineId,
  required int doctorId,
  required int hospitalId,
  required String status,
  required String time,
  required int slot,
}) async {
  Dio dio = Dio();
  try {
    final result = await dio.post(
      '$apiLink/ChangeAppointment',
      data: {
        "appointment_id": appointmentId,
        "patient_id": patientId,
        "dialysis_machine_id": dialysisMachineId,
        "doctor_id": doctorId,
        "hospital_id": hospitalId,
        "status": status,
        "time": time,
        "slot": slot
      },
    );

    return [result.statusCode];
  } on DioError catch (e) {
    if (e.response != null) {
      return [e.response!.statusCode];
    }
    return [-1];
  }
}

//ok
/*
  Output : [200, [{startTime: 7, time_slot: 60, price: 320, slotCount: 3, dialysis_machine_id: 4000000, hospital_id: 3000000, availability: true}, {startTime: 0, time_slot: 0, price: 50, slotCount: 0, dialysis_machine_id: 4000002, hospital_id: 3000000, availability: true}]]
  - You will find getDialysisMachines example below in main funtion   
*/
Future<List> getDialysisMachines({required int hospitalId}) async {
  Dio dio = Dio();
  try {
    final result =
        await dio.get('$apiLink/GetDialysisMachines?hospitalID=$hospitalId');
    return [result.statusCode, result.data];
  } on DioError catch (e) {
    if (e.response != null) {
      return [e.response!.statusCode];
    }
    return [-1];
  }
}

//ok
/*
  Output : [200, [{user_id: 2000000, firstName: tom, lastName: tommy, email: potato@tomato.com, phone_number: 01020304060, gender: m, hospital_id: 3000000, availability: true}, {user_id: 2000001, firstName: John, lastName: Doe, email: test, phone_number: 00111555, gender: M, hospital_id: 3000000, availability: true}, {user_id: 2000002, firstName: John, lastName: Doe, email: test, phone_number: 00111555, gender: M, hospital_id: 3000000, availability: true}, {user_id: 2000003, firstName: John, lastName: Doe, email: test, phone_number: 00111555, gender: M, hospital_id: 3000000, availability: true}]]
  - You will find getDoctors example below in main funtion   
*/
Future<List> getDoctors({required int hospitalId}) async {
  Dio dio = Dio();
  try {
    final result = await dio.get('$apiLink/GetDoctors?hospitalID=$hospitalId');
    return [result.statusCode, result.data];
  } on DioError catch (e) {
    if (e.response != null) {
      return [e.response!.statusCode];
    }
    return [-1];
  }
}

//ok
/*
  output : [200, {id: 3000000, name: jerry's hospital, address: Giza / 6October / 1st, phone_number: 01020304070, email: jerry@hospital.com, city: giza, area: 6-october}]
  - You will find loginHospital example below in main funtion   
*/
Future<List> loginHospital({
  required String username,
  required String password,
}) async {
  Dio dio = Dio();
  try {
    username = hashSha256(username);
    password = hashSha256(password);

    final result = await dio.post(
      '$apiLink/LoginHospital',
      data: {"hashedUsername": username, "hashedPassword": password},
    );

    return [result.statusCode, result.data];
  } on DioError catch (e) {
    if (e.response != null) {
      return [e.response!.statusCode];
    }
    return [-1];
  }
}

//ok
/*
  output : [200]
  - You will find appendMedicalRecord example below in main funtion   
*/
Future<List> appendMedicalRecord({
  required String diagnosis,
  required int appointmentId,
  required int patientId,
  required int doctorId,
}) async {
  Dio dio = Dio();
  try {
    final result = await dio.post('$apiLink/AppendMedicalRecord', data: {
      "Diagnosis": diagnosis,
      "record_id": 4685, // random number do not ask me why I choose it XD
      "appointment_id": appointmentId,
      "patient_id": patientId,
      "doctor_id": doctorId
    });
    return [result.statusCode];
  } on DioError catch (e) {
    if (e.response != null) {
      return [e.response!.statusCode];
    }
    return [-1];
  }
}

// ok
/* 
  output : [200]
 - You will find editDialysisMachine example below in main funtion   
*/
Future<List> editDialysisMachine({
  required int startTime,
  required int timeSlot,
  required int slotCount,
  required int price,
  required int dialysisMachineId,
  required int hospitalId,
  required bool availability,
}) async {
  Dio dio = Dio();
  try {
    final result = await dio.post(
      '$apiLink/EditDialysisMachine',
      data: {
        "startTime": startTime,
        "time_slot": timeSlot,
        "slotCount": slotCount,
        "price": price,
        "dialysis_machine_id": dialysisMachineId,
        "hospital_id": hospitalId,
        "availability": availability
      },
    );
    return [result.statusCode];
  } on DioError catch (e) {
    if (e.response != null) {
      return [e.response!.statusCode];
    }
    return [-1];
  }
}

/* return bool */
Future<List> editUserInfo({
  required int userId,
  required String firstName,
  required String lastName,
  required String email,
  required String phoneNumber,
  required String username,
  required String password,
  required String gender,
  String? birthdate,
  bool? availability,
  int? hospitalId,
}) async {
  Dio dio = Dio();
  try {
    final result = await dio.post(
      '$apiLink/EditUserInfo',
      data: {
        "loginInfo": {
          "hashedUsername": username,
          "hashedPassword": password,
        },
        if (box.get("isPatient") == true)
          "patientInfo": {
            "user_id": userId,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "phone_number": phoneNumber,
            "birthdate": birthdate,
            "gender": gender
          }
        else
          "doctorInfo": {
            "user_id": userId,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "phone_number": phoneNumber,
            "availability": availability,
            "hospital_id": hospitalId,
            "gender": gender
          }
      },
    );
    return [result.statusCode];
  } on DioError catch (e) {
    if (e.response != null) {
      return [e.response!.statusCode];
    }
    return [-1];
  }
}

// ok
/* 
  output : [200]
 - You will find addDoctor example below in main funtion   
*/
Future<List> addDoctor({
  required String firstName,
  required String lastName,
  required String email,
  required String phoneNumber,
  required String gender,
  required String username,
  required String password,
  required int hospitalId,
}) async {
  Dio dio = Dio();
  try {
    final result = await dio.post(
      '$apiLink/AddDoctor',
      data: {
        "doctor": {
          "user_id": 1,
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "phone_number": phoneNumber,
          "gender": gender,
          "availability": true,
          "hospital_id": hospitalId
        },
        "login": {
          "hashedUsername": username,
          "hashedPassword": password,
        }
      },
    );

    return [result.statusCode];
  } on DioError catch (e) {
    if (e.response != null) {
      return [e.response!.statusCode];
    }
    return [-1];
  }
}

void main(List<String> args) async {
  // SignUp example
  // print(
  //   await signup(
  //     firstName: "sesame",
  //     lastName: "1",
  //     birthdate: "2021-1-17",
  //     email: "sesame1@potato.com",
  //     gender: "m",
  //     password: "sesame@1*",
  //     username: "sesame1",
  //     phoneNumber: "01020304060",
  //   ),
  // );

  // Login example
  // print(
  //   await login(
  //     password: "sesame@1*",
  //     username: "sesame1",
  //   ),
  // );

  // GetHospitals example
  // print(await getHospitals());

  // GetMedicalRecord example
  // print(await getMedicalRecord(patientId: 1000000));

  // MakeAppointment example
  // print(
  //   await makeAppointment(
  //       patientId: 1000000,
  //       dialysisMachineId: 4000000,
  //       doctorId: 2000000,
  //       hospitalId: 3000000,
  //       slot: 1,
  //       time: "2023-5-17"),
  // );

  // GetAppointments example
  // print(
  //   await getAppointments(patientId: 1000000, isFullFilled: false),
  // );

  // ChangeAppointment example
  // print(
  //   await changeAppointment(
  //       patientId: 1000000,
  //       appointmentId: 6000000,
  //       dialysisMachineId: 4000000,
  //       doctorId: 2000000,
  //       hospitalId: 3000000,
  //       status: "booked",
  //       slot: 4,
  //       time: "2023-05-15"),
  // );

  // ChangeAppointment example
  // print(
  //   await getDialysisMachines(hospitalId: 3000000),
  // );

  // getDoctors example
  // print(
  //   await getDoctors(hospitalId: 3000000),
  // );

  // appendMedicalRecord example
  // print(
  //   await appendMedicalRecord(
  //     appointmentId: 6000000,
  //     diagnosis: "DO NOT EAT POTATO YOU WILL DIE FROM A POTATO OVERDOSE",
  //     doctorId: 2000000,
  //     patientId: 1000000,
  //   ),
  // );

  // editDialysisMachine example
  // print(
  //   await editDialysisMachine(
  //     dialysisMachineId: 4000000,
  //     price: 9,
  //     startTime: 8,
  //     timeSlot: 90,
  //     slotCount: 5,
  //     availability: false,
  //     hospitalId: 3000000,
  //   ),
  // );

  // addDoctor example
  // print(
  //   await addDoctor(
  //       firstName: "sherlock",
  //       lastName: "holmes",
  //       email: "sherlock@holmes.detective",
  //       gender: "m",
  //       hospitalId: 3000000,
  //       password: "youknowmyname",
  //       phoneNumber: "01020304070",
  //       username: "TheGreatestDetective"),
  // );
}
