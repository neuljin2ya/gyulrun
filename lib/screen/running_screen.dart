import 'package:flutter/material.dart';
import 'package:gyulrun/component/route_instruction_card.dart';
import 'package:gyulrun/component/run_controls.dart';
import 'package:gyulrun/component/run_stats_panel.dart';
import 'package:gyulrun/component/run_status_chips.dart';
import 'package:gyulrun/component/running_map.dart';
import 'package:gyulrun/model/nearby_place_info.dart';
import 'package:gyulrun/navigation/app_routes.dart';
import 'package:gyulrun/model/run_result.dart';
import 'package:gyulrun/service/course_route_guide.dart';
import 'package:gyulrun/service/run_tracker.dart';
import 'package:latlong2/latlong.dart';

class RunningScreen extends StatefulWidget {
  const RunningScreen({
    super.key,
    this.tracker,
    this.courseName = '자유런',
    this.targetDistanceKm = 0,
    this.hasGuideRoute = false,
    this.guideRoute = const <LatLng>[],
    this.nearbyPlaces = const <NearbyPlaceInfo>[],
  });

  final RunTracker? tracker;
  final String courseName;
  final double targetDistanceKm;
  final bool hasGuideRoute;
  final List<LatLng> guideRoute;
  final List<NearbyPlaceInfo> nearbyPlaces;

  @override
  State<RunningScreen> createState() => _RunningScreenState();
}

class _RunningScreenState extends State<RunningScreen> {
  late final RunTracker _tracker;
  late final bool _ownsTracker;

  @override
  void initState() {
    super.initState();
    _ownsTracker = widget.tracker == null;
    _tracker = widget.tracker ?? RunTracker();
    _tracker.addListener(_refresh);
    _tracker.start();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tracker.removeListener(_refresh);
    if (_ownsTracker) _tracker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final guideRoute = widget.hasGuideRoute
        ? widget.guideRoute.isEmpty
              ? CourseRouteGuide.routeFor(widget.courseName)
              : widget.guideRoute
        : <LatLng>[];
    final focusPosition =
        _tracker.currentPosition ??
        (guideRoute.isEmpty ? null : guideRoute.first);
    final instruction = widget.hasGuideRoute
        ? CourseRouteGuide.instructionFor(
            widget.courseName,
            _tracker.distanceKm,
          )
        : null;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          RunningMap(
            completedRoute: _tracker.route,
            guideRoute: guideRoute,
            currentPosition: _tracker.currentPosition,
            focusPosition: focusPosition,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
              child: Column(
                children: [
                  RunStatusChips(
                    gpsActive: _tracker.currentPosition != null,
                    isPaused: _tracker.isPaused,
                  ),
                  if (instruction != null)
                    RouteInstructionCard(message: instruction),
                  const Spacer(),
                  RunStatsPanel(
                    courseName: widget.courseName,
                    distanceKm: _tracker.distanceKm,
                    elapsed: _tracker.elapsed,
                    paceMinutesPerKm: _tracker.paceMinutesPerKm,
                    calories: _tracker.calories,
                  ),
                  const SizedBox(height: 14),
                  RunControls(
                    isPaused: _tracker.isPaused,
                    onPauseToggle: _tracker.togglePause,
                    onFinish: _finishRun,
                  ),
                ],
              ),
            ),
          ),
          if (_tracker.isLoading) const _GpsLoadingOverlay(),
          if (_tracker.errorMessage case final message?)
            _GpsErrorOverlay(message: message, onExit: _finishRun),
        ],
      ),
    );
  }

  Future<void> _finishRun() async {
    final completedDistance = widget.hasGuideRoute && _tracker.distanceKm < 0.01
        ? widget.targetDistanceKm
        : _tracker.distanceKm;
    final result = RunResult(
      courseName: widget.courseName,
      distanceKm: completedDistance,
      elapsed: _tracker.elapsed,
      calories: _tracker.calories,
      route: _tracker.route,
      nearbyPlaces: widget.nearbyPlaces,
    );
    await _tracker.stop();
    if (mounted) {
      AppRoutes.replace(
        context,
        widget.hasGuideRoute ? AppRoutes.runComplete : AppRoutes.freeRunSummary,
        arguments: result,
      );
    }
  }
}

class _GpsLoadingOverlay extends StatelessWidget {
  const _GpsLoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0x66000000),
      child: Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox.square(
                  dimension: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Color(0xFF9DFF00),
                  ),
                ),
                SizedBox(width: 12),
                Text('현재 GPS 위치를 찾고 있어요'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GpsErrorOverlay extends StatelessWidget {
  const _GpsErrorOverlay({required this.message, required this.onExit});

  final String message;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0x99000000),
      child: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_off_outlined, size: 42),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 18),
              FilledButton(onPressed: onExit, child: const Text('홈으로')),
            ],
          ),
        ),
      ),
    );
  }
}
