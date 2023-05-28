import 'package:flutter/material.dart';
import '../../backend/shared_variables.dart';

dynamic dialysisCard(Map<String, dynamic> dialysisList, BuildContext context) {
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
              onPressed: () {
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
