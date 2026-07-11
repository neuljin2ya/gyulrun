import 'dart:convert';
import 'dart:ui';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gyulrun/model/weather_data.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<WeatherData> getCurrentWeather() async {
    final position = await _getPosition();
    final locationName = await _getLocationName(position);
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '${position.latitude}',
      'longitude': '${position.longitude}',
      'current':
          'temperature_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m',
      'timezone': 'auto',
    });

    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw const WeatherException('날씨 정보를 불러오지 못했어요.');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final current = json['current'] as Map<String, dynamic>?;
    if (current == null) {
      throw const WeatherException('날씨 정보 형식이 올바르지 않아요.');
    }

    return WeatherData(
      locationName: locationName,
      temperature: (current['temperature_2m'] as num).toDouble(),
      apparentTemperature: (current['apparent_temperature'] as num).toDouble(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      precipitation: (current['precipitation'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
    );
  }

  Future<Position> _getPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const WeatherException('아이폰의 위치 서비스를 켜주세요.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const WeatherException('현재 위치 날씨를 보려면 위치 권한이 필요해요.');
    }
    if (permission == LocationPermission.deniedForever) {
      throw const WeatherException('설정에서 귤런의 위치 권한을 허용해주세요.');
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 12),
      ),
    );
  }

  Future<String> _getLocationName(Position position) async {
    try {
      final placemarks = await Geocoding(
        locale: const Locale('ko', 'KR'),
      ).placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isEmpty) return '현재 위치';
      final place = placemarks.first;
      return _firstNotEmpty([
        place.subLocality,
        place.locality,
        place.subAdministrativeArea,
        place.administrativeArea,
      ]);
    } catch (_) {
      return '현재 위치';
    }
  }

  String _firstNotEmpty(List<String?> values) {
    return values.firstWhere(
          (value) => value != null && value.trim().isNotEmpty,
          orElse: () => '현재 위치',
        ) ??
        '현재 위치';
  }
}

class WeatherException implements Exception {
  const WeatherException(this.message);

  final String message;

  @override
  String toString() => message;
}
