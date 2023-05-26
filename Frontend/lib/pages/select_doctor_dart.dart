import 'package:flutter/material.dart';

import '../backend/api_connection.dart';
import '../components/reserve/doctor_card.dart';
import '../components/shared_components.dart';

class SelectDoctorPage extends StatefulWidget {
  final int hospitalId;
  const SelectDoctorPage({
    required this.hospitalId,
    super.key,
  });

  @override
  State<SelectDoctorPage> createState() => _SelectDoctorPageState();
}

class _SelectDoctorPageState extends State<SelectDoctorPage> {
  bool loading = true;
  List<dynamic> doctors = [];
  @override
  void initState() {
    getDoctors(hospitalId: widget.hospitalId).then(
      (value) {
        if (value[0] == 200) {
          doctors = value[1];
          setState(() {
            loading = false;
          });
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select a Doctor"),
      ),
      body: loading
          ? loadingIndecator()
          : ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                return doctorCard(doctors[index], context);
              },
            ),
    );
  }
}
