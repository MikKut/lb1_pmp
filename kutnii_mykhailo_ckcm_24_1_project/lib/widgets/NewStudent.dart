import 'package:flutter/material.dart';
import '../models/student.dart';

class NewStudent extends StatefulWidget {
  final Student? student;
  final Function(Student) onSave;

  NewStudent({this.student, required this.onSave});

  @override
  _NewStudentState createState() => _NewStudentState();
}

class _NewStudentState extends State<NewStudent> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _gradeController;
  Department? _selectedDepartment;
  Gender? _selectedGender;
  int? _grade;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.student?.firstName ?? '');
    _lastNameController =
        TextEditingController(text: widget.student?.lastName ?? '');
    _gradeController =
        TextEditingController(text: widget.student?.grade?.toString() ?? '');
    _selectedDepartment = widget.student?.department;
    _selectedGender = widget.student?.gender;
    _grade = widget.student?.grade;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _gradeController.dispose();
    super.dispose();
  }

  void _saveStudent() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _selectedDepartment == null ||
        _gradeController.text.isEmpty ||
        _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Будь ласка, заповніть всі поля.')),
      );
      return;
    }

    final updatedStudent = widget.student?.copyWith(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      department: _selectedDepartment!,
      grade: int.tryParse(_gradeController.text) ?? 0,
      gender: _selectedGender!,
    ) ?? Student(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      department: _selectedDepartment!,
      grade: int.tryParse(_gradeController.text) ?? 0,
      gender: _selectedGender!,
    );

    widget.onSave(updatedStudent);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Add Student' : 'Edit Student'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Будь ласка, введіть ім\'я';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(labelText: 'Last Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Будь ласка, введіть прізвище';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<Department>(
                  value: _selectedDepartment,
                  items: Department.values.map((department) {
                    return DropdownMenuItem(
                      value: department,
                      child: Text(department.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDepartment = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Department'),
                  validator: (value) {
                    if (value == null) {
                      return 'Будь ласка, оберіть кафедру';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<Gender>(
                  value: _selectedGender,
                  items: Gender.values.map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(gender.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Gender'),
                  validator: (value) {
                    if (value == null) {
                      return 'Будь ласка, оберіть стать';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _gradeController, // Grade controller
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Grade'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Будь ласка, введіть курс';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Будь ласка, введіть числове значення';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveStudent,
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}