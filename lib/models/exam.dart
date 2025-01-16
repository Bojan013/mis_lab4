import 'package:latlong2/latlong.dart';

class Exam {
  String id;
  String courseName;
  DateTime dateTime;
  String location;
  LatLng coordinates;

  Exam({
    required this.id,
    required this.courseName,
    required this.dateTime,
    required this.location,
    required this.coordinates,
  });
}
