import 'package:flutter/material.dart';
import 'package:hemodialysis_csci305/backend/api_connection.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../components/login/button.dart';
import '../../components/login/text_field.dart';
import '../components/shared_components.dart';

class AddDialysisMachine extends StatefulWidget {
  const AddDialysisMachine({super.key});

  @override
  State<AddDialysisMachine> createState() => _AddDialysisMachineState();
}

class _AddDialysisMachineState extends State<AddDialysisMachine> {
  final startTime = TextEditingController();
  final opertationTime = TextEditingController();
  final workingSlots = TextEditingController();
  final price = TextEditingController();
  final box = Hive.box("user");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                loginTextField(
                  hintText: "Start Time",
                  obscureText: false,
                  controller: startTime,
                  keyboardType: TextInputType.number,
                ),
                loginTextField(
                  hintText: "Opertation Time",
                  obscureText: false,
                  controller: opertationTime,
                  keyboardType: TextInputType.number,
                ),
                loginTextField(
                  hintText: "Working Slots Number",
                  obscureText: false,
                  controller: workingSlots,
                  keyboardType: TextInputType.number,
                ),
                loginTextField(
                    hintText: "Price",
                    obscureText: false,
                    controller: price,
                    keyboardType: TextInputType.number),
                Row(
                  children: [
                    Flexible(
                      child: customButton(
                        text: "Register",
                        color: Colors.green[600],
                        pressFunction: () async {
                          if (price.text.isNotEmpty &&
                              workingSlots.text.isNotEmpty &&
                              opertationTime.text.isNotEmpty &&
                              startTime.text.isNotEmpty) {
                            loadingIndecatorContext(context);
                            final result = await addDialysisMachine(
                              price: int.parse(price.text),
                              slotCount: int.parse(workingSlots.text),
                              startTime: int.parse(startTime.text),
                              timeSlot: int.parse(opertationTime.text),
                              hospitalId: 3000000,
                            );
                            if (result[0] == 200) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              snackBar("Done :)", context);
                            } else {
                              snackBar(
                                  "Try again, Error ${result[0]}", context);
                              Navigator.pop(context);
                            }
                          } else {
                            snackBar("Fill Password/Email Field", context);
                          }
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
