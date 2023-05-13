import 'package:flutter/material.dart';

import '../../backend/shared_variables.dart';

Card upcomingAppoinmentCard(BuildContext context) {
  return Card(
    color: cardColor,
    margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
    child: ListTile(
      contentPadding:
          const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
      title: const Text(
        "Hospital Name",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: const Text("Doctor's Name \nDate",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          )),
      isThreeLine: true,
      onTap: () => upcomingAppoinmentAlert(context),
    ),
  );
}

Future<dynamic> upcomingAppoinmentAlert(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("DEETS"),
      actions: [
        TextButton(
          onPressed: () => close(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => close(context),
          child: const Text("Okay / Done"),
        ),
      ],
    ),
  );
}

void close(BuildContext context) {
  Navigator.of(context).pop();
}
