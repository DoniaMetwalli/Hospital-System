import 'dart:js';

import 'package:flutter/material.dart';
import 'package:hemodialysis_csci305/pages/home_page.dart';

import '../../backend/shared_variables.dart';

Card upcomingAppoinmentCard(Map<String, dynamic> appointmentsList,BuildContext context) {
  return Card(
    color: cardColor,
    margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
    child: ListTile(
      contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
      title: Text(
        "${appointmentsList["hospital_id"]}",
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text("${appointmentsList["doctor_id"]}\n ${appointmentsList["time"]}",
          style: const TextStyle(
            // fontSize: 8,
            fontWeight: FontWeight.w400,
          )),
      isThreeLine: true,
      onTap: () => upcomingAppoinmentAlert(appointmentsList,context),
    ),
  );
}

Future<dynamic> upcomingAppoinmentAlert(Map<String, dynamic> appointmentsList,BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Details"),
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
