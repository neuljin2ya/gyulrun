import 'dart:typed_data';

import 'package:flutter/services.dart' show MethodChannel;

class GallerySaveService {
  const GallerySaveService();

  static const _channel = MethodChannel('gyulrun/gallery');

  Future<bool> saveImage(Uint8List bytes) async {
    final saved = await _channel.invokeMethod<bool>('saveImage', bytes);
    return saved ?? false;
  }
}
