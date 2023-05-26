import 'package:flutter/material.dart';
import '../backend/api_connection.dart';
import '../components/shared_components.dart';

import '../backend/shared_variables.dart';
import '../components/home_page/upcoming_appoinment_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<dynamic> appointments = [];

class _HomePageState extends State<HomePage> {
  bool loading = true;
  // we turn it to a function to re use it
  // now we need to notify the home page that we changed the loading var and call backend function
  void backendCall() {
    getAppointments(patientId: box.get("userId"), status: "booked").then(
      (value) {
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
