import 'package:flutter/material.dart';
import '../models/student.dart';
import '../widgets/student_item.dart';
import '../widgets/NewStudent.dart';

class StudentsScreen extends StatelessWidget {
  final List<Student> students;
  final Function(Student, {int? index}) addOrUpdateStudent;
  final Function(int) deleteStudent;
  final Function(Student, int) undoDeleteStudent;

  StudentsScreen({
    required this.students,
    required this.addOrUpdateStudent,
    required this.deleteStudent,
    required this.undoDeleteStudent,
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
            onSave: (updatedStudent) {
              addOrUpdateStudent(updatedStudent, index: index);
              Navigator.of(context).pop(); // Close the modal after saving
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openNewStudentModal(context),
        child: Icon(Icons.add),
      ),
      body: students.isEmpty
          ? Center(
        child: Text(
          'No students added yet!',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      )
          : ListView.builder(
        itemCount: students.length,
        itemBuilder: (ctx, index) {
          return Dismissible(
            key: ValueKey(students[index]),
            direction: DismissDirection.endToStart,
            onDismissed: (_) {
              final removedStudent = students[index];
              deleteStudent(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${removedStudent.firstName} removed'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () => undoDeleteStudent(removedStudent, index),
                  ),
                ),
              );
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
