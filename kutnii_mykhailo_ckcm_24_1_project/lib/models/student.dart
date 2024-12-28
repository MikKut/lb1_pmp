import 'package:flutter/material.dart';

enum Department { finance, law, it, medical }
enum Gender { male, female }

class Student {
  String? id; // Firebase ID
  final String firstName;
  final String lastName;
  final Department department;
  final int grade;
  final Gender gender;

  Student({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.department,
    required this.grade,
    required this.gender,
  });

  factory Student.fromFirebase(String id, Map<String, dynamic> data) {
    return Student(
      id: id,
      firstName: data['firstName'] as String,
      lastName: data['lastName'] as String,
      department: Department.values.byName(data['department'] as String),
      grade: data['grade'] as int,
      gender: Gender.values.byName(data['gender'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'department': department.name,
      'grade': grade,
      'gender': gender.name,
    };
  }
  Student copyWith({
    String? id,
    String? firstName,
    String? lastName,
    Department? department,
    int? grade,
    Gender? gender,
  }) {
    return Student(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      department: department ?? this.department,
      grade: grade ?? this.grade,
      gender: gender ?? this.gender,
    );
  }
}


Map<Department, IconData> departmentIcons = {
  Department.finance: Icons.account_balance,
  Department.law: Icons.badge,
  Department.it: Icons.computer,
  Department.medical: Icons.health_and_safety,
};