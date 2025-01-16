import 'package:flutter/material.dart';
import 'package:mis_lab4/pages/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class Example {
  final String title;
  final String description;
  final DateTime date;

  Example({required this.title, required this.description, required this.date});
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Calendar(),
    );
  }
}
