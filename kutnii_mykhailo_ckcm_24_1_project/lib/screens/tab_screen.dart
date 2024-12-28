import 'package:flutter/material.dart';
import '../models/student.dart';
import '../screens/students.dart';
import '../screens/departments_screen.dart';
import '../api/firebase_service.dart';
import '../widgets/NewStudent.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  List<Student> _students = [];
  final Map<String, int> _departmentCounts = {};
  final FirebaseService _firebaseService = FirebaseService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    setState(() => _isLoading = true);
    try {
      final fetchedStudents = await _firebaseService.fetchStudents();
      setState(() {
        _students = fetchedStudents;
        _updateCounts();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Помилка завантаження студентів: $error')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateCounts() {
    final Map<String, int> counts = {};
    for (var student in _students) {
      final departmentId = student.department.name;
      counts[departmentId] = (counts[departmentId] ?? 0) + 1;
    }
    _departmentCounts
      ..clear()
      ..addAll(counts);
  }

  Future<void> _addOrUpdateStudent(Student student, {int? index}) async {
    setState(() => _isLoading = true);
    print('Додається або оновлюється студент: ${student.firstName} ${student.lastName}');

    try {
      if (index == null) {
        final newId = await _firebaseService.addStudent(student);
        print('Отримано новий ID: $newId');
        final newStudent = student.copyWith(id: newId);
        setState(() {
          _students.add(newStudent);
          _updateCounts();
        });
        print('Студент доданий до списку з ID: ${newStudent.id}');
      } else {
        if (student.id == null) {
          throw Exception('Cannot update a student without an ID.');
        }
        await _firebaseService.updateStudent(student);
        setState(() {
          _students[index] = student;
          _updateCounts();
        });
        print('Студент оновлено: ${student.id}');
      }
    } catch (error) {
      print('Помилка при збереженні студента: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не вдалося зберегти студента: $error')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _removeStudentLocal(int index) {
    setState(() {
      _students.removeAt(index);
      _updateCounts();
    });
  }

  void _addStudentLocal(Student student, int index) {
    setState(() {
      _students.insert(index, student);
      _updateCounts();
    });
  }

  Future<void> _deleteStudentFromServer(String studentId) async {
    try {
      await _firebaseService.deleteStudent(studentId);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Помилка видалення: $error')),
      );
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _openNewStudentModal(BuildContext context, {Student? student, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: NewStudent(
            student: student,
            onSave: (updatedStudent) async {
              await _addOrUpdateStudent(updatedStudent, index: index);
              Navigator.of(context).pop(); // Закриваємо модальне вікно
              _selectPage(0); // Перемикаємося на початкову вкладку (індекс 0)
            },
          ),
        );
      },
    );
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
          isLoading: _isLoading,
          addOrUpdateStudent: _addOrUpdateStudent,
          removeStudentLocal: _removeStudentLocal,
          addStudentLocal: _addStudentLocal,
          deleteStudentFromServer: _deleteStudentFromServer,
        ),
        'title': 'Students',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(pages[_selectedPageIndex]['title'] as String),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : pages[_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
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
