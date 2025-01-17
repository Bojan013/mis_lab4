import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mis_lab4/pages/map_page.dart';
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
    _normalizeDate(DateTime(2025, 1, 20)): [
      Exam(
        id: '1',
        courseName: 'Mis',
        location: 'lab 138',
        dateTime: DateTime(2025, 1, 20, 14, 30),
        coordinates: LatLng(41.9981, 21.4254),
      ),
      Exam(
        id: '2',
        courseName: 'Aps',
        location: 'lab 13',
        dateTime: DateTime(2025, 1, 20, 10, 0),
        coordinates: LatLng(41.9985, 21.4259),
      ),
    ],
    _normalizeDate(DateTime(2025, 1, 22, 15, 30)): [
      Exam(
        id: '3',
        courseName: 'Kompjuterski mrezi i bezbednost',
        location: 'lab 200ab',
        dateTime: DateTime(2025, 1, 22),
        coordinates: LatLng(41.9981, 21.4240),
      ),
    ],
  };

  static DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  List<Exam> _getExamsForDay(DateTime day) {
    return exams[_normalizeDate(day)] ?? [];
  }

  void _addExam(DateTime date, Exam exam) {
    final normalizedDate = _normalizeDate(date);
    setState(() {
      if (exams.containsKey(normalizedDate)) {
        exams[normalizedDate]!.add(exam);
      } else {
        exams[normalizedDate] = [exam];
      }
    });
  }

  void _showAddExamDialog() {
    String courseName = '';
    String location = '';
    String latitude = '';
    String longitude = '';
    DateTime selectedTime = _focusedDay;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Exam'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Course Name'),
              onChanged: (value) => courseName = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Location'),
              onChanged: (value) => location = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Latitude'),
              keyboardType: TextInputType.number,
              onChanged: (value) => latitude = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Longitude'),
              keyboardType: TextInputType.number,
              onChanged: (value) => longitude = value,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () async {
                final TimeOfDay? timeOfDay = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (timeOfDay != null) {
                  selectedTime = DateTime(
                    _focusedDay.year,
                    _focusedDay.month,
                    _focusedDay.day,
                    timeOfDay.hour,
                    timeOfDay.minute,
                  );
                }
              },
              child: const Text('Select Time'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (courseName.isNotEmpty &&
                  location.isNotEmpty &&
                  latitude.isNotEmpty &&
                  longitude.isNotEmpty) {
                final lat = double.tryParse(latitude);
                final lng = double.tryParse(longitude);
                if (lat != null && lng != null) {
                  _addExam(
                    _selectedDay ?? _focusedDay,
                    Exam(
                      id: DateTime.now().toString(),
                      courseName: courseName,
                      location: location,
                      dateTime: selectedTime,
                      coordinates: LatLng(lat, lng),
                    ),
                  );
                  Navigator.of(context).pop();
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Calendar'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              if (_selectedDay != null) {
                _showAddExamDialog();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a day first')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapPage(exams: exams),
                ),
              );
            },
          ),
        ],
      ),
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
            child: _selectedDay == null
                ? const Center(child: Text('No day selected'))
                : ListView(
                    children: _getExamsForDay(_selectedDay!).map((event) {
                      return ListTile(
                        title: Text(event.courseName),
                        subtitle: Text(
                          '${event.location}\n'
                          '${event.dateTime.hour}:${event.dateTime.minute}',
                        ),
                      );
                    }).toList(),
                  ),
          ),
          //   const SizedBox(height: 8.0),
          //   Expanded(
          //     child: FlutterMap(
          //       options: MapOptions(
          //         center: LatLng(41.9981, 21.4254), // Initial map center
          //         zoom: 15.0,
          //       ),
          //       children: [
          //         TileLayer(
          //           urlTemplate:
          //               'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          //           subdomains: const ['a', 'b', 'c'],
          //           userAgentPackageName: 'com.example.mis_lab4',
          //         ),
          //         MarkerLayer(
          //           markers:
          //               _getExamsForDay(_selectedDay ?? _focusedDay).map((exam) {
          //             return Marker(
          //               point: exam.coordinates,
          //               width: 40.0,
          //               height: 40.0,
          //               builder: (ctx) => const Icon(
          //                 Icons.location_on,
          //                 color: Colors.red,
          //                 size: 30.0,
          //               ),
          //             );
          //           }).toList(),
          //         ),
          //       ],
          //     ),
          //   ),
        ],
      ),
    );
  }
}
