import 'package:flutter/material.dart';

import '../../backend/shared_variables.dart';
import '../../pages/select_dialysis_machine.dart';

// {firstName: tom, lastName: tommy, email: potato@tomato.com, phone_number: 01020304060, gender: m, hospital_id: 3000000, availability: true}
dynamic doctorCard(Map<String, dynamic> doctorList, BuildContext context) {
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
          "Doctor ${doctorList["firstName"]} ${doctorList["lastName"]}",
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        subtitle: const Text(
          "Doctor is availabile",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        children: [
          SelectableText(
            "Phone Number: ${doctorList["phone_number"]}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          SelectableText(
            "Email: ${doctorList["email"]}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 16),
            child: ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(buttonColor)),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelectDialysisMachine(
                      hospitalId: doctorList["hospital_id"]),
                ));
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
