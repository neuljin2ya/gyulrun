class WeatherData {
  const WeatherData({
    required this.locationName,
    required this.temperature,
    required this.apparentTemperature,
    required this.windSpeed,
    required this.precipitation,
    required this.weatherCode,
  });

  final String locationName;
  final double temperature;
  final double apparentTemperature;
  final double windSpeed;
  final double precipitation;
  final int weatherCode;

  String get condition {
    if (weatherCode == 0) return '맑음';
    if (weatherCode <= 3) return '구름 조금';
    if (weatherCode <= 48) return '안개';
    if (weatherCode <= 67) return '비';
    if (weatherCode <= 77) return '눈';
    if (weatherCode <= 82) return '소나기';
    if (weatherCode <= 86) return '눈 소나기';
    return '천둥번개';
  }
}
