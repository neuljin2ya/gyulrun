import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class RunTracker extends ChangeNotifier {
  StreamSubscription<Position>? _positionSubscription;
  Timer? _timer;
  final List<LatLng> _route = [];

  Duration _elapsed = Duration.zero;
  double _distanceMeters = 0;
  bool _isPaused = false;
  bool _isLoading = true;
  String? _errorMessage;

  List<LatLng> get route => List.unmodifiable(_route);
  LatLng? get currentPosition => _route.isEmpty ? null : _route.last;
  Duration get elapsed => _elapsed;
  double get distanceKm => _distanceMeters / 1000;
  bool get isPaused => _isPaused;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get calories => distanceKm * 60;

  double get paceMinutesPerKm {
    if (distanceKm < 0.01) return 0;
    final pace = _elapsed.inSeconds / 60 / distanceKm;
    if (pace < 2 || pace > 30 || !pace.isFinite) return 0;
    return pace;
  }

  Future<void> start() async {
    try {
      await _ensurePermission();
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          timeLimit: Duration(seconds: 15),
        ),
      );
      _addPosition(position);
      _isLoading = false;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!_isPaused) {
          _elapsed += const Duration(seconds: 1);
          notifyListeners();
        }
      });
      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 5,
        ),
      ).listen(_addPosition, onError: _handlePositionError);
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _errorMessage = error.toString();
      notifyListeners();
    }
  }

  void togglePause() {
    _isPaused = !_isPaused;
    notifyListeners();
  }

  Future<void> stop() async {
    _timer?.cancel();
    await _positionSubscription?.cancel();
  }

  Future<void> _ensurePermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const RunTrackingException('아이폰의 위치 서비스를 켜주세요.');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const RunTrackingException('러닝 기록을 위해 위치 권한이 필요해요.');
    }
    if (permission == LocationPermission.deniedForever) {
      throw const RunTrackingException('설정에서 위치 권한을 허용해주세요.');
    }
  }

  void _addPosition(Position position) {
    final next = LatLng(position.latitude, position.longitude);
    if (_route.isNotEmpty && !_isPaused) {
      final segmentDistance = Geolocator.distanceBetween(
        _route.last.latitude,
        _route.last.longitude,
        next.latitude,
        next.longitude,
      );
      if (position.accuracy <= 50 &&
          segmentDistance >= 3 &&
          segmentDistance <= 100) {
        _distanceMeters += segmentDistance;
      }
    }
    if (!_isPaused || _route.isEmpty) {
      _route.add(next);
    }
    notifyListeners();
  }

  void _handlePositionError(Object error) {
    _errorMessage = 'GPS 신호를 확인할 수 없어요.';
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _positionSubscription?.cancel();
    super.dispose();
  }
}

class RunTrackingException implements Exception {
  const RunTrackingException(this.message);

  final String message;

  @override
  String toString() => message;
}
