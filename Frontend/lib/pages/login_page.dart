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
        backgroundColor: Colors.grey.shade50,
        resizeToAvoidBottomInset: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loginTextField(hintText: "Your Username", obscureText: false, controller: user),
            loginTextField(hintText: "Your Password", obscureText: true, controller: password),
            Row(
              children: [
                Flexible(
                  child: customButton(
                      color: const Color.fromARGB(255, 45, 130, 199),
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
                    color: const Color.fromARGB(255, 39, 187, 255),
                    pressFunction: () async {
                      if (user.text.trim().isNotEmpty && password.text.trim().isNotEmpty) {
                        loadingIndecatorContext(context);
                        final result = await login(username: user.text, password: password.text);
                        if (result[0] == 200) {
// flutter: [200, {user_id: 1000006, firstName: kasld, lastName: daklsm, email: kladsm, phone_number: 789, birthdate: 2023-05-16, gender: f}]

                          box.put("userId", result[1]["user_id"]);
                          box.put("firstName", result[1]["firstName"]);
                          box.put("lastName",result[1]["lastName"] );
                          box.put("email",result[1]["email"] );
                          // ToDo As I am lazy or sleepy now :(
                          // box.put("gemder", );
                          // box.put("phone", );
                          // box.put("birthdate", );
                          print(result);
                          widget.loged();
                        } else {
                          snackBar("you are not a user", context);
                        }
                        Navigator.pop(context);
                      } else {
                        snackBar("Please fill Username/Password field. ╰（‵□′）╯", context);
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
