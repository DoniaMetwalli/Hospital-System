import 'package:flutter/material.dart';

bool isLoged = true;

const iconColor = Color.fromARGB(255, 101, 172, 137);
const backgroundColor = Color.fromARGB(255, 218, 233, 218);
const cardColor = Color.fromARGB(255, 125, 206, 167);

List<List<double>> fontSize = [
  [8, 16],
  [16, 24]
];
//  Output : [200, {user_id: 1000002, firstName: sesame, lastName: 1, email: sesame1@potato.com, phone_number: 01020304060, birthdate: 2021-01-17, gender: m}]

List<String> stringKeys = ["firstName", "lastName"];
List<String> intKeys = ["userId"];
List<String> boolKeys = ["loged"];
