import 'package:flutter/material.dart';
import 'package:gyulrun/model/course.dart';

class CourseDetailHeader extends StatelessWidget {
  const CourseDetailHeader({
    super.key,
    required this.course,
    required this.onBack,
  });

  final Course course;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 44,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 36,
                  height: 44,
                  child: IconButton(
                    onPressed: onBack,
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    tooltip: '뒤로가기',
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 22,
                    ),
                  ),
                ),
              ),
              const Text(
                'GyulRun',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF252525),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          course.name,
          style: const TextStyle(
            color: Color(0xFF252525),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${_formatDistance(course.distanceKm)} KM',
          style: const TextStyle(
            color: Color(0xFF252525),
            fontSize: 34,
            height: 1,
            fontWeight: FontWeight.w800,
            fontStyle: FontStyle.italic,
            letterSpacing: -1,
          ),
        ),
      ],
    );
  }

  static String _formatDistance(double distance) {
    return distance.toStringAsFixed(2);
  }
}
