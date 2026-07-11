import 'package:flutter/material.dart';
import 'package:gyulrun/component/course_card.dart';
import 'package:gyulrun/model/course.dart';

class PopularCourseSection extends StatelessWidget {
  const PopularCourseSection({
    super.key,
    required this.courses,
    required this.onCourseTap,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  final List<Course> courses;
  final ValueChanged<Course> onCourseTap;
  final bool Function(Course course) isFavorite;
  final void Function(Course course, bool isFavorite) onFavoriteChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AI 추천 코스',
          style: TextStyle(
            color: Color(0xFF252525),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        for (var index = 0; index < courses.length; index++) ...[
          CourseCard(
            difficulty: courses[index].difficulty,
            title: courses[index].name,
            distanceKm: courses[index].distanceKm,
            address: courses[index].address,
            initiallyFavorite: isFavorite(courses[index]),
            onFavoriteChanged: (favorite) {
              onFavoriteChanged(courses[index], favorite);
            },
            onTap: () => onCourseTap(courses[index]),
          ),
          if (index < courses.length - 1) const SizedBox(height: 14),
        ],
      ],
    );
  }
}
