import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyulrun/component/activity_photo_card.dart';
import 'package:gyulrun/component/course_card.dart';
import 'package:gyulrun/component/favorite_course_drawer.dart';
import 'package:gyulrun/component/memory_thumbnail_card.dart';
import 'package:gyulrun/component/nearby_place_card.dart';
import 'package:gyulrun/component/primary_button.dart';
import 'package:gyulrun/component/run_controls.dart';
import 'package:gyulrun/component/run_stats_panel.dart';
import 'package:gyulrun/component/star_rating_input.dart';
import 'package:gyulrun/component/running_bottom_navigation_bar.dart';
import 'package:gyulrun/main.dart';
import 'package:gyulrun/model/course.dart';
import 'package:gyulrun/model/nearby_place_info.dart';
import 'package:gyulrun/model/run_history_entry.dart';
import 'package:gyulrun/model/run_result.dart';
import 'package:gyulrun/screen/course_detail_screen.dart';
import 'package:gyulrun/screen/free_run_summary_screen.dart';
import 'package:gyulrun/screen/history_screen.dart';
import 'package:gyulrun/service/favorite_store.dart';
import 'package:gyulrun/service/run_history_store.dart';

const _transparentPixel = [
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
];

void main() {
  testWidgets('하단 내비게이션 바를 표시한다', (tester) async {
    await tester.pumpWidget(const GyulrunApp());
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump();

    expect(find.byType(RunningBottomNavigationBar), findsOneWidget);
    expect(find.bySemanticsLabel('홈'), findsOneWidget);
    expect(find.bySemanticsLabel('러닝 시작'), findsOneWidget);
    expect(find.bySemanticsLabel('러닝 기록'), findsOneWidget);
  });

  testWidgets('오른쪽 버튼으로 기록 화면에 이동한다', (tester) async {
    await tester.pumpWidget(const GyulrunApp());
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump();

    tester
        .widget<RunningBottomNavigationBar>(
          find.byType(RunningBottomNavigationBar),
        )
        .onStatsTap
        ?.call();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(HistoryScreen), findsOneWidget);
  });

  testWidgets('코스를 누르면 상세 화면으로 이동하고 뒤로간다', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Text('홈'))));
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => const CourseDetailScreen(
          course: Course(
            name: '귤런',
            distanceKm: 3,
            address: '제주시 애월읍 애월해안로',
            difficulty: CourseDifficulty.easy,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(CourseDetailScreen), findsOneWidget);
    expect(find.text('GyulRun'), findsOneWidget);
    expect(find.text('3,00 KM'), findsOneWidget);

    await tester.tap(find.byTooltip('뒤로가기'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(CourseDetailScreen), findsNothing);
  });

  testWidgets('코스 난이도를 선택해 표시한다', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: CourseCard(difficulty: CourseDifficulty.easy)),
      ),
    );

    expect(find.byType(CourseCard), findsOneWidget);
    expect(find.text('EASY'), findsOneWidget);
    expect(find.text('5'), findsNothing);

    await tester.tap(find.byTooltip('즐겨찾기 추가'));
    await tester.pump();

    expect(find.byTooltip('즐겨찾기 해제'), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsOneWidget);
  });

  testWidgets('즐겨찾기 패널에서 별을 해제하면 목록에서 사라진다', (tester) async {
    FavoriteStore.instance.clear();
    await tester.pumpWidget(const GyulrunApp());
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump();

    await tester.tap(find.byTooltip('즐겨찾기 추가').first);
    await tester.pump();
    await tester.tap(find.byTooltip('메뉴'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    final drawer = find.byType(FavoriteCourseDrawer);
    expect(drawer, findsOneWidget);
    final favoriteButton = find.descendant(
      of: drawer,
      matching: find.byTooltip('즐겨찾기 해제'),
    );
    await tester.tap(favoriteButton);
    await tester.pump();

    expect(find.text('즐겨찾기한 코스가 없어요'), findsOneWidget);
    FavoriteStore.instance.clear();
  });

  testWidgets('기록 화면을 표시한다', (tester) async {
    RunHistoryStore.instance.clear();
    await tester.pumpWidget(const MaterialApp(home: HistoryScreen()));

    expect(find.text('History'), findsOneWidget);
    expect(find.text('아직 완주 기록이 없어요'), findsOneWidget);
    expect(find.byType(ActivityPhotoCard), findsNothing);
    expect(find.text('주변'), findsNothing);
  });

  testWidgets('기록이 있으면 완주 카드와 주변 장소를 표시한다', (tester) async {
    await tester.binding.setSurfaceSize(const Size(393, 852));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    RunHistoryStore.instance
      ..clear()
      ..add(
        RunHistoryEntry(
          result: const RunResult(
            courseName: '오름런',
            distanceKm: 3,
            elapsed: Duration(minutes: 20),
            calories: 120,
            nearbyPlaces: [
              NearbyPlaceInfo(name: 'API 명소', address: '제주시 테스트로 1'),
            ],
          ),
          rating: 5,
          photoBytes: Uint8List.fromList(_transparentPixel),
          completedAt: DateTime(2026),
        ),
      );

    await tester.pumpWidget(const MaterialApp(home: HistoryScreen()));

    expect(find.byType(ActivityPhotoCard), findsOneWidget);
    expect(find.text('오름런'), findsOneWidget);
    expect(find.text('3,00 KM'), findsOneWidget);
    expect(find.text('5.0'), findsOneWidget);
    expect(find.text('주변'), findsOneWidget);
    expect(find.text('API 명소'), findsOneWidget);
    expect(find.text('제주시 테스트로 1'), findsOneWidget);
    expect(find.byType(MemoryThumbnailCard), findsWidgets);
    RunHistoryStore.instance.clear();
  });

  testWidgets('주요 동작 버튼을 표시한다', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(label: '시작하기', onPressed: () {}),
        ),
      ),
    );

    expect(find.byType(PrimaryButton), findsOneWidget);
    expect(find.text('시작하기'), findsOneWidget);
  });

  testWidgets('자유런 요약 화면에서 이름을 수정해 완료한다', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FreeRunSummaryScreen(
          result: RunResult(
            courseName: '자유런',
            distanceKm: 3,
            elapsed: Duration(minutes: 15),
            calories: 854,
          ),
        ),
      ),
    );

    expect(find.text('Monday Morning Run'), findsNothing);
    expect(find.text('Distance'), findsOneWidget);
    expect(find.text('Duration'), findsOneWidget);
    expect(find.text('Avg Pace'), findsOneWidget);
    expect(find.text('완료'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pump();
    await tester.enterText(find.byType(TextField), '귤런');
    expect(find.text('귤런'), findsOneWidget);
  });

  testWidgets('러닝 통계와 컨트롤을 표시한다', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              const RunStatsPanel(
                courseName: '귤런',
                distanceKm: 1.25,
                elapsed: Duration(minutes: 8, seconds: 30),
                paceMinutesPerKm: 6.8,
                calories: 75,
              ),
              RunControls(
                isPaused: false,
                onPauseToggle: () {},
                onFinish: () {},
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('1,25'), findsOneWidget);
    expect(find.text('귤런'), findsOneWidget);
    expect(find.text('08:30'), findsOneWidget);
    expect(find.text('일시정지'), findsOneWidget);
    expect(find.text('종료'), findsOneWidget);
  });

  testWidgets('비정상적인 평균 페이스는 0으로 표시한다', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RunStatsPanel(
            courseName: '귤런',
            distanceKm: 0,
            elapsed: Duration(seconds: 11),
            paceMinutesPerKm: 2203818903,
            calories: 0,
          ),
        ),
      ),
    );

    expect(find.text("0'00\""), findsOneWidget);
  });

  testWidgets('별 다섯 개 중 원하는 별점을 선택한다', (tester) async {
    var rating = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StarRatingInput(
            value: rating,
            onChanged: (value) => rating = value,
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('4점'));
    expect(rating, 4);
  });

  test('완주 기록을 히스토리 저장소에 저장한다', () {
    RunHistoryStore.instance.clear();
    final entry = RunHistoryEntry(
      result: const RunResult(
        courseName: '귤런',
        distanceKm: 3,
        elapsed: Duration(minutes: 20),
        calories: 180,
      ),
      rating: 5,
      photoBytes: Uint8List.fromList([1, 2, 3]),
      completedAt: DateTime(2026),
    );

    RunHistoryStore.instance.add(entry);

    expect(RunHistoryStore.instance.latest, same(entry));
    RunHistoryStore.instance.clear();
  });

  testWidgets('사진이 없으면 직접 촬영 동작을 표시한다', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ActivityPhotoCard(title: '한라산런', distanceKm: 5, rating: 4.8),
        ),
      ),
    );

    expect(find.text('한라산런'), findsOneWidget);
    expect(find.text('5,00 KM'), findsOneWidget);
    expect(find.text('완주 사진이 표시됩니다'), findsOneWidget);
  });

  testWidgets('주변 장소의 카테고리와 주소를 표시한다', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: NearbyPlaceCard(
            name: '애월 바다 카페',
            category: PlaceCategory.cafe,
            address: '제주시 애월읍 애월해안로 10',
            distanceMeters: 350,
            rating: 4.8,
          ),
        ),
      ),
    );

    expect(find.text('카페'), findsOneWidget);
    expect(find.text('애월 바다 카페'), findsOneWidget);
    expect(find.text('제주시 애월읍 애월해안로 10'), findsOneWidget);
    expect(find.text('350m'), findsOneWidget);
  });
}
