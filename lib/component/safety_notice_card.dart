import 'package:flutter/material.dart';
import 'package:gyulrun/model/course.dart';

class SafetyNoticeCard extends StatelessWidget {
  const SafetyNoticeCard({
    super.key,
    this.course,
    this.message =
        '출발 전 날씨와 도로 상황을 확인해주세요.\n'
        '보행자와 차량에 주의하며 안전하게 달려주세요.',
  });

  final Course? course;
  final String message;

  @override
  Widget build(BuildContext context) {
    final notice = course == null ? message : _messageFor(course!);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0EC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFFF7043),
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              notice,
              style: const TextStyle(
                color: Color(0xFF6D4035),
                fontSize: 13,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _messageFor(Course course) {
    return switch (course.name) {
      '해녀런' =>
        '해안도로 CCTV 24개와 방문자 정보를 확인했어요.\n'
            '바람이 조금 있는 편이라 해안 구간에서는 속도를 낮추고, 바다 풍경을 즐기며 달려보세요.',
      '돌고래런' =>
        '방문자가 적고 경사가 낮은 코스로 분석됐어요.\n'
            '바람은 약한 편이지만 해안가 모래·자전거 이동에 주의하며 여유롭게 달려보세요.',
      '오름런' =>
        '경사 데이터상 오르막 구간이 일부 포함돼 있어요.\n'
            '초반에는 페이스를 낮추고 숲길과 오름 풍경을 즐기며 달려보세요.',
      _ =>
        'CCTV 18개와 방문자 데이터를 확인했어요.\n'
            '바람은 약하고 경사는 완만하지만, 도로 교차 구간에서는 차량과 보행자에 주의해주세요.',
    };
  }
}
