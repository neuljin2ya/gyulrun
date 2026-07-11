import 'package:flutter/material.dart';
import 'package:gyulrun/component/course_data_insight_card.dart';
import 'package:gyulrun/component/course_detail_header.dart';
import 'package:gyulrun/component/course_map_preview.dart';
import 'package:gyulrun/component/map_link_card.dart';
import 'package:gyulrun/component/primary_button.dart';
import 'package:gyulrun/component/safety_notice_card.dart';
import 'package:gyulrun/model/course.dart';
import 'package:gyulrun/navigation/app_routes.dart';
import 'package:gyulrun/service/map_service.dart';

class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({
    super.key,
    required this.course,
    this.mapService = const MapService(),
  });

  final Course course;
  final MapService mapService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 124),
              children: [
                CourseDetailHeader(
                  course: course,
                  onBack: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 28),
                CourseMapPreview(course: course),
                const SizedBox(height: 14),
                CourseDataInsightCard(course: course),
                const SizedBox(height: 22),
                MapLinkCard(
                  address: course.address,
                  onTap: () => _openMap(context),
                ),
                const SizedBox(height: 16),
                SafetyNoticeCard(course: course),
              ],
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 28,
              child: PrimaryButton(
                label: '이 코스로 달리기',
                onPressed: () => AppRoutes.replace(
                  context,
                  AppRoutes.running,
                  arguments: course,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openMap(BuildContext context) async {
    final opened = await mapService.openNaverMap(course.address);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('네이버 지도를 열 수 없어요.')));
    }
  }
}
