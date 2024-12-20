import 'package:flutter/material.dart';
import '../models/department.dart';

class DepartmentItem extends StatelessWidget {
  final Department department;
  final int studentCount;

  const DepartmentItem({
    Key? key,
    required this.department,
    required this.studentCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            department.color.withOpacity(0.7),
            department.color,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: GridTile(
        child: Icon(
          department.icon,
          size: 50,
          color: Colors.white,
        ),
        footer: Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          color: Colors.black54,
          child: Column(
            children: [
              Text(
                department.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                '$studentCount students',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
