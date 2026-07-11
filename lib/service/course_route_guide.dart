import 'dart:math' as math;

import 'package:latlong2/latlong.dart';

class CourseRouteGuide {
  const CourseRouteGuide._();

  static const _orangeLatitudeRadius = 0.0036;
  static const _orangeLongitudeRadius = 0.0032;
  static const _playceCampJeju = LatLng(33.4492, 126.9180);

  static LatLng centerFor(String courseName) {
    return switch (courseName) {
      '해녀런' => const LatLng(33.5208, 126.8580),
      '한라산런' => const LatLng(33.4342, 126.6768),
      '오름런' => const LatLng(33.4569, 126.7148),
      '돌고래런' => const LatLng(33.3862, 126.2558),
      _ => const LatLng(33.4523, 126.9148),
    };
  }

  static List<LatLng> routeFor(String courseName) {
    final center = centerFor(courseName);
    return switch (courseName) {
      '귤런' => _orangeRoute(center),
      '한라산런' => _hallasanRoute(center),
      '해녀런' => _haenyeoRoute(center),
      '오름런' => _oreumRoute(center),
      '돌고래런' => _dolphinRoute(center),
      _ => _orangeRoute(center),
    };
  }

  static String instructionFor(String courseName, double distanceKm) {
    return switch (courseName) {
      '오름런' => _oreumInstruction(distanceKm),
      '해녀런' => _haenyeoInstruction(distanceKm),
      '한라산런' => _hallasanInstruction(distanceKm),
      '돌고래런' => _dolphinInstruction(distanceKm),
      _ => _orangeInstruction(distanceKm),
    };
  }

  static List<LatLng> _orangeRoute(LatLng center) {
    final points = <LatLng>[];

    for (var index = 0; index <= 40; index++) {
      final angle = -math.pi / 2 + (math.pi * 2 * index / 40);
      final shapeFactor = 1 + 0.07 * math.cos(angle * 2);
      points.add(
        LatLng(
          center.latitude +
              math.sin(angle) * _orangeLatitudeRadius * shapeFactor,
          center.longitude +
              math.cos(angle) * _orangeLongitudeRadius * shapeFactor,
        ),
      );
    }

    points[0] = _playceCampJeju;
    points[points.length - 1] = _playceCampJeju;
    final top = points.first;
    points
      ..add(LatLng(top.latitude + 0.0014, top.longitude + 0.0007))
      ..add(LatLng(top.latitude + 0.0024, top.longitude + 0.0021))
      ..add(LatLng(top.latitude + 0.0009, top.longitude + 0.0027))
      ..add(LatLng(top.latitude + 0.0001, top.longitude + 0.0010))
      ..add(top);
    return points;
  }

  static List<LatLng> _hallasanRoute(LatLng center) {
    return [
      LatLng(center.latitude - 0.0048, center.longitude - 0.0090),
      LatLng(center.latitude - 0.0026, center.longitude - 0.0065),
      LatLng(center.latitude + 0.0003, center.longitude - 0.0040),
      LatLng(center.latitude + 0.0048, center.longitude - 0.0011),
      LatLng(center.latitude + 0.0062, center.longitude + 0.0002),
      LatLng(center.latitude + 0.0038, center.longitude + 0.0018),
      LatLng(center.latitude + 0.0014, center.longitude + 0.0042),
      LatLng(center.latitude - 0.0028, center.longitude + 0.0070),
      LatLng(center.latitude - 0.0048, center.longitude + 0.0090),
      LatLng(center.latitude - 0.0053, center.longitude + 0.0045),
      LatLng(center.latitude - 0.0044, center.longitude),
      LatLng(center.latitude - 0.0053, center.longitude - 0.0045),
      LatLng(center.latitude - 0.0048, center.longitude - 0.0090),
    ];
  }

  static List<LatLng> _haenyeoRoute(LatLng center) {
    return [
      LatLng(center.latitude - 0.0040, center.longitude - 0.0054),
      LatLng(center.latitude - 0.0028, center.longitude - 0.0032),
      LatLng(center.latitude - 0.0011, center.longitude - 0.0010),
      LatLng(center.latitude - 0.0024, center.longitude + 0.0012),
      LatLng(center.latitude - 0.0005, center.longitude + 0.0032),
      LatLng(center.latitude + 0.0018, center.longitude + 0.0048),
      LatLng(center.latitude + 0.0028, center.longitude + 0.0060),
    ];
  }

