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
            "Patient ID: ${docAppointment["patient_id"]}\nAppointment ID: ${docAppointment["appointment_id"]}",
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

Future<dynamic> addDiagnosisAlert(Map<String, dynamic> docAppointment,
    BuildContext context, VoidCallback update) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Details"),
      content: SelectableText(
          "Patient Name: ${docAppointment["patient_name"]}\nPatient ID: ${docAppointment["patient_id"]}\nAppointment ID: ${docAppointment["appointment_id"]}\nAppointment Time: ${docAppointment["time"]}\nPatient Birthday: ${docAppointment["birthdate"]}\nPatient Phone: ${docAppointment["phone_number"]}",
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
                      dialysisMachineId: docAppointment["dialysis_machine_id"],
                      doctorId: docAppointment["doctor_id"],
                      hospitalId: docAppointment["hospital_id"],
                      status: "fulfilled",
                      time: docAppointment["time"],
                      slot: docAppointment["slot"]);
                  snackBar("Added :)", context);
                } else {
                  snackBar("Error :( ${value[0]}", context);
                }
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                update();
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
