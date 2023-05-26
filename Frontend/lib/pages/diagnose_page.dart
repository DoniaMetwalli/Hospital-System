import 'package:hemodialysis_csci305/components/home_page/upcoming_appoinment_card.dart';

import '../backend/reservation.dart';
import 'package:flutter/material.dart';
import '../backend/api_connection.dart';
import '../backend/shared_variables.dart';
import '../components/shared_components.dart';
import 'add_diagnosis_card.dart';

class DiagnosisPage extends StatefulWidget {
  const DiagnosisPage({super.key});

  @override
  State<DiagnosisPage> createState() => DiagnosisPageState();
}

List<dynamic> docAppointments = [];

class DiagnosisPageState extends State<DiagnosisPage> 
{
  bool loading = true;

  void backendCall() {
    getAppointments(patientId: box.get("userId"), status: "booked").then(
      (value) {
        if (value[0] == 200) {
          docAppointments = value[1];
          setState(
            () {
              loading = false;
            },
          );
        }
      },
    );
  }

  @override
  void initState() {
    backendCall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Diagnosis"),
      ),
      body: loading ? 
        loadingIndecator():
        docAppointments.isEmpty ? 
        const Center(
                  child: Text(
                    "Have a Nice Day :)\nThere is no upcomming Appointments",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                )
                : 
              ListView.builder(itemCount: docAppointments.length, 
                              itemBuilder: (context, index) {
                                return addDiagnosis(
                                  docAppointments[index], 
                                  context, 
                                  () { setState(() {
                                    loading = true;
                                    backendCall(); });
                                    },
                                    );
                                    },
              )
    );
  }

}