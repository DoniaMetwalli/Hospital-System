import 'package:flutter/material.dart';

import '../../backend/shared_variables.dart';
import '../../pages/select_doctor_dart.dart';

dynamic hospitalCard(Map<String, dynamic> hospitalsList, BuildContext context) {
  return Card(
    margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
    color: cardColor,
    child: Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
        collapsedShape: null,
        initiallyExpanded: false,
        childrenPadding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
        iconColor: Colors.black,
        textColor: Colors.black,
        title: Text(
          hospitalsList["name"],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        subtitle: Text(
          hospitalsList["address"],
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        children: [
          SelectableText(
            "Hospital Phone: ${hospitalsList["phone_number"]}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          SelectableText(
            "Hospital Email: ${hospitalsList["email"]}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 16),
            child: ElevatedButton(
              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(buttonColor)),
              onPressed: () {
                // print(hospitalsList);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelectDoctorPage(hospitalId: hospitalsList["id"]),
                ));
              },
              child: const Text(
                "Reserve",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
