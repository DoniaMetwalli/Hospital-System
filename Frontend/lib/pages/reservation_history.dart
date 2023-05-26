import 'package:flutter/material.dart';

import '../backend/api_connection.dart';
import '../backend/shared_variables.dart';
import '../components/patient_home_page/upcoming_appoinment_card.dart';
import '../components/shared_components.dart';

class ReservationHistoryPage extends StatefulWidget {
  const ReservationHistoryPage({super.key});

  @override
  State<ReservationHistoryPage> createState() => _ReservationHistoryPageState();
}

List<dynamic> appointments = [];

bool loading = true;

class _ReservationHistoryPageState extends State<ReservationHistoryPage> {
  @override
  void initState() {
    getAppointments(patientId: box.get("userId")).then((value) {
      if (value[0] == 200) {
        appointments = value[1];
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
        title: const Text("Reservation History"),
      ),
      body: loading
          ? loadingIndecator()
          : appointments.isEmpty
              ? const Center(
                  child: Text(
                    "Have a Nice Day :)\nThere is nothing to display",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    return upcomingAppoinmentCard(appointments[index], context, () {});
                  },
                ),
    );
  }
}
