import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mis_lab4/models/exam.dart';

class MapPage extends StatelessWidget {
  final Map<DateTime, List<Exam>> exams;

  const MapPage({super.key, required this.exams});

  List<Marker> _getAllMarkers() {
    return exams.values.expand((dayExams) {
      return dayExams.map((exam) {
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
      });
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(41.9981, 21.4254), // Initial map center
          zoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.mis_lab4',
          ),
          MarkerLayer(
            markers: _getAllMarkers(),
          ),
        ],
      ),
    );
  }
}