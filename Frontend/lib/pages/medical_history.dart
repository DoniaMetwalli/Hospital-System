import 'package:flutter/material.dart';
import 'package:hemodialysis_csci305/components/medical_history/medical_record.dart';
import '../backend/api_connection.dart';
import '../components/shared_components.dart';

import '../backend/shared_variables.dart';

class MedicalHistoryPage extends StatefulWidget {
  const MedicalHistoryPage({super.key});

  @override
  State<MedicalHistoryPage> createState() => _MedicalHistoryState();
}

List<dynamic> medicalRecord = [];

class _MedicalHistoryState extends State<MedicalHistoryPage> {
  bool loading = true;

  @override
  void initState() {
    getMedicalRecord(patientId: box.get("userId")).then((value) {
      if (value[0] == 200) {
        medicalRecord = value[1];
        setState(() {
          loading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medical History"),
      ),
      body: loading
          ? loadingIndecator()
          : medicalRecord.isEmpty
              ? const Center(
                  child: Text(
                    "Have a Nice Day :)\nThere is noting to display",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  itemCount: medicalRecord.length,
                  itemBuilder: (context, index) {
                    return medicalRecordCard(medicalRecord[index], context);
                  },
                ),
    );
  }
}
