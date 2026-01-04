import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectImageStorageState {

  final Map<String, Uint8List?> covers;

  const ProjectImageStorageState({
    this.covers = const {},
  });

  ProjectImageStorageState copyWith({
    Map<String, Uint8List?>? covers,
  }) {
    return ProjectImageStorageState(
      covers: covers ?? this.covers,
    );
  }
}

class ProjectImageStorageNotifier
    extends StateNotifier<ProjectImageStorageState> {
  ProjectImageStorageNotifier() : super(const ProjectImageStorageState()) {
    _loadInitial();
  }

  static const _prefix = 'project_cover_';

  Future<void> _loadInitial() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(_prefix));

    final map = <String, Uint8List?>{};

    for (final key in keys) {
      final base64Str = prefs.getString(key);
      if (base64Str == null) continue;

      try {
        final bytes = base64Decode(base64Str);
        final projectId = key.replaceFirst(_prefix, '');
        map[projectId] = bytes;
      } catch (_) {

      }
    }

    state = ProjectImageStorageState(covers: map);
  }

  Future<void> saveCover(String projectId, Uint8List bytes) async {
    final newMap = Map<String, Uint8List?>.from(state.covers)
      ..[projectId] = bytes;

    state = state.copyWith(covers: newMap);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '$_prefix$projectId',
      base64Encode(bytes),
    );
  }

  Future<void> clearCover(String projectId) async {
    final newMap = Map<String, Uint8List?>.from(state.covers)
      ..remove(projectId);

    state = state.copyWith(covers: newMap);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefix$projectId');
  }

  Uint8List? getCover(String projectId) => state.covers[projectId];
}

final projectImageStorageProvider = StateNotifierProvider<
    ProjectImageStorageNotifier, ProjectImageStorageState>(
  (ref) => ProjectImageStorageNotifier(),
);