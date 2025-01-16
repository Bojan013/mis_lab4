import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mis_lab4/models/exam.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<Exam>> exams = {
    DateTime(2025, 1, 20): [
      Exam(
        id: '1',
        courseName: 'Mis',
        location: 'Lab 138',
        dateTime: DateTime(2025, 1, 20, 14, 30),
        coordinates: LatLng(41.9981, 21.4254), // Example coordinates
      ),
      Exam(
        id: '2',
        courseName: 'Aps',
        location: 'Lab 13',
        dateTime: DateTime(2025, 1, 20, 10, 0),
        coordinates: LatLng(41.9985, 21.4259), // Example coordinates
      ),
    ],
    DateTime(2025, 1, 22): [
      Exam(
        id: '3',
        courseName: 'Kompjuterski mrezi i bezbednost',
        location: 'Lab 200AB',
        dateTime: DateTime(2025, 1, 22, 15, 30),
        coordinates: LatLng(41.9991, 21.4262), // Example coordinates
      ),
    ],
  };

  List<Exam> _getExamsForDay(DateTime day) {
    return exams[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Calendar')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getExamsForDay,
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(41.9981, 21.4254), // Initial map center
                zoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.mis_lab4',
                ),
                MarkerLayer(
                  markers: _getExamsForDay(_selectedDay ?? _focusedDay).map((exam) {
                    return Marker(
                      point: exam.coordinates,
                      width: 40.0,
                      height: 40.0,
                      builder: (ctx) => const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 30.0,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}