import 'package:flutter/material.dart';

import '../backend/api_connection.dart';
import '../backend/shared_variables.dart';
import '../components/hospital_home_page/upcoming_appoinment_card.dart';
import '../components/shared_components.dart';

class HospitalHomePage extends StatefulWidget {
  const HospitalHomePage({super.key});

  @override
  State<HospitalHomePage> createState() => _HospitalHomePageState();
}

List<dynamic> appointments = [];

class _HospitalHomePageState extends State<HospitalHomePage> {
  bool loading = true;

  void backendCall() {
    print(box.get("hospitalId"));
    getHospitalAppointments(
      status: "booked",
      hospitalId: box.get("hospitalId"),
    ).then(
      (value) {
        print(box.get("hospitalId"));
        if (value[0] == 200) {
          appointments = value[1];
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
        title: const Text("Upcoming Appointments"),
      ),
      body: loading
          ? loadingIndecator()
          : appointments.isEmpty
              ? const Center(
                  child: Text(
                    "Have a Nice Day :)\nThere is no upcomming Appointments",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    return upcomingAppoinmentCard(
                      appointments[index],
                      context,
                      () {
                        setState(() {
                          loading = true;
                          backendCall();
                        });
                      },
                    );
                  },
                ),
    );
  }
}
