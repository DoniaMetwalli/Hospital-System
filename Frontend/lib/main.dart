import 'package:flutter/material.dart';
import '../pages/intial_page.dart';
import 'backend/shared_variables.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(backgroundColor: backgroundColor),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 192, 214, 192),
        ),
        useMaterial3: true,
      ),
      home: const IntialPage(),
    );
  }
}
