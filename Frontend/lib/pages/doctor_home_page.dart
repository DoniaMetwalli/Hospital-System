import 'package:flutter/material.dart';
import '../backend/api_connection.dart';
import '../components/shared_components.dart';

import '../backend/shared_variables.dart';
import '../components/doctor_home_page/upcoming_appoinment_card.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({super.key});

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

List<dynamic> appointments = [];

class _DoctorHomePageState extends State<DoctorHomePage> {
  bool loading = true;
  void backendCall() {
    getDoctorAppointments(
      doctorId: box.get("userId"),
    ).then(
      (value) {
        print(value);
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
        title: const Text("Upcoming D Appointments"),
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
                    // we will create our function here
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
