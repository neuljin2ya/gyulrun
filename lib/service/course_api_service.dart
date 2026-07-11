import 'dart:convert';

import 'package:gyulrun/component/course_card.dart';
import 'package:gyulrun/model/course.dart';
import 'package:gyulrun/model/nearby_place_info.dart';
import 'package:gyulrun/service/course_route_guide.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class CourseApiService {
  CourseApiService({http.Client? client, Uri? baseUri})
    : _client = client ?? http.Client(),
      _baseUri =
          baseUri ??
          Uri.parse(
            'https://behalf-triple-locations-military.trycloudflare.com',
          );

  final http.Client _client;
  final Uri _baseUri;
  static bool useLocalDemoData = true;

  Future<List<Course>> fetchPopularCourses() async {
    if (useLocalDemoData) return _demoCourses();

    final requests = [
      _CourseRequest(
        distance: 3,
        start: '성산일출봉',
        preference: '자연',
        shape: 'tangerine',
        weather: '맑음',
      ),
      _CourseRequest(
        distance: 15,
        start: '성산일출봉',
        preference: '해녀',
        shape: 'haenyeo',
        weather: '맑음',
      ),
      _CourseRequest(
        distance: 5,
        start: '협재해수욕장',
        preference: '바다',
        shape: 'dolphin',
        weather: '맑음',
      ),
    ];

    final courses = <Course>[];
    for (final request in requests) {
      try {
        courses.add(await _fetchCourse(request));
      } catch (_) {
        // 해커톤 현장 네트워크/터널이 잠깐 끊겨도 홈 화면은 fallback으로 유지합니다.
      }
    }
    return courses;
  }

  List<Course> _demoCourses() {
    return [
      Course(
        name: '귤런',
        distanceKm: 3.01,
        address: '서귀포시 성산읍 동류암로 20 플레이스캠프 제주',
        difficulty: CourseDifficulty.easy,
        route: CourseRouteGuide.routeFor('귤런'),
        routeModeLabel: '보행로 우선',
        shapeMatch: 96,
        aiScore: 94,
        safetyScore: 93,
        weatherName: '맑음',
        paceNote: '플레이스캠프 제주 출발 · 방문자 적고 경사가 완만한 코스',
        cctvSource: '18',
        visitorsSource: '적음',
        nearbyPlaces: const [
          NearbyPlaceInfo(name: '플레이스캠프 제주', address: '서귀포시 성산읍 동류암로 20'),
          NearbyPlaceInfo(name: '성산일출봉', address: '서귀포시 성산읍 일출로 284-12'),
          NearbyPlaceInfo(name: '광치기해변', address: '서귀포시 성산읍 고성리'),
        ],
      ),
      Course(
        name: '해녀런',
        distanceKm: 15.04,
        address: '제주시 구좌읍 해녀박물관길',
        difficulty: CourseDifficulty.hard,
        route: CourseRouteGuide.routeFor('해녀런'),
        routeModeLabel: '해안도로 우선',
        shapeMatch: 89,
        aiScore: 91,
        safetyScore: 91,
        weatherName: '맑음',
        paceNote: '해녀박물관 인근 출발 · 해안 경관 중심 장거리 코스',
        cctvSource: '24',
        visitorsSource: '보통',
        nearbyPlaces: const [
          NearbyPlaceInfo(name: '제주해녀박물관', address: '제주시 구좌읍 해녀박물관길 26'),
          NearbyPlaceInfo(name: '세화해변', address: '제주시 구좌읍 세화리'),
          NearbyPlaceInfo(name: '하도해변', address: '제주시 구좌읍 하도리'),
        ],
      ),
      Course(
        name: '돌고래런',
        distanceKm: 5.01,
        address: '제주시 한림읍 협재해수욕장',
        difficulty: CourseDifficulty.normal,
        route: CourseRouteGuide.routeFor('돌고래런'),
        routeModeLabel: '자연경관 우선',
        shapeMatch: 92,
        aiScore: 95,
        safetyScore: 94,
        weatherName: '맑음',
        paceNote: '협재해수욕장 출발 · 바다 전망과 낮은 혼잡도 반영',
        cctvSource: '12',
        visitorsSource: '적음',
        nearbyPlaces: const [
          NearbyPlaceInfo(name: '협재해수욕장', address: '제주시 한림읍 협재리 2497-1'),
          NearbyPlaceInfo(name: '한림공원', address: '제주시 한림읍 한림로 300'),
          NearbyPlaceInfo(name: '금능해수욕장', address: '제주시 한림읍 금능리'),
        ],
      ),
    ];
  }

  Future<Course> _fetchCourse(_CourseRequest request) async {
    final uri = _baseUri.replace(
      path: '/api/v1/courses',
      queryParameters: {
        'distance': request.distance.toStringAsFixed(1),
        'start': request.start,
        'preference': request.preference,
        'shape': request.shape,
        'weather': request.weather,
      },
    );

    final response = await _client.get(uri).timeout(const Duration(seconds: 8));
    if (response.statusCode != 200) {
      throw StateError('코스 API 오류: ${response.statusCode}');
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    if (json is! Map<String, dynamic>) {
      throw const FormatException('코스 API 응답 형식이 올바르지 않아요.');
    }
    return _courseFromJson(json);
  }

  Course _courseFromJson(Map<String, dynamic> json) {
    final shapeLabel = _readString(json['shapeLabel'], fallback: '귤');
    final distanceKm = _readDouble(json['distanceKm']);
    final startName = _readString(json['startName'], fallback: '제주');
    final route = _routeFromGeoJson(json['geojson']);
    final topPlaces = _placesFromJson(json['topPlaces']);
    final olle = json['olle'] is Map<String, dynamic>
        ? json['olle'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final scores = json['scores'] is Map<String, dynamic>
        ? json['scores'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final dataSources = json['dataSources'] is Map<String, dynamic>
        ? json['dataSources'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final olleName = _readString(olle['name']);

    return Course(
      name: '$shapeLabel런',
      distanceKm: distanceKm,
      address: olleName.isEmpty ? startName : '$startName · $olleName',
      difficulty: _difficultyFor(distanceKm),
      route: route,
      routeModeLabel: _readString(json['routeModeLabel']),
      shapeMatch: _readInt(json['shapeMatch']),
      aiScore: _readDouble(scores['ai']),
      safetyScore: _readInt(scores['safety']),
      weatherName: _readString(json['weatherName']),
      paceNote: _readString(json['paceNote']),
      cctvSource: _readString(dataSources['cctv']),
      visitorsSource: _readString(dataSources['visitors']),
      nearbyPlaces: topPlaces,
    );
  }

  static CourseDifficulty _difficultyFor(double distanceKm) {
    if (distanceKm <= 5) return CourseDifficulty.easy;
    if (distanceKm <= 12) return CourseDifficulty.normal;
    return CourseDifficulty.hard;
  }

  static List<LatLng> _routeFromGeoJson(Object? geoJson) {
    if (geoJson is! Map<String, dynamic>) return const <LatLng>[];
    final geometry = geoJson['geometry'];
    if (geometry is! Map<String, dynamic>) return const <LatLng>[];
    final type = geometry['type'];
    final coordinates = geometry['coordinates'];

    if (type == 'LineString' && coordinates is List) {
      return _lineStringFromCoordinates(coordinates);
    }
    if (type == 'MultiLineString' && coordinates is List) {
      return coordinates
          .whereType<List>()
          .expand(_lineStringFromCoordinates)
          .toList(growable: false);
    }
    if (type == 'Polygon' && coordinates is List && coordinates.isNotEmpty) {
      final outerRing = coordinates.first;
      if (outerRing is List) return _lineStringFromCoordinates(outerRing);
    }
    return const <LatLng>[];
  }

  static List<LatLng> _lineStringFromCoordinates(List<dynamic> coordinates) {
    return coordinates
        .whereType<List>()
        .where((point) => point.length >= 2)
        .map((point) {
          final lng = _readDouble(point[0]);
          final lat = _readDouble(point[1]);
          return LatLng(lat, lng);
        })
        .where((point) => point.latitude != 0 && point.longitude != 0)
        .toList(growable: false);
  }

  static List<NearbyPlaceInfo> _placesFromJson(Object? places) {
    if (places is! List) return const <NearbyPlaceInfo>[];
    return places
        .whereType<Map<String, dynamic>>()
        .map((place) {
          final name = _readString(place['name'], fallback: '주변 명소');
          final category = _readString(place['category'], fallback: '관광지');
          final lat = _readDouble(place['lat']);
          final lng = _readDouble(place['lng']);
          final source = _readString(place['source']);
          final location = lat == 0 || lng == 0
              ? category
              : '$category · ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
          return NearbyPlaceInfo(
            name: name,
            address: source.isEmpty ? location : '$location · $source',
          );
        })
        .toList(growable: false);
  }

  static String _readString(Object? value, {String fallback = ''}) {
    if (value == null) return fallback;
    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }

  static double _readDouble(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int? _readInt(Object? value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }
}

class _CourseRequest {
  const _CourseRequest({
    required this.distance,
    required this.start,
    required this.preference,
    required this.shape,
    required this.weather,
  });

  final double distance;
  final String start;
  final String preference;
  final String shape;
  final String weather;
}
