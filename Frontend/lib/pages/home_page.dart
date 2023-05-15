import 'package:flutter/material.dart';

import '../components/home_page/upcoming_appoinment_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upcoming Appointments"),
      ),
      body: ListView(children: [
        upcomingAppoinmentCard(context),
      ]),
    );
  }
}
