// lib/modules/users/services/users_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_tasks/core/shared/enums/role.dart';
import 'package:notes_tasks/modules/users/data/models/app_user_model.dart';

class UsersService {
  final FirebaseFirestore _db;
  UsersService(this._db);

  CollectionReference<Map<String, dynamic>> get _col => _db.collection('users');

  Future<List<AppUserModel>> getUsers({UserRole? role}) async {
    Query<Map<String, dynamic>> q = _col;

    if (role != null) {
      q = q.where('role', isEqualTo: role.name);
    }

    final snap = await q.get();
    return snap.docs.map((d) => AppUserModel.fromMap(d.id, d.data())).toList();
  }

  Future<void> setUserRole({
    required String userId,
    required UserRole role,
  }) {
    return _col.doc(userId).update({'role': role.name});
  }

  Future<void> setUserDisabled({
    required String userId,
    required bool isDisabled,
  }) {
    return _col.doc(userId).update({'isDisabled': isDisabled});
  }

  /// هذا فقط يحذف وثيقة Firestore، مش حساب Firebase Auth
  Future<void> deleteUserDoc(String userId) {
    return _col.doc(userId).delete();
  }

  Future<void> softDeleteUser(String userId) {
    return _col.doc(userId).update({
      'isDeleted': true,
      'deletedAt': FieldValue.serverTimestamp(),
    });
  }
}
