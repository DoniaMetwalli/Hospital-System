import 'package:flutter/material.dart';
import 'package:hemodialysis_csci305/backend/shared_variables.dart';

dynamic loginTextField({
  required TextEditingController controller,
  required String hintText,
  required bool obscureText,
  TextInputType? keyboardType,
}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
    child: TextField(
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textFieldBorderColor, width: 1.1),
            borderRadius: BorderRadius.circular(6),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: textFieldFocusBorderColor, width: 1.1),
            borderRadius: BorderRadius.circular(6),
          ),
          hintText: hintText),
    ),
  );
}

dynamic dateField({
  required TextEditingController controller,
  required String hintText,
  required bool obscureText,
  required BuildContext context,
  TextInputType? keyboardType,
}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
    child: TextField(
      readOnly: true,
      onTap: () async {
        await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100))
            .then(
          (date) {
            if (date != null) {
              controller.text = date.toString().split(" ")[0];
            }
          },
        );
      },
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textFieldBorderColor, width: 1.1),
            borderRadius: BorderRadius.circular(6),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: textFieldFocusBorderColor, width: 1.1),
            borderRadius: BorderRadius.circular(6),
          ),
          hintText: hintText),
    ),
  );
}

dynamic genderField({
  required TextEditingController controller,
  required String hintText,
  required bool obscureText,
  required BuildContext context,
  TextInputType? keyboardType,
}) {
  controller.text = controller.text == 'm' ? "Male" : "Female" ?? "Female";
  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
    child: TextField(
      readOnly: true,
      onTap: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            scrollable: true,
            title: const Text('Gender Selection'),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Gender:",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  DropdownButton<String>(
                    value: controller.text,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 9, 111, 206),
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    underline: Container(
                      height: 2,
                      color: const Color.fromARGB(255, 106, 183, 255),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "Male",
                        child: Text("Male"),
                      ),
                      DropdownMenuItem(
                        value: "Female",
                        child: Text("Female"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        controller.text = value!;
                      });
                    },
                  ),
                ],
              );
            }),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textFieldBorderColor, width: 1.1),
            borderRadius: BorderRadius.circular(6),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: textFieldFocusBorderColor, width: 1.1),
            borderRadius: BorderRadius.circular(6),
          ),
          hintText: hintText),
    ),
  );
}

dynamic availabilityField({
  required TextEditingController controller,
  required String hintText,
  required bool obscureText,
  required BuildContext context,
  TextInputType? keyboardType,
}) {
  controller.text = controller.text ?? "true";
  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
    child: TextField(
      readOnly: true,
      onTap: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            scrollable: true,
            title: const Text('Availability Selection'),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Availability:",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  DropdownButton<String>(
                    value: controller.text,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 9, 111, 206),
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    underline: Container(
                      height: 2,
                      color: const Color.fromARGB(255, 106, 183, 255),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "true",
                        child: Text("true"),
                      ),
                      DropdownMenuItem(
                        value: "false",
                        child: Text("false"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        controller.text = value!;
                      });
                    },
                  ),
                ],
              );
            }),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textFieldBorderColor, width: 1.1),
            borderRadius: BorderRadius.circular(6),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: textFieldFocusBorderColor, width: 1.1),
            borderRadius: BorderRadius.circular(6),
          ),
          hintText: hintText),
    ),
  );
}

Row textFieldLable({required String labelText}) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 10.0, bottom: 8),
        child: Text(
          labelText,
          textAlign: TextAlign.start,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    ],
  );
}
