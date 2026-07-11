import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gyulrun/component/primary_button.dart';
import 'package:gyulrun/model/run_result.dart';
import 'package:gyulrun/navigation/app_routes.dart';
import 'package:gyulrun/service/course_route_guide.dart';
import 'package:latlong2/latlong.dart';

class FreeRunSummaryScreen extends StatefulWidget {
  const FreeRunSummaryScreen({super.key, required this.result});

  final RunResult result;

  @override
  State<FreeRunSummaryScreen> createState() => _FreeRunSummaryScreenState();
}

class _FreeRunSummaryScreenState extends State<FreeRunSummaryScreen> {
  late final TextEditingController _titleController;
  final _titleFocusNode = FocusNode();
  var _isEditingTitle = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        child: PrimaryButton(label: '완료', onPressed: _continueToCard),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(28, 54, 28, 118),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    focusNode: _titleFocusNode,
                    readOnly: !_isEditingTitle,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      hintText: '제목을 입력해주세요',
                      hintStyle: TextStyle(
                        color: Color(0x80253333),
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.8,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(
                      color: Color(0xFF253333),
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.8,
                    ),
                    onSubmitted: (_) {
                      setState(() => _isEditingTitle = false);
                      _titleFocusNode.unfocus();
                    },
                  ),
                ),
                IconButton(
                  onPressed: _startEditingTitle,
                  icon: Icon(
                    _isEditingTitle ? Icons.check_rounded : Icons.edit_outlined,
                    size: 24,
                  ),
                ),
              ],
            ),
            const Divider(height: 28, color: Color(0x55253333)),
            const SizedBox(height: 32),
            _ActualRunMap(route: widget.result.route),
            const SizedBox(height: 52),
            _MainStatsCard(result: widget.result),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  void _startEditingTitle() {
    if (_isEditingTitle) {
      setState(() => _isEditingTitle = false);
      _titleFocusNode.unfocus();
      return;
    }
    setState(() => _isEditingTitle = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _titleFocusNode.requestFocus();
      _titleController.selection = TextSelection.collapsed(
        offset: _titleController.text.length,
      );
    });
  }

  void _continueToCard() {
    final title = _titleController.text.trim();
    AppRoutes.replace(
      context,
      AppRoutes.runComplete,
      arguments: widget.result.copyWith(
        courseName: title.isEmpty ? '자유런' : title,
      ),
    );
  }
}

class _ActualRunMap extends StatelessWidget {
  const _ActualRunMap({required this.route});

  final List<LatLng> route;

  @override
  Widget build(BuildContext context) {
    final displayRoute = route.length > 1 ? route : _fallbackRoute;
    final center = _centerOf(displayRoute);

    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: SizedBox(
        height: 292,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: center,
            initialZoom: 16.2,
            initialCameraFit: CameraFit.coordinates(
              coordinates: displayRoute,
              padding: const EdgeInsets.fromLTRB(34, 34, 34, 88),
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.gyulrun',
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: displayRoute,
                  strokeWidth: 10,
                  color: Colors.white,
                ),
                Polyline(
                  points: displayRoute,
                  strokeWidth: 7,
                  color: const Color(0xFF9DFF00),
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: displayRoute.last,
                  width: 28,
                  height: 28,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF253333),
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
            if (route.length <= 1)
              Positioned(
                left: 14,
                top: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    '자유런 경로',
                    style: TextStyle(
                      color: Color(0xFF253333),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
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

  static List<LatLng> get _fallbackRoute {
    final route = CourseRouteGuide.routeFor('귤런');
    return route.length > 6 ? route.take(route.length - 5).toList() : route;
  }

  static LatLng _centerOf(List<LatLng> route) {
    if (route.isEmpty) return const LatLng(33.4492, 126.9180);
    final latitude =
        route.map((point) => point.latitude).reduce((a, b) => a + b) /
        route.length;
    final longitude =
        route.map((point) => point.longitude).reduce((a, b) => a + b) /
        route.length;
    return LatLng(latitude, longitude);
  }
}

class _MainStatsCard extends StatelessWidget {
  const _MainStatsCard({required this.result});

  final RunResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 106,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF9DFF00).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatColumn(
              value: _formatDistance(result.distanceKm),
              unit: 'Km',
              label: 'Distance',
            ),
          ),
          const _VerticalDivider(),
          Expanded(
            child: _StatColumn(
              value: _formatDuration(result.elapsed),
              label: 'Duration',
            ),
          ),
          const _VerticalDivider(),
          Expanded(
            child: _StatColumn(
              value: _formatPace(result.distanceKm, result.elapsed),
              label: 'Avg Pace',
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDistance(double value) {
    return value.toStringAsFixed(2);
  }

  static String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '$minutes.${seconds.toString().padLeft(2, '0')}';
  }

  static String _formatPace(double distanceKm, Duration elapsed) {
    if (distanceKm <= 0.01) return "0'00\"";
    final totalSeconds = elapsed.inSeconds / distanceKm;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds.round() % 60;
    return "$minutes'${seconds.toString().padLeft(2, '0')}\"";
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.value, required this.label, this.unit});

  final String value;
  final String label;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              color: Color(0xFF253333),
              fontWeight: FontWeight.w800,
            ),
            children: [
              TextSpan(text: value, style: const TextStyle(fontSize: 22)),
              if (unit != null)
                TextSpan(text: ' $unit', style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF253333), fontSize: 16),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 34, color: const Color(0x55253333));
  }
}
