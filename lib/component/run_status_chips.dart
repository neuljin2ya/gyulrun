import 'package:flutter/material.dart';

class RunStatusChips extends StatelessWidget {
  const RunStatusChips({
    super.key,
    required this.gpsActive,
    required this.isPaused,
  });

  final bool gpsActive;
  final bool isPaused;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _StatusChip(
          icon: isPaused ? Icons.pause_rounded : Icons.directions_run_rounded,
          label: isPaused ? '일시정지' : '러닝 중',
        ),
        _StatusChip(
          icon: gpsActive ? Icons.gps_fixed_rounded : Icons.gps_off_rounded,
          label: gpsActive ? 'GPS' : 'GPS 연결 중',
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F9D9),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: const Color(0xFF252525)),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF252525),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
