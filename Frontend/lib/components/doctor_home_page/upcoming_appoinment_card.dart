import 'package:flutter/material.dart';
import 'package:hemodialysis_csci305/backend/api_connection.dart';
import 'package:hemodialysis_csci305/components/shared_components.dart';

import '../../backend/shared_variables.dart';

Card upcomingAppoinmentCard(Map<String, dynamic> appointmentsList,
    BuildContext context, VoidCallback update) {
  return Card(
    color: cardColor,
    margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
    child: ListTile(
        contentPadding:
            const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
        title: Text(
          "Patient: ${appointmentsList["patient_name"]}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
            "Gender: ${appointmentsList["gender"] == 'm' ? "male" : "female"}\nAppointment Time: ${appointmentsList["time"]}",
            style: const TextStyle(
              // fontSize: 8,
              fontWeight: FontWeight.w400,
            )),
        isThreeLine: true,
        onTap: () {
          upcomingAppoinmentAlert(appointmentsList, context, update);
        }),
  );
}

Future<dynamic> upcomingAppoinmentAlert(Map<String, dynamic> appointmentsList,
    BuildContext context, VoidCallback update) {
  final birthdateList = appointmentsList["birthdate"].split('-');
  final birthdate = DateTime(int.parse(birthdateList[0]),
      int.parse(birthdateList[1]), int.parse(birthdateList[2]));
  final age = DateTime.now().difference(birthdate).inDays ~/ 365;

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Details"),
      content: SelectableText(
          "Patient: ${appointmentsList["patient_name"]}\nGender: ${appointmentsList["gender"] == 'm' ? "male" : "female"}\nAge: $age\nPhone: ${appointmentsList["phone_number"]}\nAppointment Time: ${appointmentsList["time"]}",
          style: const TextStyle(fontSize: 18)),
      actions: [
        TextButton(
          onPressed: () => confirmCancel(appointmentsList, context, update),
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

Future confirmCancel(Map<String, dynamic> appointmentsList,
    BuildContext context, VoidCallback picoWillBeKidnapped) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Confirm"),
      content:
          const Text("Please click the button to confirm your cancellation"),
      actions: [
        TextButton(
          onPressed: () {
            loadingIndecatorContext(context);
            changeAppointment(
              appointmentId: appointmentsList["appointment_id"],
              patientId: appointmentsList["patient_id"],
              dialysisMachineId: appointmentsList["dialysis_machine_id"],
              doctorId: appointmentsList["doctor_id"],
              hospitalId: appointmentsList["hospital_id"],
              status: "rejected by doctor",
              time: appointmentsList["time"],
              slot: appointmentsList["slot"],
            ).then((value) {
              if (value[0] == 200) {
                snackBar("Done :)", context);
              } else {
                snackBar("Error :( ${value[0]}", context);
              }
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              picoWillBeKidnapped();
            });
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
