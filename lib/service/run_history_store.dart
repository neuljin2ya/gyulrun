import 'package:gyulrun/model/run_history_entry.dart';

class RunHistoryStore {
  RunHistoryStore._();

  static final instance = RunHistoryStore._();

  final List<RunHistoryEntry> _entries = [];

  List<RunHistoryEntry> get entries => List.unmodifiable(_entries);
  RunHistoryEntry? get latest => _entries.isEmpty ? null : _entries.first;

  void add(RunHistoryEntry entry) {
    _entries.insert(0, entry);
  }

  void clear() => _entries.clear();
}
