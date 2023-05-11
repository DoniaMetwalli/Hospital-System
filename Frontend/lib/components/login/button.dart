import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final String text;
  final VoidCallback pressFunction;
  const CustomButton(
      {super.key, required this.color, required this.text, required this.pressFunction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pressFunction,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 15),
        child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.all(15),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            )),
      ),
    );
  }
}
