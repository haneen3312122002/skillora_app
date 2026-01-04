import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/data/remote/firebase/providers/firebase_providers.dart';
import 'package:notes_tasks/core/shared/enums/role.dart';

final userRoleProvider = FutureProvider<UserRole>((ref) async {
  final authService = ref.read(authServiceProvider);
  return authService.fetchCurrentUserRole();
});
