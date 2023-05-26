import 'package:flutter/material.dart';
import 'package:hemodialysis_csci305/backend/api_connection.dart';

import '../../backend/shared_variables.dart';

Card addDiagnosis(
    Map<String, dynamic> docAppointment, BuildContext context, VoidCallback update) {
  return Card(
    color: cardColor,
    margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
    child: ListTile(
        contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
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
          upcomingAppoinmentAlert(docAppointment, context, update);
        }),
  );
}

Future<dynamic> upcomingAppoinmentAlert(
    Map<String, dynamic> docAppointment, BuildContext context, VoidCallback update) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Details"),
      content: SelectableText(
          "Appointment Time: ${docAppointment["time"]}\nPatient Birthday: ${docAppointment["birthday"]}\nPatient Phone: ${docAppointment["phone_number"]}",
          style: const TextStyle(fontSize: 18)),
      actions: [
        TextButton(
          onPressed: () => confirmCancel(docAppointment, context, update),
          child: const Text("Cancel Appointment"),
        ),
        TextButton(
          onPressed: () => close(context),
          child: const Text("Okay"),
        ),
      ],
    ),
  );
}

Future confirmCancel(
    Map<String, dynamic> appointmentsList, BuildContext context, VoidCallback picoWillBeKidnapped) {
  final appointment = appointmentsList["appointment"];
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Confirm"),
      content: const Text("Please click the button to confirm your cancellation"),
      actions: [
        TextButton(
          onPressed: () {
            changeAppointment(
              appointmentId: appointment["appointment_id"],
              patientId: box.get("userId"),
              dialysisMachineId: appointment["dialysis_machine_id"],
              doctorId: appointment["doctor_id"],
              hospitalId: appointment["hospital_id"],
              status: "canceled",
              time: appointment["time"],
              slot: 0,
            );
            Navigator.pop(context);
            Navigator.pop(context);
            picoWillBeKidnapped();
          },
          child: const Text(
            "Confirm Cancellation",
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Abort",
          ),
        )
      ],
    ),
  );
}

void close(BuildContext context) {
  Navigator.of(context).pop();
}
