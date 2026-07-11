import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gyulrun/component/activity_photo_card.dart';
import 'package:gyulrun/component/primary_button.dart';
import 'package:gyulrun/component/star_rating_input.dart';
import 'package:gyulrun/model/run_history_entry.dart';
import 'package:gyulrun/model/run_result.dart';
import 'package:gyulrun/navigation/app_routes.dart';
import 'package:gyulrun/service/camera_service.dart';
import 'package:gyulrun/service/gallery_save_service.dart';
import 'package:gyulrun/service/run_history_store.dart';

class RunCompleteScreen extends StatefulWidget {
  const RunCompleteScreen({
    super.key,
    required this.result,
    this.cameraService,
    this.gallerySaveService = const GallerySaveService(),
  });

  final RunResult result;
  final CameraService? cameraService;
  final GallerySaveService gallerySaveService;

  @override
  State<RunCompleteScreen> createState() => _RunCompleteScreenState();
}

class _RunCompleteScreenState extends State<RunCompleteScreen> {
  final _cardKey = GlobalKey();
  late final CameraService _cameraService;
  Uint8List? _photoBytes;
  int _rating = 0;
  bool _isTakingPhoto = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _cameraService = widget.cameraService ?? CameraService();
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.sizeOf(context).width * 0.72;
    return Scaffold(
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(24, 8, 24, 14),
        child: PrimaryButton(
          label: '완료',
          isLoading: _isSaving,
          onPressed: _photoBytes != null && _rating > 0 && !_isSaving
              ? _save
              : null,
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: cardWidth,
                      child: RepaintBoundary(
                        key: _cardKey,
                        child: ActivityPhotoCard(
                          title: widget.result.courseName,
                          distanceKm: widget.result.distanceKm,
                          image: _photoBytes == null
                              ? null
                              : MemoryImage(_photoBytes!),
                          emptyMessage: _isTakingPhoto
                              ? '카메라를 여는 중이에요'
                              : '눌러서 완주 사진을 찍어주세요',
                          titleTop: 48,
                          titleFontSize: 70,
                          distanceBottom: 56,
                          onCapture: _takePhoto,
                          onTap: _takePhoto,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      '오늘의 러닝은 어땠나요?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    StarRatingInput(
                      value: _rating,
                      onChanged: (value) => setState(() => _rating = value),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<Uint8List> _captureCardImage() async {
    await WidgetsBinding.instance.endOfFrame;
    final boundary =
        _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      throw StateError('완주 카드를 찾을 수 없어요.');
    }
    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw StateError('완주 카드 이미지를 만들 수 없어요.');
    }
    return byteData.buffer.asUint8List();
  }

  Future<void> _showSavedDialog({
    required Uint8List cardBytes,
    required bool gallerySaved,
  }) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.memory(
                    cardBytes,
                    width: 170,
                    height: 226,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  gallerySaved ? '카드 사진 저장되었습니다.' : '카드 사진을 만들었어요.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF252525),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${widget.result.courseName} · ${_formatDistance(widget.result.distanceKm)} KM',
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (!gallerySaved) ...[
                  const SizedBox(height: 8),
                  const Text(
                    '갤러리 저장 권한을 확인해주세요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF888888), fontSize: 13),
                  ),
                ],
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFBAFF29),
                      foregroundColor: const Color(0xFF252525),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '확인',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _takePhoto() async {
    if (_isTakingPhoto) return;
    setState(() => _isTakingPhoto = true);
    try {
      final bytes = await _cameraService.takePhoto();
      if (bytes != null && mounted) {
        setState(() => _photoBytes = bytes);
      }
    } finally {
      if (mounted) setState(() => _isTakingPhoto = false);
    }
  }

  Future<void> _save() async {
    if (_photoBytes == null || _rating == 0 || _isSaving) return;
    setState(() => _isSaving = true);
    try {
      final cardBytes = await _captureCardImage();
      var gallerySaved = false;
      try {
        gallerySaved = await widget.gallerySaveService.saveImage(cardBytes);
      } catch (_) {
        gallerySaved = false;
      }

      RunHistoryStore.instance.add(
        RunHistoryEntry(
          result: widget.result,
          rating: _rating,
          photoBytes: _photoBytes!,
          completedAt: DateTime.now(),
        ),
      );

      if (!mounted) return;
      await _showSavedDialog(cardBytes: cardBytes, gallerySaved: gallerySaved);
      if (mounted) {
        AppRoutes.replace(context, AppRoutes.home);
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  static String _formatDistance(double value) {
    return value.toStringAsFixed(2);
  }
}
