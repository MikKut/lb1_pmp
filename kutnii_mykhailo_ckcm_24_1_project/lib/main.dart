import 'package:flutter/material.dart';
import 'screens/students.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StudentsScreen(),
    );
  }
}
