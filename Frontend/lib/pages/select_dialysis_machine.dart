import 'package:flutter/material.dart';
import 'package:hemodialysis_csci305/backend/api_connection.dart';
import 'package:hemodialysis_csci305/components/reserve/dialysis_cart.dart';

import '../components/shared_components.dart';

class SelectDialysisMachine extends StatefulWidget {
  final int hospitalId;
  const SelectDialysisMachine({super.key, required this.hospitalId});

  @override
  State<SelectDialysisMachine> createState() => _SelectDialysisMachineState();
}

class _SelectDialysisMachineState extends State<SelectDialysisMachine> {
  bool loading = true;
  List<dynamic> dialysisMachine = [];
  @override
  void initState() {
    getDialysisMachines(hospitalId: widget.hospitalId).then(
      (value) {
        print(value);
        if (value[0] == 200) {
          dialysisMachine = value[1];
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
        title: const Text("Select a Dialysis Machine"),
      ),
      body: loading
          ? loadingIndecator()
          : ListView.builder(
              itemCount: dialysisMachine.length,
              itemBuilder: (context, index) {
                return dialysisCard(dialysisMachine[index], context);
              },
            ),
    );
  }
}
