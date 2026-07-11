import 'package:gyulrun/model/nearby_place_info.dart';
import 'package:latlong2/latlong.dart';

class RunResult {
  const RunResult({
    required this.courseName,
    required this.distanceKm,
    required this.elapsed,
    required this.calories,
    this.route = const <LatLng>[],
    this.nearbyPlaces = const <NearbyPlaceInfo>[],
  });

  final String courseName;
  final double distanceKm;
  final Duration elapsed;
  final double calories;
  final List<LatLng> route;
  final List<NearbyPlaceInfo> nearbyPlaces;

  RunResult copyWith({
    String? courseName,
    double? distanceKm,
    Duration? elapsed,
    double? calories,
    List<LatLng>? route,
    List<NearbyPlaceInfo>? nearbyPlaces,
  }) {
    return RunResult(
      courseName: courseName ?? this.courseName,
      distanceKm: distanceKm ?? this.distanceKm,
      elapsed: elapsed ?? this.elapsed,
      calories: calories ?? this.calories,
      route: route ?? this.route,
      nearbyPlaces: nearbyPlaces ?? this.nearbyPlaces,
    );
  }
}
