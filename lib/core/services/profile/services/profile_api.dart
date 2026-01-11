import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ProfileApi {
  Stream<DocumentSnapshot<Map<String, dynamic>>> watchProfile(String uid);

  Future<void> updateName(String name);
  Future<void> updateEmail(String email);
  Future<void> setBio(String? bio);

  Future<String> uploadProfileImage(Uint8List bytes);
  Future<String> uploadCoverImage(Uint8List bytes);
}
