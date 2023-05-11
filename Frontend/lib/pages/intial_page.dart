import 'package:flutter/material.dart';
import 'package:hemodialysis_csci305/backend/shared_variables.dart';
import 'package:hemodialysis_csci305/pages/home_page.dart';
import 'package:hemodialysis_csci305/pages/login_page.dart';

class IntialPage extends StatefulWidget {
  const IntialPage({super.key});

  @override
  State<IntialPage> createState() => _IntialPageState();
}

class _IntialPageState extends State<IntialPage> {
  @override
  Widget build(BuildContext context) {
    if (isLoged) {
      return HomePage();
    }
    return LoginPage(
      loged: () {
        setState(() {});
      },
    );
  }
}
