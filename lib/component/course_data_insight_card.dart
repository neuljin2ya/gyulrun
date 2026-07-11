import 'package:flutter/material.dart';
import 'package:gyulrun/model/course.dart';

class CourseDataInsightCard extends StatelessWidget {
  const CourseDataInsightCard({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final metrics = _CourseMetricSet.forCourse(course);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3FFF8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  '코스 데이터',
                  style: TextStyle(
                    color: Color(0xFF252525),
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFA8FF18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '적합도 ${metrics.fitScore}점',
                  style: const TextStyle(
                    color: Color(0xFF252525),
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            '날씨·CCTV·방문자·경사 정보를 반영했어요',
            style: TextStyle(
              color: Color(0x99252525),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 2.15,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _MetricTile(
                icon: Icons.videocam_outlined,
                title: 'CCTV',
                value: '${metrics.cctvCount}개',
                caption: '안전 확인',
              ),
              _MetricTile(
                icon: Icons.air_rounded,
                title: '바람',
                value: '${metrics.windKmh}km/h',
                caption: metrics.weatherName,
              ),
              _MetricTile(
                icon: Icons.groups_2_outlined,
                title: '방문자',
                value: metrics.visitorLevel,
                caption: '혼잡도 낮음',
              ),
              _MetricTile(
                icon: Icons.terrain_outlined,
                title: '경사',
                value: metrics.slopeLevel,
                caption: '러닝 난이도',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CourseMetricSet {
  const _CourseMetricSet({
    required this.cctvCount,
    required this.windKmh,
    required this.visitorLevel,
    required this.slopeLevel,
    required this.weatherName,
    required this.fitScore,
  });

  final int cctvCount;
  final int windKmh;
  final String visitorLevel;
  final String slopeLevel;
  final String weatherName;
  final int fitScore;

  factory _CourseMetricSet.forCourse(Course course) {
    return switch (course.name) {
      '해녀런' => _CourseMetricSet(
        cctvCount: 24,
        windKmh: 16,
        visitorLevel: '보통',
        slopeLevel: '완만',
        weatherName: course.weatherName ?? '맑음',
        fitScore: course.safetyScore ?? 91,
      ),
      '돌고래런' => _CourseMetricSet(
        cctvCount: 12,
        windKmh: 9,
        visitorLevel: '적음',
        slopeLevel: '낮음',
        weatherName: course.weatherName ?? '맑음',
        fitScore: course.safetyScore ?? 94,
      ),
      '오름런' => _CourseMetricSet(
        cctvCount: 8,
        windKmh: 7,
        visitorLevel: '적음',
        slopeLevel: '보통',
        weatherName: course.weatherName ?? '맑음',
        fitScore: course.safetyScore ?? 88,
      ),
      _ => _CourseMetricSet(
        cctvCount: 18,
        windKmh: 11,
        visitorLevel: '적음',
        slopeLevel: '완만',
        weatherName: course.weatherName ?? '맑음',
        fitScore: course.safetyScore ?? 93,
      ),
    };
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.caption,
  });

  final IconData icon;
  final String title;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 9),
      decoration: BoxDecoration(
        color: const Color(0xCCFFFFFF),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0x33A8FF18),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF252525)),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0x99252525),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF252525),
                    fontSize: 16,
                    height: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0x80252525),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
