import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../pages/intial_page.dart';
import 'backend/shared_variables.dart';

void main() async {
  await Hive.initFlutter();
  final box = await Hive.openBox("patient");

//  Output : [200, {user_id: 1000002, firstName: sesame, lastName: 1, email: sesame1@potato.com, phone_number: 01020304060, birthdate: 2021-01-17, gender: m}]
  for (var key in stringKeys) {
    box.put(key, "");
  }
  for (var key in boolKeys) {
    box.put(key, false);
  }
  for (var key in intKeys) {
    box.put(key, 0);
  }

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
