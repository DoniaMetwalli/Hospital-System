import 'package:flutter/material.dart';
import '../../backend/shared_variables.dart';

// Output : [200, [{Diagnosis: eat less potato, record_id: 5000000, appointment_id: 6000000, patient_id: 1000000, doctor_id: 2000000}]]

Card medicalRecordCard(Map<String, dynamic> medicalRecord, BuildContext context) {
  return Card(
    color: cardColor,
    margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
    child: ListTile(
      contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
      title: Text(
        "Diagnosis: ${medicalRecord["Diagnosis"]}",
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () => medicalRecordAlert(medicalRecord, context),
    ),
  );
}

Future<dynamic> medicalRecordAlert(Map<String, dynamic> medicalRecord, BuildContext context) {
  final diagnosis = medicalRecord["Diagnosis"];
  final doctor = medicalRecord["doctor_id"];
  final appointment = medicalRecord["appointment_id"];
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Details"),
      content: SelectableText(
        "Diagnosis: $diagnosis\nDoctor: $doctor\nappointment: $appointment",
      ),
      actions: [
        TextButton(
          onPressed: () => close(context),
          child: const Text("Okay"),
        ),
      ],
    ),
  );
}

void close(BuildContext context) {
  Navigator.of(context).pop();
}
