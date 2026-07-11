import 'package:flutter/material.dart';
import 'package:gyulrun/component/course_card.dart';
import 'package:gyulrun/model/course.dart';

class FavoriteCourseDrawer extends StatelessWidget {
  const FavoriteCourseDrawer({
    super.key,
    required this.courses,
    required this.onFavoriteChanged,
    required this.onCourseTap,
  });

  final List<Course> courses;
  final void Function(Course course, bool isFavorite) onFavoriteChanged;
  final ValueChanged<Course> onCourseTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(22)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 10, 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      '즐겨찾기',
                      style: TextStyle(
                        color: Color(0xFF252525),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: '닫기',
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: courses.isEmpty
                  ? const _EmptyFavorites()
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: courses.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return CourseCard(
                          difficulty: course.difficulty,
                          title: course.name,
                          distanceKm: course.distanceKm,
                          address: course.address,
                          initiallyFavorite: true,
                          onFavoriteChanged: (isFavorite) {
                            onFavoriteChanged(course, isFavorite);
                          },
                          onTap: () => onCourseTap(course),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_border_rounded, size: 48, color: Color(0xFFAAAAAA)),
            SizedBox(height: 12),
            Text(
              '즐겨찾기한 코스가 없어요',
              style: TextStyle(color: Color(0xFF777777), fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
