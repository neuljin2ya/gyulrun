import 'package:gyulrun/component/course_card.dart';
import 'package:gyulrun/model/nearby_place_info.dart';
import 'package:latlong2/latlong.dart';

class Course {
  const Course({
    required this.name,
    required this.distanceKm,
    required this.address,
    required this.difficulty,
    this.route = const <LatLng>[],
    this.routeModeLabel,
    this.shapeMatch,
    this.aiScore,
    this.safetyScore,
    this.weatherName,
    this.paceNote,
    this.cctvSource,
    this.visitorsSource,
    this.nearbyPlaces = const <NearbyPlaceInfo>[],
  });

  final String name;
  final double distanceKm;
  final String address;
  final CourseDifficulty difficulty;
  final List<LatLng> route;
  final String? routeModeLabel;
  final int? shapeMatch;
  final double? aiScore;
  final int? safetyScore;
  final String? weatherName;
  final String? paceNote;
  final String? cctvSource;
  final String? visitorsSource;
  final List<NearbyPlaceInfo> nearbyPlaces;
}
