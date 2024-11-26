import 'package:flutter/material.dart';
import '../models/student.dart';
import '../widgets/student_item.dart';

class StudentsScreen extends StatelessWidget {
  final List<Student> students = [
    Student(
      firstName: 'John',
      lastName: 'Dow',
      department: Department.it,
      grade: 5,
      gender: Gender.male,
    ),
    Student(
      firstName: 'Alice',
      lastName: 'Cooper',
      department: Department.finance,
      grade: 3,
      gender: Gender.female,
    ),
    Student(
      firstName: 'Cassie',
      lastName: 'Williams',
      department: Department.medical,
      grade: 5,
      gender: Gender.female,
    ),
    Student(
      firstName: 'Johnny',
      lastName: 'Depp',
      department: Department.law,
      grade: 8,
      gender: Gender.male,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students'),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (ctx, index) {
          return StudentItem(student: students[index]);
        },
      ),
    );
  }
}