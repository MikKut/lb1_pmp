import 'package:flutter/material.dart';
import '../models/student.dart';
import '../widgets/student_item.dart';
import '../widgets/NewStudent.dart';

class StudentsScreen extends StatelessWidget {
  final List<Student> students;
  final bool isLoading;
  final Future<void> Function(Student student, {int? index}) addOrUpdateStudent;
  final void Function(int index) removeStudentLocal;
  final void Function(Student student, int index) addStudentLocal;
  final Future<void> Function(String studentId) deleteStudentFromServer;

  StudentsScreen({
    required this.students,
    required this.isLoading,
    required this.addOrUpdateStudent,
    required this.removeStudentLocal,
    required this.addStudentLocal,
    required this.deleteStudentFromServer,
  });

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
              await addOrUpdateStudent(updatedStudent, index: index);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Перевірка наявності id у всіх студентів
    for (var student in students) {
      assert(student.id != null, 'Студент ${student.firstName} ${student.lastName} не має ID');
    }

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (students.isEmpty) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openNewStudentModal(context),
          child: Icon(Icons.add),
        ),
        body: Center(
          child: Text(
            'No students added yet!',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openNewStudentModal(context),
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (ctx, index) {
          final student = students[index];
          return Dismissible(
            key: ValueKey(student.id!),
            direction: DismissDirection.endToStart,
            onDismissed: (_) {
              final removedStudent = students[index];
              removeStudentLocal(index);

              final snackBar = SnackBar(
                content: Text('${removedStudent.firstName} видалено'),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    addStudentLocal(removedStudent, index);
                  },
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((reason) {
                if (reason != SnackBarClosedReason.action) {
                  deleteStudentFromServer(removedStudent.id!);
                }
              });
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: InkWell(
              onTap: () => _openNewStudentModal(
                context,
                student: students[index],
                index: index,
              ),
              child: StudentItem(student: students[index]),
            ),
          );
        },
      ),
    );
  }
}
