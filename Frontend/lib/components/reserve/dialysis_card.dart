// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hemodialysis_csci305/backend/api_connection.dart';
import 'package:intl/intl.dart';
import '../../backend/shared_variables.dart';
import '../shared_components.dart';

dynamic dialysisCard(
    Map<String, dynamic> dialysisList, BuildContext context, int doctorId) {
  return Card(
    margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
    color: cardColor,
    child: Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding:
            const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
        collapsedShape: null,
        initiallyExpanded: false,
        childrenPadding:
            const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
        iconColor: Colors.black,
        textColor: Colors.black,
        title: Text(
          "Dialysis Machine ${dialysisList["dialysis_machine_id"]}",
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        subtitle: const Text(
          "Machine is availabile",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        children: [
          SelectableText(
            "Price: ${dialysisList["price"]}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          SelectableText(
            "Operation Time: ${dialysisList["time_slot"]} Minute",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 16),
            child: ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(buttonColor)),
              onPressed: () async {
                final String selectedDate;
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(
                    const Duration(days: 7),
                  ),
                );
                if (date != null) {
                  loadingIndecatorContext(context);
                  selectedDate = date.toString().split(" ")[0];
                  final result = await getDialysisMachinesTimes(
                    time: selectedDate,
                    dialysisMachineId: dialysisList["dialysis_machine_id"],
                  );
                  if (result[0] == 200) {
                    Navigator.of(context).pop();

                    final data = result[1];
                    final lastElement = data[data.length - 1];
                    int numberOfReservation = data.length - 1;
                    int numberOfSlots = lastElement[0];
                    if (numberOfSlots != numberOfReservation) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => dialysisAlert(
                            context,
                            data,
                            selectedDate,
                            dialysisList["dialysis_machine_id"],
                            dialysisList["hospital_id"],
                            doctorId),
                      );
                    } else {
                      snackBar(
                        "No available reservation on :( $selectedDate",
                        context,
                      );
                    }
                  } else {
                    snackBar("Error :( ${result[0]}", context);
                  }
                }
              },
              child: const Text(
                "Reserve",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

AlertDialog dialysisAlert(BuildContext context, dynamic data,
    String selectedDate, int machineId, int hospitalId, int doctorId) {
  final lastElement = data[data.length - 1];
  int numberOfSlots = lastElement[0];
  int startTime = lastElement[1];
  int operationTime = lastElement[2];
  DateTime startDate = DateTime(2023, 1, 1, startTime);
  final format = DateFormat.jm();
  List<String> availableAppointments = [];
  for (var i = 0; i < numberOfSlots; i++) {
    DateTime next = startDate.add(Duration(minutes: operationTime));
    if (!data.contains(i)) {
      availableAppointments.add(
        "$i- ${format.format(startDate)} to ${format.format(next)}",
      );
    }
    startDate = next;
  }
  String selectedAppointment = availableAppointments[0];

  return AlertDialog(
    scrollable: true,
    title: const Text('Select a Slot'),
    content:
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Column(
        children: [
          locationDropDown(
            title: "Available Slots",
            menu: availableAppointments,
            defaultItem: selectedAppointment,
            update: (value) {
              selectedAppointment = value;
              setState(() {});
            },
          ),
        ],
      );
    }),
    actions: [
      TextButton(
        onPressed: () async {
          print(box.get("userId"));
          print(hospitalId);
          print(doctorId);
          print(machineId);
          print(selectedDate);
          loadingIndecatorContext(context);
          final result = await makeAppointment(
              hospitalId: hospitalId,
              doctorId: doctorId,
              patientId: box.get("userId"),
              time: selectedDate,
              slot: int.parse(selectedAppointment.split('-')[0]),
              dialysisMachineId: machineId);
          if (result[0] == 200) {
            snackBar("Done :)", context);
          } else {
            snackBar("Error :( ${result[0]}", context);
          }
          Navigator.pop(context);
          Navigator.pop(context);
        },
        child: const Text('Ok'),
      ),
    ],
  );
}

Column locationDropDown<T>(
    {required String title,
    required List<T> menu,
    required Function(T value) update,
    required T defaultItem}) {
  T selectedItem = defaultItem;
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      DropdownButton<T>(
        value: selectedItem,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(
            color: Color.fromARGB(255, 9, 111, 206),
            fontSize: 16,
            fontWeight: FontWeight.w500),
        underline: Container(
          height: 2,
          color: const Color.fromARGB(255, 106, 183, 255),
        ),
        items: menu
            .map(
              (key) => DropdownMenuItem<T>(
                value: key,
                child: Text(
                  key.toString(),
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          selectedItem = value as T;
          update(value);
        },
      ),
    ],
  );
}
