import 'package:flutter/material.dart';
import '../backend/shared_variables.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/reserve_page.dart';
import '../pages/settings.dart';

class IntialPage extends StatefulWidget {
  const IntialPage({super.key});

  @override
  State<IntialPage> createState() => _IntialPageState();
}

int selectedPage = 0;
List<Widget> pages = const [HomePage(), ReservePage(), Settings()];

class _IntialPageState extends State<IntialPage> {
  @override
  Widget build(BuildContext context) {
    if (isLoged) {
      return Scaffold(
        body: pages[selectedPage],
        bottomNavigationBar: NavigationBar(
          destinations: [
            NavigationDestination(
                icon: Icon(Icons.home, color: Colors.lightBlue[700]), label: "Home"),
            NavigationDestination(
                icon: Icon(Icons.schedule, color: Colors.lightBlue[700]), label: "Reserve"),
            NavigationDestination(
                icon: Icon(Icons.settings, color: Colors.lightBlue[700]), label: "Settings"),
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
