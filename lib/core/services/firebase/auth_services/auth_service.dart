import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final fb.FirebaseAuth auth;
  final FirebaseFirestore db;

  AuthService({required this.auth, required this.db});

  //  Register new user
  Future<fb.UserCredential> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final cred = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await cred.user!.updateDisplayName(name);
    await db.collection('users').doc(cred.user!.uid).set({
      'uid': cred.user!.uid,
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return cred;
  }

  // Login existing user
  Future<fb.UserCredential> login({
    required String email,
    required String password,
  }) async {
    debugPrint(
        '[Service] login() on app=${auth.app.name} projectId=${auth.app.options.projectId}');
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  //  Logout user
  Future<void> logout() => auth.signOut();

  //  Send email verification (NEW METHOD)
  Future<void> sendEmailVerification() async {
    final user = auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  //   Check if email verified
  Future<bool> checkEmailVerified() async {
    final user = auth.currentUser;
    if (user == null) return false;
    await user.reload();
    return user.emailVerified;
  }

  //reset password:
  Future<String?> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return null; //no error
    } on FirebaseAuthException catch (e) {
      //type of the error:firebase
      // error
      return e.message ?? 'somthing went wrong';
    } catch (e) {
      return 'error';
    }
  }
}
