import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gyulrun/model/course.dart';
import 'package:gyulrun/service/course_route_guide.dart';
import 'package:latlong2/latlong.dart';

class CourseMapPreview extends StatelessWidget {
  const CourseMapPreview({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final route = course.route.isEmpty
        ? CourseRouteGuide.routeFor(course.name)
        : course.route;
    final center = route.isEmpty
        ? CourseRouteGuide.centerFor(course.name)
        : _centerOf(route);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 270,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: center,
            initialZoom: 15.0,
            initialCameraFit: route.length > 1
                ? CameraFit.coordinates(
                    coordinates: route,
                    padding: const EdgeInsets.all(32),
                  )
                : null,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.gyulrun',
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: route,
                  color: const Color(0xFF9DFF00),
                  strokeWidth: 7,
                  borderColor: Colors.white,
                  borderStrokeWidth: 2,
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                if (route.isNotEmpty)
                  Marker(
                    point: route.first,
                    width: 24,
                    height: 24,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF252525),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                    ),
                  ),
              ],
            ),
            const RichAttributionWidget(
              attributions: [
                TextSourceAttribution('OpenStreetMap contributors'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static LatLng _centerOf(List<LatLng> route) {
    final latitude =
        route.map((point) => point.latitude).reduce((a, b) => a + b) /
        route.length;
    final longitude =
        route.map((point) => point.longitude).reduce((a, b) => a + b) /
        route.length;
    return LatLng(latitude, longitude);
  }
}
