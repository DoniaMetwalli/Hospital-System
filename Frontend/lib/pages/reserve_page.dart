import '../backend/reservation.dart';
import 'package:flutter/material.dart';
import '../backend/api_connection.dart';
import '../components/reserve/hospital_card.dart';
import '../components/shared_components.dart';

class ReservePage extends StatefulWidget {
  const ReservePage({super.key});

  @override
  State<ReservePage> createState() => _ReservePageState();
}

class _ReservePageState extends State<ReservePage> {
  bool loading = true;

  @override
  void initState() {
    getHospitals().then(
      (value) {
        if (value[0] == 200) {
          hospitals = value[1];
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
        title: const Text("Reserve Page"),
        actions: loading
            ? []
            : [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    icon: const Icon(Icons.filter_alt),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => locationAlert(context),
                      );
                    },
                  ),
                )
              ],
      ),
      body: loading
          ? loadingIndecator()
          : ListView.builder(
              itemCount: hospitalsCount(filter),
              itemBuilder: (context, index) {
                return hospitalCard(filteredHospitals[index], context);
              },
            ),
    );
  }

  Column locationDropDown<T>(
      {required String title,
      required List<T> menu,
      required Function(T value) update,
      required T defaultItem}) {
    T selectedItem = defaultItem;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        DropdownButton<T>(
          value: selectedItem,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(
              color: Color.fromARGB(255, 9, 111, 206), fontSize: 16, fontWeight: FontWeight.w500),
          underline: Container(
            height: 2,
            color: const Color.fromARGB(255, 106, 183, 255),
          ),
          items: menu
              .map(
                (key) => DropdownMenuItem<T>(
                  value: key,
                  child: Text(
                    key.toString(),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            selectedItem = value as T;
            update(value);
          },
        ),
      ],
    );
  }

  AlertDialog locationAlert(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Location filter'),
      content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Column(
          children: [
            locationDropDown(
              title: "Governorate",
              menu: cities.keys.toList(),
              defaultItem: selectedGovernorate,
              update: (value) {
                selectedGovernorate = value;
                selectedCity = cities[selectedGovernorate]![0];
                setState(() {});
              },
            ),
            locationDropDown(
              title: "City",
              menu: cities[selectedGovernorate]!,
              defaultItem: selectedCity,
              update: (value) {
                setState(() => selectedCity = value);
              },
            ),
          ],
        );
      }),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              filter = [selectedGovernorate, selectedCity];
            });
            Navigator.pop(context);
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
