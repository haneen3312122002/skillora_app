import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobCoverImageViewModel extends StateNotifier<Uint8List?> {
  JobCoverImageViewModel(this._jobId) : super(null) {
    _loadInitial();
  }

  final String _jobId;
  static const _prefix = 'job_cover_';

  Future<void> _loadInitial() async {
    final prefs = await SharedPreferences.getInstance();
    final base64 = prefs.getString('$_prefix$_jobId');
    if (base64 == null) return;

    try {
      state = base64Decode(base64);
    } catch (_) {
      state = null;
    }
  }

  /// ✅ returns null on success, or messageKey on failure
  Future<String?> saveCover(Uint8List bytes) async {
    try {
      state = bytes;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_prefix$_jobId', base64Encode(bytes));
      return null;
    } catch (_) {
      return 'cover_image_update_failed';
    }
  }

  Future<void> clear() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefix$_jobId');
  }
}

final jobCoverImageViewModelProvider =
    StateNotifierProviderFamily<JobCoverImageViewModel, Uint8List?, String>(
  (ref, jobId) => JobCoverImageViewModel(jobId),
);
