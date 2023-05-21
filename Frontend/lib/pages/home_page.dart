import 'package:flutter/material.dart';
import 'package:hemodialysis_csci305/backend/api_connection.dart';
import 'package:hemodialysis_csci305/components/shared_components.dart';

import '../components/home_page/upcoming_appoinment_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List <dynamic> appointments = [];

class _HomePageState extends State<HomePage> {

bool loading = true;

@override
  void initState() {
    getAppointments(isFullFilled: false, patientId: 1000000).then(
      (value) {
        if (value[0] == 200)
        {
          appointments = value[1];
          setState(() {
            loading = false;
          });
        }
      }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading 
    ? loadingIndecator()
    : Scaffold(
      appBar: AppBar(
        title: const Text("Upcoming Appointments"),
      ),
      body: ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                print(appointments[0]);
                // return Text("test");
              return upcomingAppoinmentCard(appointments[index],context);
              },
            ),
    );
  }
}
