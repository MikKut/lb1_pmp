import 'package:flutter/material.dart';
import '../widgets/department_item.dart';
import '../models/departments_data.dart';

class DepartmentsScreen extends StatelessWidget {
  final Map<String, int> studentCounts;

  DepartmentsScreen({Key? key, required this.studentCounts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      children: DEPARTMENTS.map((department) {
        final studentCount = studentCounts[department.id] ?? 0;
        return DepartmentItem(
          department: department,
          studentCount: studentCount,
        );
      }).toList(),
    );
  }
}
