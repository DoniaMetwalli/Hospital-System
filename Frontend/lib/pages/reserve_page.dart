import 'package:flutter/material.dart';
import 'package:hemodialysis_csci305/components/shared_components.dart';

class ReservePage extends StatefulWidget {
  const ReservePage({super.key});

  @override
  State<ReservePage> createState() => _ReservePageState();
}

String filter = "";
List<List<String>> hospitals = [
  ["Hospital A", "Cairo - Nasr City"],
  ["Hospital B", "Cairo - Nasr City"],
  ["Hospital C", "Giza - 6 Octobor"],
  ["Hospital D", "Giza - 6 Octobor"],
];

int hospitalsCount(String filter) {
  int count = 0;
  if (filter.isNotEmpty) {
    for (var element in hospitals) {
      if (element[1] == filter) count++;
    }
    return count;
  }
  return hospitals.length;
}

String selectedState = "Cairo";
String selectedCity = "";
List<String> states = ["Cairo", "Giza"];
Map<String, String> city = {"Cairo": "Nasr City", "Giza": "6 Octobor"};

class _ReservePageState extends State<ReservePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reserve Page"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.filter_alt),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    scrollable: true,
                    title: const Text('Developed by:'),
                    content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "State",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          DropdownButton<String>(
                            value: selectedState,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 9, 111, 206),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            underline: Container(
                              height: 2,
                              color: const Color.fromARGB(255, 106, 183, 255),
                            ),
                            items: [
                              DropdownMenuItem(
                                child: Text("Cairo"),
                                value: "Cairo",
                              ),
                              DropdownMenuItem(
                                child: Text("Giza"),
                                value: "Giza",
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedState = value!;
                              });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "City",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          DropdownButton<String>(
                            value: selectedCity,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 9, 111, 206),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                            underline: Container(
                              height: 2,
                              color: const Color.fromARGB(255, 106, 183, 255),
                            ),
                            items: [
                              DropdownMenuItem(
                                child: Text(""),
                                value: "",
                              ),
                              selectedState == "Cairo"
                                  ? DropdownMenuItem(
                                      child: Text("Nasr City"),
                                      value: "Nasr City",
                                    )
                                  : DropdownMenuItem(
                                      child: Text("6 Octobor"),
                                      value: "6 Octobor",
                                    )
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedCity = value!;
                              });
                            },
                          )
                        ],
                      );
                    }),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: hospitalsCount(filter),
        itemBuilder: (context, index) {
          return hospitalCard(hospitals[index][0], hospitals[index][1]);
        },
      ),
    );
  }
}
