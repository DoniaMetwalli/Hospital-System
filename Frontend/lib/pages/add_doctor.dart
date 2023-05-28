import 'package:flutter/material.dart';
import 'package:hemodialysis_csci305/backend/api_connection.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../components/login/button.dart';
import '../../components/login/text_field.dart';
import '../components/shared_components.dart';

class AddDoctor extends StatefulWidget {
  const AddDoctor({super.key});

  @override
  State<AddDoctor> createState() => _AddDoctorState();
}

class _AddDoctorState extends State<AddDoctor> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final passwordConfirmation = TextEditingController();
  final gender = TextEditingController();
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
                  hintText: "Your First Name",
                  obscureText: false,
                  controller: firstName,
                  keyboardType: TextInputType.name,
                ),
                loginTextField(
                  hintText: "Your Last Name",
                  obscureText: false,
                  controller: lastName,
                  keyboardType: TextInputType.name,
                ),
                loginTextField(
                  hintText: "Your Email",
                  obscureText: false,
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                ),
                loginTextField(
                    hintText: "Your Phone Number",
                    obscureText: false,
                    controller: phoneNumber,
                    keyboardType: TextInputType.phone),
                genderField(
                    controller: gender,
                    hintText: "Your Gender",
                    obscureText: false,
                    context: context),
                loginTextField(
                  hintText: "Your Username",
                  obscureText: false,
                  controller: username,
                  keyboardType: TextInputType.name,
                ),
                loginTextField(
                  hintText: "Your Password",
                  obscureText: true,
                  controller: password,
                  keyboardType: TextInputType.name,
                ),
                loginTextField(
                  hintText: "Re-enter Your Password",
                  obscureText: true,
                  controller: passwordConfirmation,
                  keyboardType: TextInputType.name,
                ),
                Row(
                  children: [
                    Flexible(
                      child: customButton(
                        text: "Register",
                        color: Colors.green[600],
                        pressFunction: () async {
                          if (password.text.isNotEmpty &&
                              email.text.isNotEmpty &&
                              firstName.text.isNotEmpty &&
                              lastName.text.isNotEmpty &&
                              phoneNumber.text.isNotEmpty &&
                              username.text.isNotEmpty &&
                              password.text.isNotEmpty &&
                              passwordConfirmation.text.isNotEmpty) {
                            if (password.text == passwordConfirmation.text) {
                              loadingIndecatorContext(context);
                              final result = await addDoctor(
                                firstName: firstName.text,
                                hospitalId: box.get("userId"),
                                email: email.text,
                                lastName: lastName.text,
                                phoneNumber: phoneNumber.text,
                                username: username.text,
                                password: password.text,
                                gender: gender.text[0].toLowerCase(),
                              );

                              if (result[0] == 200) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                snackBar("Done :)", context);
                              } else {
                                Navigator.of(context).pop();
                                snackBar(
                                    "Try again, Error ${result[0]}", context);
                              }
                            } else {
                              snackBar(
                                  "Password and Password Confirmation are not the same",
                                  context);
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
