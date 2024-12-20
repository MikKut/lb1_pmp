import 'package:flutter/material.dart';
import 'departments_screen.dart';
import 'students.dart';
import '../models/student.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> with SingleTickerProviderStateMixin {
  int _selectedPageIndex = 0;
  final List<Student> _students = [];
  final Map<String, int> _departmentCounts = {};

  void _updateCounts() {
    final Map<String, int> counts = {};
    for (var student in _students) {
      final departmentId = student.department.name;
      counts[departmentId] = (counts[departmentId] ?? 0) + 1;
    }
    setState(() {
      _departmentCounts.clear();
      _departmentCounts.addAll(counts);
    });
  }

  void _addOrUpdateStudent(Student student, {int? index}) {
    setState(() {
      if (index != null) {
        _students[index] = student;
      } else {
        // Add a new student
        _students.add(student);
      }
      _updateCounts();
    });
  }


  void _deleteStudent(int index) {
    setState(() {
      _students.removeAt(index);
      _updateCounts();
    });
  }

  void _undoDeleteStudent(Student student, int index) {
    setState(() {
      _students.insert(index, student);
      _updateCounts();
    });
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, Object>> pages = [
      {
        'page': DepartmentsScreen(studentCounts: _departmentCounts),
        'title': 'Departments',
      },
      {
        'page': StudentsScreen(
          students: _students,
          addOrUpdateStudent: _addOrUpdateStudent,
          deleteStudent: _deleteStudent,
          undoDeleteStudent: _undoDeleteStudent,
        ),
        'title': 'Students',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(pages[_selectedPageIndex]['title'] as String),
      ),
      body: pages[_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Departments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Students',
          ),
        ],
      ),
    );
  }
}
