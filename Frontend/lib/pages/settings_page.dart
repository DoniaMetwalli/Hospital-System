import 'package:flutter/material.dart';
import 'package:hemodialysis_csci305/pages/add_dialysis.dart';
import 'package:hemodialysis_csci305/pages/add_doctor.dart';
import 'package:hemodialysis_csci305/pages/edit_profile.dart';
import 'package:hemodialysis_csci305/pages/medical_history.dart';
import 'package:hemodialysis_csci305/pages/reservation_history.dart';
import '../backend/shared_variables.dart';
import '../components/shared_components.dart';
import 'login_page.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (box.get("isPatient") == 2)
              AboutUsButton(
                text: "Add Doctor",
                icon: Icons.person_add,
                pressFunction: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddDoctor(),
                  ));
                },
              ),
            if (box.get("isPatient") == 2)
              AboutUsButton(
                text: "Add Diaylsis Machine",
                icon: Icons.add_to_queue_rounded,
                pressFunction: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddDialysisMachine(),
                  ));
                },
              ),
            if (box.get("isPatient") == 2)
              AboutUsButton(
                text: "Reports",
                icon: Icons.receipt_rounded,
                pressFunction: () {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //   builder: (context) => const AddDialysisMachine(),
                  // ));
                },
              ),
            AboutUsButton(
              text: "Edit Profile",
              icon: Icons.edit_document,
              pressFunction: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const EditProfile(),
                ));
              },
            ),
            AboutUsButton(
              text: "Reservation History",
              icon: Icons.history,
              pressFunction: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ReservationHistoryPage(),
                ));
              },
            ),
            if (box.get("isPatient") == 0)
              AboutUsButton(
                text: "Medical History",
                icon: Icons.medical_information,
                pressFunction: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MedicalHistoryPage(),
                  ));
                },
              ),
            AboutUsButton(
              text: "Contact Us",
              icon: Icons.mail,
              pressFunction: () {},
            ),
            AboutUsButton(
              text: "Devs",
              icon: Icons.code,
              pressFunction: () => showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Developed by:'),
                  content: const Text('Wonderful devs :)'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            ),
            AboutUsButton(
              text: "Version",
              icon: Icons.info,
              pressFunction: () {
                snackBar("Beta 1", context);
              },
            ),
            box.get("loged")
                ? AboutUsButton(
                    text: "Logout",
                    icon: Icons.logout,
                    pressFunction: () {
                      logout(context);
                    },
                  )
                : AboutUsButton(
                    text: "Login",
                    icon: Icons.login,
                    pressFunction: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => LoginPage(
                              loged: () {},
                            ),
                          ),
                          (Route<dynamic> route) => false);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
