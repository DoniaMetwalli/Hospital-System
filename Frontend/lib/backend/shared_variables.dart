import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

final box = Hive.box("user");

const iconColor = Color.fromARGB(255, 101, 172, 137);
const backgroundColor = Color.fromARGB(255, 218, 233, 218);
const cardColor = Color.fromARGB(255, 125, 206, 167);

List<List<double>> fontSize = [
  [8, 16],
  [16, 24]
];

List<String> stringKeys = ["firstName", "lastName", "email"];
List<String> intKeys = ["userId"];
List<String> boolKeys = ["loged"];
