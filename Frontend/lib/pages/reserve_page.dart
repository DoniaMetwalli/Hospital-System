import 'package:flutter/material.dart';
import 'package:hemodialysis_csci305/components/shared_components.dart';

class ReservePage extends StatefulWidget {
  const ReservePage({super.key});

  @override
  State<ReservePage> createState() => _ReservePageState();
}

String filter = "";

List<List<String>> hospitalList = [
  ["Hospital A", "Cairo - Nasr City"],
  ["Hospital B", "Cairo - Nasr City"],
  ["Hospital C", "Giza - 6 Octobor"],
  ["Hospital D", "Giza - 6 Octobor"],
];
List<List<String>> hospitals = [];

int hospitalsCount(String filter) {
  hospitals = [];
  int count = 0;
  if (filter.isNotEmpty) {
    for (var element in hospitalList) {
      if (element[1] == filter) {
        count++;
        hospitals.add(element);
      }
    }
    return count;
  }
  hospitals = hospitalList;
  return hospitalList.length;
}

String selectedState = "Cairo";
String selectedCity = cities["Cairo"]![0];
Map<String, List<String>> cities = {
  "Cairo": ["Nasr City", "Abbassia "],
  "Giza": ["6 Octobor", "Faisal"]
};

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
                    title: const Text('Location filter'),
                    content: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
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
                            items: const [
                              DropdownMenuItem(
                                value: "Cairo",
                                child: Text("Cairo"),
                              ),
                              DropdownMenuItem(
                                value: "Giza",
                                child: Text("Giza"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedState = value!;
                                selectedCity = cities[selectedState]![0];
                              });
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "City",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          DropdownButton<String>(
                            value: cities[selectedState]![0],
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
                            items: cities[selectedState]!
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
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
                          setState(() {
                            filter = "$selectedState - $selectedCity";
                          });
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
