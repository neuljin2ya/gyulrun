import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gyulrun/component/nearby_place_section.dart';
import 'package:gyulrun/component/run_history_carousel.dart';
import 'package:gyulrun/component/running_bottom_navigation_bar.dart';
import 'package:gyulrun/model/nearby_place_info.dart';
import 'package:gyulrun/model/run_result.dart';
import 'package:gyulrun/navigation/app_routes.dart';
import 'package:gyulrun/service/map_service.dart';
import 'package:gyulrun/service/run_history_store.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key, this.mapService = const MapService()});

  final MapService mapService;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedHistoryIndex = 0;
  bool _isLoadingNearby = false;
  Timer? _nearbyLoadingTimer;

  @override
  void dispose() {
    _nearbyLoadingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entries = RunHistoryStore.instance.entries;
    final selectedResult = entries.isEmpty
        ? null
        : entries[_selectedHistoryIndex.clamp(0, entries.length - 1)].result;
    final nearbyPlaces = selectedResult == null
        ? const <NearbyPlaceInfo>[]
        : _nearbyPlacesFor(selectedResult);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 110),
              children: [
                const Text(
                  'History',
                  style: TextStyle(
                    color: Color(0xFF252525),
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                if (entries.isEmpty) ...[
                  const _EmptyHistoryState(),
                ] else ...[
                  RunHistoryCarousel(
                    entries: entries,
                    onPageChanged: (index) {
                      _changeHistoryCard(index);
                    },
                  ),
                  const SizedBox(height: 22),
                  if (_isLoadingNearby)
                    const _NearbyLoadingState()
                  else
                    NearbyPlaceSection(
                      places: nearbyPlaces,
                      onPlaceTap: (place) => _openMap(place.address),
                    ),
                ],
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
                onStatsTap: () {},
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

  void _changeHistoryCard(int index) {
    _nearbyLoadingTimer?.cancel();
    setState(() {
      _selectedHistoryIndex = index;
      _isLoadingNearby = true;
    });
    _nearbyLoadingTimer = Timer(const Duration(seconds: 1), () {
      if (!mounted || _selectedHistoryIndex != index) return;
      setState(() => _isLoadingNearby = false);
    });
  }

  Future<void> _openMap(String address) async {
    final opened = await widget.mapService.openNaverMap(address);
    if (!opened && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('네이버 지도를 열 수 없어요.')));
    }
  }

  List<NearbyPlaceInfo> _nearbyPlacesFor(RunResult result) {
    if (_isGuidedCourse(result.courseName) && result.nearbyPlaces.isNotEmpty) {
      return result.nearbyPlaces;
    }

    return switch (result.courseName) {
      '해녀런' => const [
        NearbyPlaceInfo(name: '제주해녀박물관', address: '제주시 구좌읍 해녀박물관길 26'),
        NearbyPlaceInfo(name: '세화해변', address: '제주시 구좌읍 세화리'),
        NearbyPlaceInfo(name: '카페공작소', address: '제주시 구좌읍 해맞이해안로 1446'),
      ],
      '돌고래런' => const [
        NearbyPlaceInfo(name: '협재해수욕장', address: '제주시 한림읍 협재리 2497-1'),
        NearbyPlaceInfo(name: '한림공원', address: '제주시 한림읍 한림로 300'),
        NearbyPlaceInfo(name: '금능해변', address: '제주시 한림읍 금능리'),
      ],
      '한라산런' => const [
        NearbyPlaceInfo(name: '한라산 1100고지', address: '서귀포시 1100로 1555'),
        NearbyPlaceInfo(name: '어승생악', address: '제주시 해안동 산220-12'),
        NearbyPlaceInfo(name: '관음사', address: '제주시 산록북로 660'),
      ],
      '오름런' => const [
        NearbyPlaceInfo(name: '거문오름', address: '제주시 조천읍 선교로 569-36'),
        NearbyPlaceInfo(name: '선흘곶자왈', address: '제주시 조천읍 동백로 77'),
        NearbyPlaceInfo(name: '동백동산', address: '제주시 조천읍 동백로 77'),
      ],
      _ => const [
        NearbyPlaceInfo(name: '플레이스캠프 제주', address: '서귀포시 성산읍 동류암로 20'),
        NearbyPlaceInfo(name: '광치기해변', address: '서귀포시 성산읍 고성리 224-33'),
        NearbyPlaceInfo(name: '성산일출봉', address: '서귀포시 성산읍 성산리 1'),
      ],
    };
  }

  bool _isGuidedCourse(String courseName) {
    return switch (courseName) {
      '귤런' || '해녀런' || '돌고래런' || '한라산런' || '오름런' => true,
      _ => false,
    };
  }
}

class _NearbyLoadingState extends StatelessWidget {
  const _NearbyLoadingState();

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('nearby_loading'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '주변',
          style: TextStyle(
            color: Color(0xFF252525),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 126,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: const Color(0xFFF5FFF9),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            children: [
              SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Color(0xFF9DFF00),
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Text(
                  '러닝 위치에 맞는 주변 장소를 찾는 중이에요',
                  style: TextStyle(
                    color: Color(0xFF252525),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmptyHistoryState extends StatelessWidget {
  const _EmptyHistoryState();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 460,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.directions_run_rounded,
            size: 52,
            color: Color(0xFFB8B8B8),
          ),
          SizedBox(height: 16),
          Text(
            '아직 완주 기록이 없어요',
            style: TextStyle(
              color: Color(0xFF252525),
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '코스를 완주하면 이곳에 카드가 쌓여요',
            style: TextStyle(
              color: Color(0xFF888888),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