  static List<LatLng> _oreumRoute(LatLng center) {
    return [
      LatLng(center.latitude - 0.0047, center.longitude - 0.0082),
      LatLng(center.latitude - 0.0026, center.longitude - 0.0058),
      LatLng(center.latitude + 0.0006, center.longitude - 0.0032),
      LatLng(center.latitude + 0.0022, center.longitude),
      LatLng(center.latitude + 0.0006, center.longitude + 0.0032),
      LatLng(center.latitude - 0.0026, center.longitude + 0.0058),
      LatLng(center.latitude - 0.0047, center.longitude + 0.0082),
      LatLng(center.latitude - 0.0051, center.longitude + 0.0030),
      LatLng(center.latitude - 0.0051, center.longitude - 0.0030),
      LatLng(center.latitude - 0.0047, center.longitude - 0.0082),
    ];
  }

  static List<LatLng> _dolphinRoute(LatLng center) {
    return [
      LatLng(center.latitude - 0.0010, center.longitude - 0.0062),
      LatLng(center.latitude + 0.0010, center.longitude - 0.0042),
      LatLng(center.latitude + 0.0023, center.longitude - 0.0016),
      LatLng(center.latitude + 0.0020, center.longitude + 0.0011),
      LatLng(center.latitude + 0.0006, center.longitude + 0.0035),
      LatLng(center.latitude - 0.0010, center.longitude + 0.0046),
      LatLng(center.latitude - 0.0003, center.longitude + 0.0060),
      LatLng(center.latitude - 0.0020, center.longitude + 0.0048),
      LatLng(center.latitude - 0.0030, center.longitude + 0.0021),
      LatLng(center.latitude - 0.0027, center.longitude - 0.0010),
      LatLng(center.latitude - 0.0038, center.longitude - 0.0028),
      LatLng(center.latitude - 0.0024, center.longitude - 0.0032),
      LatLng(center.latitude - 0.0010, center.longitude - 0.0062),
    ];
  }

  static String _oreumInstruction(double distanceKm) {
    if (distanceKm < 1.0) return '1km 직진 후 오름길 입구로 이동';
    if (distanceKm < 1.4) return '오른쪽으로 꺾어 오름 능선 방향';
    if (distanceKm < 2.0) return '600m 직진 · 숲길을 따라가세요';
    if (distanceKm < 2.4) return '왼쪽으로 꺾어 출발지 방향';
    return '마지막 600m 직진 · 완주 지점 도착';
  }

  static String _haenyeoInstruction(double distanceKm) {
    if (distanceKm < 1.0) return '1km 직진 · 해안도로 안쪽으로 이동';
    if (distanceKm < 3.0) return '오른쪽으로 꺾어 마을길 진입';
    if (distanceKm < 8.0) return '5km 직진 · 해녀박물관 방향';
    if (distanceKm < 12.0) return '왼쪽으로 꺾어 해안 산책로';
    return '3km 직진 · 완주 지점으로 이동';
  }

  static String _hallasanInstruction(double distanceKm) {
    if (distanceKm < 0.8) return '800m 직진 · 숲길을 따라가세요';
    if (distanceKm < 1.4) return '오른쪽으로 꺾어 한라산 라인 시작';
    if (distanceKm < 2.2) return '왼쪽으로 꺾어 능선 모양 완성';
    return '800m 직진 · 출발지로 돌아가기';
  }

  static String _orangeInstruction(double distanceKm) {
    if (distanceKm < 0.7) return '700m 직진 · 귤 모양 외곽 시작';
    if (distanceKm < 1.2) return '오른쪽으로 꺾어 해안도로 방향';
    if (distanceKm < 2.1) return '900m 직진 · 귤 라인 따라가기';
    if (distanceKm < 2.6) return '왼쪽으로 꺾어 꼭지 구간';
    return '400m 직진 · 완주 지점 도착';
  }

  static String _dolphinInstruction(double distanceKm) {
    if (distanceKm < 1.0) return '1km 직진 · 돌고래 등 라인 시작';
    if (distanceKm < 2.0) return '오른쪽으로 크게 꺾어 해안 방향';
    if (distanceKm < 3.5) return '1.5km 직진 · 꼬리 구간으로 이동';
    if (distanceKm < 4.3) return '왼쪽으로 꺾어 꼬리 모양 완성';
    return '마지막 직진 · 출발지 방향으로 완주';
  }
}
