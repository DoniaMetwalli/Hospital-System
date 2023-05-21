import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../backend/shared_variables.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/reserve_page.dart';
import 'settings_page.dart';

class IntialPage extends StatefulWidget {
  const IntialPage({super.key});

  @override
  State<IntialPage> createState() => _IntialPageState();
}

int selectedPage = 0;

List<Widget> pages = const [
  HomePage(),
  ReservePage(),
  Settings(),
];

class _IntialPageState extends State<IntialPage> {
  @override
  Widget build(BuildContext context) {
    final box = Hive.box("user");
    if (box.get("loged")) {
      return Scaffold(
        body: pages[selectedPage],
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home, color: iconColor), label: "Home"),
            NavigationDestination(icon: Icon(Icons.schedule, color: iconColor), label: "Reserve"),
            NavigationDestination(icon: Icon(Icons.settings, color: iconColor), label: "Settings"),
          ],
          onDestinationSelected: (index) {
            setState(() {
              selectedPage = index;
            });
          },
          selectedIndex: selectedPage,
        ),
      );
    }
    return LoginPage(
      loged: () {
        setState(() {});
      },
    );
  }
}
