import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  get tapCallback => null;

  @override
  Widget build(BuildContext context) {
    
    Future openDetails() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("DEETS"),
        actions: [
          TextButton(onPressed: close , child: const Text("Okay / Done"))
        ],
      ));

    return Scaffold(
      appBar: AppBar
      (
        title: const Text("Upcoming Appointments"),
        backgroundColor: const Color.fromARGB(255, 192, 214, 192),
      ),
      backgroundColor: const Color.fromARGB(255, 192, 214, 192),
      body: ListView(children: [
        Card(
          color: const Color.fromARGB(255, 125, 206, 167),
          child: ListTile(
            title: const Text("Hospital Name", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500,),), 
            subtitle: const Text("Doctor's Name \nDate", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400,)),
            isThreeLine: true,
            onTap: () {openDetails();},
        ),
        
        )
      ]),
    );

  }

  void close() 
  {
    Navigator.of(context).pop();
  }
}
