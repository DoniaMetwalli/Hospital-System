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
            LoginTextField(hintText: "Your Username", obscureText: false, controller: user),
            LoginTextField(hintText: "Your Password", obscureText: true, controller: password),
            Row(
              children: [
                Flexible(
                  child: CustomButton(
                      color: const Color.fromARGB(255, 45, 130, 199),
                      text: "Register",
                      pressFunction: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      }),
                ),
                Flexible(
                  child: CustomButton(
                    text: "Login",
                    color: const Color.fromARGB(255, 39, 187, 255),
                    pressFunction: () async {
                      if (user.text.trim().isNotEmpty && password.text.trim().isNotEmpty) {
                        loadingIndecator();
                        final result = await login(username: user.text, password: password.text);
                        //  Output : [200, {user_id: 1000002, firstName: sesame, lastName: 1, email: sesame1@potato.com, phone_number: 01020304060, birthdate: 2021-01-17, gender: m}]
                        print(result);
                        if (result[0] == 200) {
                          isLoged = true;
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
