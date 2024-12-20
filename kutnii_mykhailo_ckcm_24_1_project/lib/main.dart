import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/tab_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          titleTextStyle: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: TabsScreen(),
    );
  }
}
