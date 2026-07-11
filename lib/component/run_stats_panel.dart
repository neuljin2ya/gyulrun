import 'package:flutter/material.dart';

class RunStatsPanel extends StatelessWidget {
  const RunStatsPanel({
    super.key,
    required this.courseName,
    required this.distanceKm,
    required this.elapsed,
    required this.paceMinutesPerKm,
    required this.calories,
  });

  final String courseName;
  final double distanceKm;
  final Duration elapsed;
  final double paceMinutesPerKm;
  final double calories;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 18,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            courseName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF252525),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            distanceKm.toStringAsFixed(2),
            style: const TextStyle(
              color: Color(0xFF171717),
              fontSize: 48,
              height: 1,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Distance (Km)',
            style: TextStyle(color: Color(0xFF777777), fontSize: 11),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _RunMetric(
                icon: Icons.directions_run_rounded,
                value: _formatPace(paceMinutesPerKm),
                label: 'Avg Pace',
              ),
              _RunMetric(
                icon: Icons.timer_outlined,
                value: _formatDuration(elapsed),
                label: 'Duration',
              ),
              _RunMetric(
                icon: Icons.local_fire_department_outlined,
                value: '${calories.round()} kcal',
                label: 'Calories',
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatDuration(Duration value) {
    final minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  static String _formatPace(double value) {
    if (value < 2 || value > 30 || !value.isFinite) return "0'00\"";
    final minutes = value.floor();
    final seconds = ((value - minutes) * 60).round().toString().padLeft(2, '0');
    return "$minutes'$seconds\"";
  }
}

class _RunMetric extends StatelessWidget {
  const _RunMetric({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF252525)),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF777777), fontSize: 10),
        ),
      ],
    );
  }
}
