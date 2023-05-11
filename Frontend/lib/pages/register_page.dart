import 'package:flutter/material.dart';
import '../components/login/button.dart';
import '../../components/login/text_field.dart';
import '../components/shared_components.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final email = TextEditingController();

  final password = TextEditingController();

  final passwordConfirmation = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey.shade50,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoginTextField(hintText: "Your Email", obscureText: false, controller: email),
            LoginTextField(hintText: "Your Password", obscureText: true, controller: password),
            LoginTextField(
                hintText: "Re-enter Your Password",
                obscureText: true,
                controller: passwordConfirmation),
            Row(
              children: [
                Flexible(
                  child: CustomButton(
                      pressFunction: () {
                        Navigator.of(context).pop();
                      },
                      text: "Registered?",
                      color: const Color.fromARGB(255, 45, 130, 199)),
                ),
                Flexible(
                  child: CustomButton(
                    text: "Register",
                    color: const Color.fromARGB(255, 39, 187, 255),
                    pressFunction: () {
                      if (password.text.isNotEmpty && email.text.isNotEmpty) {
                        if (password.text == passwordConfirmation.text) {
                          snackBar("wow", context);
                          // register();
                        } else {
                          snackBar("Password and Password Confirmation are not the same", context);
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
    );
  }
}
