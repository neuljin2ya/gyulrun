import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RunningMap extends StatefulWidget {
  const RunningMap({
    super.key,
    required this.completedRoute,
    required this.guideRoute,
    required this.currentPosition,
    this.focusPosition,
  });

  final List<LatLng> completedRoute;
  final List<LatLng> guideRoute;
  final LatLng? currentPosition;
  final LatLng? focusPosition;

  @override
  State<RunningMap> createState() => _RunningMapState();
}

class _RunningMapState extends State<RunningMap> {
  final _mapController = MapController();

  @override
  void didUpdateWidget(covariant RunningMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusPosition != null &&
        widget.focusPosition != oldWidget.focusPosition) {
      _mapController.move(widget.focusPosition!, 17.4);
    }
  }

  @override
  Widget build(BuildContext context) {
    final center =
        widget.focusPosition ??
        (widget.guideRoute.isNotEmpty
            ? widget.guideRoute.first
            : widget.currentPosition ?? const LatLng(33.4996, 126.5312));
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(initialCenter: center, initialZoom: 17.4),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.gyulrun',
        ),
        if (widget.guideRoute.length > 1)
          PolylineLayer(
            polylines: [
              Polyline(
                points: widget.guideRoute,
                strokeWidth: 9,
                color: Colors.white,
              ),
              Polyline(
                points: widget.guideRoute,
                strokeWidth: 6,
                color: const Color(0xFF9DFF00),
              ),
            ],
          ),
        if (widget.completedRoute.length > 1)
          PolylineLayer(
            polylines: [
              Polyline(
                points: widget.completedRoute,
                strokeWidth: 4,
                color: const Color(0xFF252525).withValues(alpha: 0.7),
              ),
            ],
          ),
        if ((widget.currentPosition ?? widget.focusPosition) != null)
          MarkerLayer(
            markers: [
              Marker(
                point: widget.currentPosition ?? widget.focusPosition!,
                width: 28,
                height: 28,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF9DFF00),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        const RichAttributionWidget(
          attributions: [TextSourceAttribution('OpenStreetMap contributors')],
        ),
      ],
    );
  }
}
