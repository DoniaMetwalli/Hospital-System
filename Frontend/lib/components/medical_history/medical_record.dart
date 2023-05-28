import 'package:flutter/material.dart';
import '../../backend/shared_variables.dart';
import '../shared_components.dart';

// [200, [{"diagnosis": "eat less potato","doctor_name": "tom tommy","diagnosis_time": "2023-05-15","hospital_name": "jerry's hospital"}]]

Card medicalRecordCard(
    Map<String, dynamic> medicalRecord, BuildContext context) {
  return Card(
    color: cardColor,
    margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
    child: ListTile(
      contentPadding:
          const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
      title: Text(
        "Diagnosis: ${medicalRecord["diagnosis"]}\nBy Doctor: ${medicalRecord["doctor_name"]}",
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () => medicalRecordAlert(medicalRecord, context),
    ),
  );
}

Future<dynamic> medicalRecordAlert(
    Map<String, dynamic> medicalRecord, BuildContext context) {
  final diagnosis = medicalRecord["diagnosis"];
  final doctor = medicalRecord["doctor_name"];
  final diagnosisTime = medicalRecord["diagnosis_time"];
  final hospitalName = medicalRecord["hospital_name"];
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Details"),
      content: SelectableText(
        "Diagnosis: $diagnosis\nBy Doctor: $doctor\nDiagnosis Time: $diagnosisTime\nAt Hospita: $hospitalName",
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
