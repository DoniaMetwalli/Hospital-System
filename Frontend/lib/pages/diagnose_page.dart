import '../backend/reservation.dart';
import 'package:flutter/material.dart';
import '../backend/api_connection.dart';
import '../components/shared_components.dart';

class DiagnosisPage extends StatefulWidget {
  const DiagnosisPage({super.key});

  @override
  State<DiagnosisPage> createState() => DiagnosisPageState();
}

class DiagnosisPageState extends State<DiagnosisPage> 
{
  bool loading = true;

  @override
    void initState() {
      
      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return loading ?
     loadingIndecator():
     Scaffold(
      //appBar:
     );
  }

}