import 'package:flutter/material.dart';
import 'package:gyulrun/model/weather_data.dart';
import 'package:gyulrun/service/weather_service.dart';

class CurrentWeatherCard extends StatefulWidget {
  const CurrentWeatherCard({super.key, this.service});

  final WeatherService? service;

  @override
  State<CurrentWeatherCard> createState() => _CurrentWeatherCardState();
}

class _CurrentWeatherCardState extends State<CurrentWeatherCard> {
  late final WeatherService _service;
  late Future<WeatherData> _weather;

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? WeatherService();
    _weather = _service.getCurrentWeather();
  }

  void _reload() {
    setState(() => _weather = _service.getCurrentWeather());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 112,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(10),
      ),
      child: FutureBuilder<WeatherData>(
        future: _weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _LoadingWeather();
          }
          if (snapshot.hasError) {
            return _WeatherError(
              message: snapshot.error.toString(),
              onRetry: _reload,
            );
          }
          return _WeatherContent(data: snapshot.requireData);
        },
      ),
    );
  }
}

class _WeatherContent extends StatelessWidget {
  const _WeatherContent({required this.data});

  final WeatherData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(_weatherIcon(data.weatherCode), color: Colors.white, size: 42),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data.locationName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                data.condition,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '체감 ${data.apparentTemperature.round()}° · '
                '바람 ${data.windSpeed.round()}km/h · '
                '강수 ${data.precipitation.toStringAsFixed(1)}mm',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white60, fontSize: 10),
              ),
            ],
          ),
        ),
        Text(
          '${data.temperature.round()}°',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 42,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  IconData _weatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny_outlined;
    if (code <= 3) return Icons.cloud_outlined;
    if (code <= 48) return Icons.foggy;
    if (code <= 82) return Icons.water_drop_outlined;
    if (code <= 86) return Icons.ac_unit;
    return Icons.thunderstorm_outlined;
  }
}

class _LoadingWeather extends StatelessWidget {
  const _LoadingWeather();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SizedBox.square(
          dimension: 24,
          child: CircularProgressIndicator(
            color: Color(0xFFBAFF29),
            strokeWidth: 2,
          ),
        ),
        SizedBox(width: 14),
        Text('현재 위치의 날씨를 확인하고 있어요', style: TextStyle(color: Colors.white)),
      ],
    );
  }
}

class _WeatherError extends StatelessWidget {
  const _WeatherError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_off_outlined, color: Colors.white, size: 30),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        IconButton(
          onPressed: onRetry,
          tooltip: '다시 시도',
          icon: const Icon(Icons.refresh_rounded, color: Color(0xFFBAFF29)),
        ),
      ],
    );
  }
}
