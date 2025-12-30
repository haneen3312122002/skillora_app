import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class AuthService {
  final fb.FirebaseAuth auth;
  final FirebaseFirestore db;

  AuthService({required this.auth, required this.db});

  Future<fb.UserCredential> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final cred = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = cred.user;
    if (user == null) {
      // ما بنعمل Failure هون لأن هاي طبقة تنفيذ
      throw StateError('Firebase returned null user after register');
    }

    await user.updateDisplayName(name);

    await db.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'name': name,
      'email': email,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return cred;
  }

  Future<fb.UserCredential> login({
    required String email,
    required String password,
  }) async {
    _log(
        'login() app=${auth.app.name} projectId=${auth.app.options.projectId}');
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> _removeCurrentTokenFromUid(String uid) async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;

    await db.collection('users').doc(uid).update({
      'fcmTokens': FieldValue.arrayRemove([token]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _addCurrentTokenToUid(String uid) async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;

    await db.collection('users').doc(uid).set({
      'fcmTokens': FieldValue.arrayUnion([token]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<fb.UserCredential> switchAccountWithPassword({
    required String email,
    required String password,
  }) async {
    final oldUid = auth.currentUser?.uid;
    if (oldUid != null) {
      await _removeCurrentTokenFromUid(oldUid);
    }

    // ⚠️ هنا لازم credentials (email/pass) - ما في bypass رسمي بدونها
    final cred = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final newUid = cred.user?.uid;
    if (newUid != null) {
      await _addCurrentTokenToUid(newUid);
    }

    return cred;
  }

  Future<void> logout() async {
    final uid = auth.currentUser?.uid;
    if (uid != null) await _removeCurrentTokenFromUid(uid);
    await auth.signOut();
  }

  Future<void> sendEmailVerification() async {
    final user = auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<bool> checkEmailVerified() async {
    final user = auth.currentUser;
    if (user == null) return false;
    await user.reload();
    return user.emailVerified;
  }

  // ✅ بدل resetPassword(String) -> String?
  Future<void> sendPasswordResetEmail({required String email}) {
    return auth.sendPasswordResetEmail(email: email);
  }

  void _log(String msg) {
    if (kDebugMode) {
      debugPrint('[AuthService] $msg');
    }
  }
}
