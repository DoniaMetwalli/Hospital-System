import 'package:flutter/material.dart';
import 'package:hemodialysis_csci305/backend/api_connection.dart';
import 'package:hemodialysis_csci305/pages/home_page.dart';
import 'package:hemodialysis_csci305/pages/intial_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../components/login/button.dart';
import '../../components/login/text_field.dart';
import '../components/shared_components.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback loged;

  const RegisterPage({super.key, required this.loged});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final birthdate = TextEditingController();
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
        backgroundColor: Colors.grey.shade50,
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
                dateField(
                    controller: birthdate,
                    hintText: "Your Birthdate",
                    obscureText: false,
                    context: context),
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
                          pressFunction: () {
                            Navigator.of(context).pop();
                          },
                          text: "Registered?",
                          color: const Color.fromARGB(255, 45, 130, 199)),
                    ),
                    Flexible(
                      child: customButton(
                        text: "Register",
                        color: const Color.fromARGB(255, 39, 187, 255),
                        pressFunction: () async {
                          if (password.text.isNotEmpty &&
                              email.text.isNotEmpty &&
                              firstName.text.isNotEmpty &&
                              lastName.text.isNotEmpty &&
                              phoneNumber.text.isNotEmpty &&
                              birthdate.text.isNotEmpty &&
                              username.text.isNotEmpty &&
                              password.text.isNotEmpty &&
                              passwordConfirmation.text.isNotEmpty) {
                            if (password.text == passwordConfirmation.text) {
                              loadingIndecatorContext(context);
                              final result = await signup(
                                firstName: firstName.text,
                                birthdate: birthdate.text,
                                email: email.text,
                                lastName: lastName.text,
                                phoneNumber: phoneNumber.text,
                                username: username.text,
                                password: password.text,
                                gender: gender.text[0].toLowerCase(),
                              );
                              if (result[0] == 200) {
                                box.put("userId", result[1]);
                                box.put("loged", true);
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) => const IntialPage()),
                                    (Route<dynamic> route) => false);
                              } else {
                                snackBar("Try again, Error ${result[0]}", context);
                                Navigator.pop(context);
                              }
                            } else {
                              snackBar(
                                  "Password and Password Confirmation are not the same", context);
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
