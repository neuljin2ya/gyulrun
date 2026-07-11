import 'package:flutter/material.dart';
import 'package:gyulrun/component/app_header.dart';
import 'package:gyulrun/component/course_card.dart';
import 'package:gyulrun/component/current_weather_card.dart';
import 'package:gyulrun/component/favorite_course_drawer.dart';
import 'package:gyulrun/component/popular_course_section.dart';
import 'package:gyulrun/component/running_bottom_navigation_bar.dart';
import 'package:gyulrun/model/course.dart';
import 'package:gyulrun/navigation/app_routes.dart';
import 'package:gyulrun/screen/course_detail_screen.dart';
import 'package:gyulrun/service/course_api_service.dart';
import 'package:gyulrun/service/favorite_store.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _favoriteStore = FavoriteStore.instance;
  final _courseApiService = CourseApiService();
  var _isLoadingCourses = true;

  static const _fallbackCourses = [
    Course(
      name: '귤런',
      distanceKm: 3.01,
      address: '서귀포시 성산읍 동류암로 20 플레이스캠프 제주',
      difficulty: CourseDifficulty.easy,
    ),
    Course(
      name: '해녀런',
      distanceKm: 15.04,
      address: '제주시 구좌읍 해녀박물관길',
      difficulty: CourseDifficulty.hard,
    ),
    Course(
      name: '돌고래런',
      distanceKm: 5.01,
      address: '제주시 한림읍 협재해수욕장',
      difficulty: CourseDifficulty.normal,
    ),
  ];

  List<Course> _courses = _fallbackCourses;

  List<Course> get _favoriteCourses {
    return _courses
        .where((course) => _favoriteStore.contains(course.name))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    try {
      final courses = await _courseApiService.fetchPopularCourses();
      if (!mounted) return;
      if (courses.isNotEmpty) {
        setState(() {
          _courses = courses;
          _isLoadingCourses = false;
        });
      } else {
        setState(() => _isLoadingCourses = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingCourses = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: FavoriteCourseDrawer(
        courses: _favoriteCourses,
        onFavoriteChanged: _setFavorite,
        onCourseTap: _openCourseFromDrawer,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(32, 18, 32, 110),
              children: [
                AppHeader(
                  title: 'Gyulrun',
                  onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                ),
                const SizedBox(height: 22),
                const CurrentWeatherCard(),
                const SizedBox(height: 18),
                if (_isLoadingCourses) ...[
                  const _CourseDataLoadingBanner(),
                  const SizedBox(height: 12),
                ],
                PopularCourseSection(
                  courses: _courses,
                  isFavorite: (course) {
                    return _favoriteStore.contains(course.name);
                  },
                  onFavoriteChanged: _setFavorite,
                  onCourseTap: (course) => _openDetail(context, course),
                ),
              ],
            ),
            Positioned(
              left: 48,
              right: 48,
              bottom: 10,
              child: RunningBottomNavigationBar(
                onHomeTap: () {
                  AppRoutes.replace(context, AppRoutes.home);
                },
                onStatsTap: () {
                  AppRoutes.replace(context, AppRoutes.history);
                },
                onRunTap: () {
                  AppRoutes.replace(context, AppRoutes.running);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setFavorite(Course course, bool isFavorite) {
    setState(() {
      _favoriteStore.setFavorite(course.name, isFavorite: isFavorite);
    });
  }

  void _openCourseFromDrawer(Course course) {
    Navigator.of(context).pop();
    _openDetail(context, course);
  }

  void _openDetail(BuildContext context, Course course) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CourseDetailScreen(course: course),
      ),
    );
  }
}

class _CourseDataLoadingBanner extends StatelessWidget {
  const _CourseDataLoadingBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEFFFF7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          SizedBox.square(
            dimension: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF9DFF00),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '공공데이터 기반 코스를 불러오는 중이에요',
              style: TextStyle(
                color: Color(0xFF252525),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
