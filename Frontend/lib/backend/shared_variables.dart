import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

final box = Hive.box("user");
bool isPatient = true;

const iconColor = Color.fromARGB(255, 101, 172, 137);
const backgroundColor = Color.fromARGB(255, 218, 233, 218);
const cardColor = Color.fromARGB(255, 125, 206, 167);
bool homeLoading = true;

List<List<double>> fontSize = [
  [8, 16],
  [16, 24]
];

List<String> stringKeys = [
  "firstName",
  "lastName",
  "email",
  "gender",
  "phone",
  "birthdate",
  "hospitalId",
];
List<String> intKeys = [
  "userId",
];
List<String> boolKeys = [
  "loged",
  "availability",
];

