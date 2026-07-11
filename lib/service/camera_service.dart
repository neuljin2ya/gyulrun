import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class CameraService {
  CameraService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<Uint8List?> takePhoto() async {
    final photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 88,
      maxWidth: 1600,
    );
    return photo?.readAsBytes();
  }
}
