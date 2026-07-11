import 'dart:typed_data';

import 'package:gyulrun/model/run_result.dart';

class RunHistoryEntry {
  const RunHistoryEntry({
    required this.result,
    required this.rating,
    required this.photoBytes,
    required this.completedAt,
  });

  final RunResult result;
  final int rating;
  final Uint8List photoBytes;
  final DateTime completedAt;
}
