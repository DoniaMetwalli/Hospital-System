import 'package:flutter/material.dart';
import 'package:hemodialysis_csci305/backend/api_connection.dart';
import 'package:hemodialysis_csci305/backend/shared_variables.dart';
import 'package:hemodialysis_csci305/pages/register_page.dart';
import '../components/login/button.dart';
import '../components/login/text_field.dart';
import '../components/shared_components.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback loged;
  const LoginPage({super.key, required this.loged});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final user = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loginTextField(
                hintText: "Your Username",
                obscureText: false,
                controller: user),
            loginTextField(
                hintText: "Your Password",
                obscureText: true,
                controller: password),
            Row(
              children: [
                Flexible(
                  child: customButton(
                      color: Colors.green[800],
                      text: "Register",
                      pressFunction: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(
                              loged: () {
                                setState(() {});
                              },
                            ),
                          ),
                        );
                      }),
                ),
                Flexible(
                  child: customButton(
                    text: "Login",
                    color: Colors.green[600],
                    longPressFunction: () async {
                      if (user.text.trim().isNotEmpty &&
                          password.text.trim().isNotEmpty) {
                        loadingIndecatorContext(context);
                        final result = await loginHospital(
                          username: user.text,
                          password: password.text,
                        );
                        if (result[0] == 200) {
                          box.put("loged", true);
                          box.put("hospitalId", result[1]["id"]);
                          box.put("hospitalName", result[1]["name"]);
                          box.put("address", result[1]["address"]);
                          box.put("city", result[1]["city"]);
                          box.put("area", result[1]["area"]);
                          box.put("email", result[1]["email"]);
                          box.put("phone", result[1]["phone_number"]);
                          box.put("isPatient", 2);

                          widget.loged();
                        } else {
                          snackBar("you are not a user", context);
                        }
                        Navigator.pop(context);
                      } else {
                        snackBar("Please fill Username/Password field. ╰（‵□′）╯",
                            context);
                      }
                    },
                    pressFunction: () async {
                      if (user.text.trim().isNotEmpty &&
                          password.text.trim().isNotEmpty) {
                        loadingIndecatorContext(context);
                        final result = await login(
                            username: user.text, password: password.text);
                        if (result[0] == 200) {
                          box.put("loged", true);
                          box.put("userId", result[1]["user_id"]);
                          box.put("firstName", result[1]["firstName"]);
                          box.put("lastName", result[1]["lastName"]);
                          box.put("email", result[1]["email"]);
                          box.put("gender", result[1]["gender"]);
                          box.put("phone", result[1]["phone_number"]);
                          if (result[1]["birthdate"] != null) {
                            box.put("birthdate", result[1]["birthdate"]);
                            box.put("isPatient", 0);
                          } else {
                            box.put("hospitalId", result[1]["hospital_id"]);
                            box.put("availability", result[1]["availability"]);
                            box.put("isPatient", 1);
                          }
                          widget.loged();
                        } else {
                          snackBar("you are not a user", context);
                        }
                        Navigator.pop(context);
                      } else {
                        snackBar("Please fill Username/Password field. ╰（‵□′）╯",
                            context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
