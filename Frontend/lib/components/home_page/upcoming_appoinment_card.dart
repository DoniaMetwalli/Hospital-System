import 'package:flutter/material.dart';
import 'package:hemodialysis_csci305/backend/api_connection.dart';

import '../../backend/shared_variables.dart';

Card upcomingAppoinmentCard(Map<String, dynamic> appointmentsList, BuildContext context) {
  return Card(
    color: cardColor,
    margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
    child: ListTile(
      contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
      title: Text(
        "Hospital Name: ${appointmentsList["hospital"]["name"]}",
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
          "Hospital Address: ${appointmentsList["hospital"]["address"]}\n Appointment Time: ${appointmentsList["appointment"]["time"]}",
          style: const TextStyle(
            // fontSize: 8,
            fontWeight: FontWeight.w400,
          )),
      isThreeLine: true,
      onTap: () => upcomingAppoinmentAlert(appointmentsList, context),
    ),
  );
}

Future<dynamic> upcomingAppoinmentAlert(
    Map<String, dynamic> appointmentsList, BuildContext context) {
  final hospital = appointmentsList["hospital"];
  final appointment = appointmentsList["appointment"];
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Details"),
      content: SelectableText(
          "Hospital Name: ${hospital["name"]}\nHospital Address: ${hospital["address"]}\nAppointment Time: ${appointment["time"]}\nDoctor's Name: ${appointmentsList["doctorName"]}\nHospital Phone: ${hospital["phone_number"]},\nDoctor's Phone: ${appointmentsList["doctorPhone"]},\nHospital E-mail: ${hospital["email"]}"),
      actions: [
        TextButton(
          onPressed: () => changeAppointment(
            appointmentId: appointment["appointment_id"],
            patientId: box.get("userId"),
            dialysisMachineId: appointment["dialysis_machine_id"],
            doctorId: appointment["doctor_id"],
            hospitalId: appointment["hospital_id"],
            status: "canceled",
            time: appointment["time"],
            slot: 0,
          ),
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

void close(BuildContext context) {
  Navigator.of(context).pop();
}
