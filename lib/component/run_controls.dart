import 'package:flutter/material.dart';

class RunControls extends StatelessWidget {
  const RunControls({
    super.key,
    required this.isPaused,
    required this.onPauseToggle,
    required this.onFinish,
  });

  final bool isPaused;
  final VoidCallback onPauseToggle;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CircleControl(
          label: '종료',
          color: const Color(0xFF252525),
          iconColor: Colors.white,
          icon: Icons.stop_rounded,
          onTap: onFinish,
        ),
        const SizedBox(width: 22),
        _CircleControl(
          label: isPaused ? '계속' : '일시정지',
          color: const Color(0xFF9DFF00),
          iconColor: const Color(0xFF171717),
          icon: isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
          onTap: onPauseToggle,
        ),
      ],
    );
  }
}

class _CircleControl extends StatelessWidget {
  const _CircleControl({
    required this.label,
    required this.color,
    required this.iconColor,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final Color color;
  final Color iconColor;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: color,
          shape: const CircleBorder(),
          elevation: 4,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: SizedBox.square(
              dimension: 68,
              child: Icon(icon, color: iconColor, size: 34),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
