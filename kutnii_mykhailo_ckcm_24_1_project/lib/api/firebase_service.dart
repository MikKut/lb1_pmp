import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';

class FirebaseService {
  final String baseUrl = 'https://students-538fd-default-rtdb.firebaseio.com';

  Future<List<Student>> fetchStudents() async {
    final url = Uri.parse('$baseUrl/students.json');
    final response = await http.get(url);

    if (response.statusCode >= 400) {
      throw Exception('Помилка при завантаженні студентів');
    }

    final data = json.decode(response.body);

    if (data == null) {
      return [];
    }

    final List<Student> loadedStudents = [];
    (data as Map<String, dynamic>).forEach((id, studentData) {
      loadedStudents.add(
        Student.fromFirebase(id, studentData),
      );
    });

    return loadedStudents;
  }

  Future<String> addStudent(Student student) async {
    final url = Uri.parse('$baseUrl/students.json');

    final response = await http.post(
      url,
      body: json.encode(student.toMap()),
    );

    if (response.statusCode >= 400) {
      throw Exception('Помилка при додаванні студента');
    }

    final responseData = json.decode(response.body);
    return responseData['name'];
  }

  Future<void> updateStudent(Student student) async {
    final url = Uri.parse('$baseUrl/students/${student.id}.json');

    final response = await http.put(
      url,
      body: json.encode(student.toMap()),
    );

    if (response.statusCode >= 400) {
      throw Exception('Помилка при редагуванні студента');
    }
  }

  Future<void> deleteStudent(String? studentId) async {
    if (studentId == null) {
      throw Exception('Помилка при видаленні студента: id is null');
    }

    final url = Uri.parse('$baseUrl/students/$studentId.json');
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      throw Exception('Помилка при видаленні студента');
    }
  }
}
