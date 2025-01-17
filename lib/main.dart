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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Calendar',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Calendar(),
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Calendar and Map',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       initialRoute: '/',
//       routes: {
//         '/': (context) => const Calendar(),
//         // '/map': (context) => const MapScreen(),
//       },
//     );
//   }
// }
