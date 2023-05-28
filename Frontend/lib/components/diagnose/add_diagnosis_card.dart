import 'package:flutter/material.dart';
import 'package:hemodialysis_csci305/backend/api_connection.dart';
import 'package:hemodialysis_csci305/components/shared_components.dart';

import '../../../backend/shared_variables.dart';

Card addDiagnosisCard(Map<String, dynamic> docAppointment, BuildContext context,
    VoidCallback update) {
  return Card(
    color: cardColor,
    margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
    child: ListTile(
        contentPadding:
            const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
        title: Text(
          "Patient Name: ${docAppointment["patient_name"]}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
            "Gender: ${docAppointment["gender"] == 'm' ? "male" : "female"}\nAppointment Time: ${docAppointment["time"]}",
            style: const TextStyle(
              // fontSize: 8,
              fontWeight: FontWeight.w400,
            )),
        isThreeLine: true,
        onTap: () {
          addDiagnosisAlert(docAppointment, context, update);
        }),
  );
}

// {appointment_id: 6000002, doctor_id: 2000000, patient_id: 1000000, hospital_id: 3000000,
// dialysis_machine_id: 4000000, time: 2023-05-17, status: booked, slot: 0,
// patient_name: potato2 tomato, birthdate: 2000-05-15, gender: m, phone_number: 01020304050}

Future<dynamic> addDiagnosisAlert(Map<String, dynamic> docAppointment,
    BuildContext context, VoidCallback update) {
  final birthdateList = docAppointment["birthdate"].split('-');
  final birthdate = DateTime(int.parse(birthdateList[0]),
      int.parse(birthdateList[1]), int.parse(birthdateList[2]));
  final age = DateTime.now().difference(birthdate).inDays ~/ 365;
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Details"),
      content: SelectableText(
          "Patient: ${docAppointment["patient_name"]}\nGender: ${docAppointment["gender"] == 'm' ? "male" : "female"}\nAge: $age\nPhone: ${docAppointment["phone_number"]}\nAppointment Time: ${docAppointment["time"]}",
          style: const TextStyle(fontSize: 18)),
      actions: [
        TextButton(
          onPressed: () => {addDiagnosis(docAppointment, context, update)},
          child: const Text("Add Diagnosis"),
        ),
        TextButton(
          onPressed: () => close(context),
          child: const Text("Okay"),
        ),
      ],
    ),
  );
}

Future<dynamic> addDiagnosis(docAppointment, context, VoidCallback update) {
  TextEditingController diagnosisController = TextEditingController();
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Add Your Diagnosis"),
      content: TextField(
        controller: diagnosisController,
      ),
      actions: [
        TextButton(
            onPressed: () {
              String docDiagnosis = diagnosisController.text;
              loadingIndecatorContext(context);
              appendMedicalRecord(
                      appointmentId: docAppointment["appointment_id"],
                      diagnosis: docDiagnosis,
                      doctorId: box.get("userId"),
                      patientId: docAppointment["patient_id"])
                  .then((value) {
                if (value[0] == 200) {
                  changeAppointment(
                          appointmentId: docAppointment["appointment_id"],
                          patientId: docAppointment["patient_id"],
                          dialysisMachineId:
                              docAppointment["dialysis_machine_id"],
                          doctorId: docAppointment["doctor_id"],
                          hospitalId: docAppointment["hospital_id"],
                          status: "fulfilled",
                          time: docAppointment["time"],
                          slot: docAppointment["slot"])
                      .then((value) {
                    if (value[0] == 200) {
                      snackBar("Added :)", context);
                    } else {
                      snackBar("Error :( ${value[0]}", context);
                    }
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    update();
                  });
                } else {
                  snackBar("Error :( ${value[0]}", context);
                }
              });
            },
            child: const Text("Done"))
      ],
    ),
  );
}

void close(BuildContext context) {
  Navigator.of(context).pop();
}
