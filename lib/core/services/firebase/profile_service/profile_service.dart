import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileService {
  final fb.FirebaseAuth auth;
  final FirebaseFirestore db;
  final FirebaseStorage storage;

  ProfileService({
    required this.auth,
    required this.db,
    required this.storage,
  });

  // get user doc:
  DocumentReference<Map<String, dynamic>> _userDoc(String uid) {
    return db.collection('users').doc(uid);
  }

  // current user:
  fb.User? get currentUser => auth.currentUser;

  // get profile data: photo + email + name
  Future<Map<String, dynamic>?> getProfile() async {
    final user = currentUser;
    if (user == null) return null;

    final doc = await _userDoc(user.uid).get();
    if (!doc.exists) return null;

    final data = doc.data()!;
    return {
      'uid': user.uid,
      'name': data['name'] ?? user.displayName,
      'email': data['email'] ?? user.email,
      'photoUrl': data['photoUrl'],
      'coverUrl': data['coverUrl'],
      'createdAt': data['createdAt'],
    };
  }

  // upload profile photo
  Future<String> uploadProfileImage(Uint8List bytes) async {
    final user = currentUser;
    if (user == null) {
      throw Exception('No logged in user');
    }

    final ref =
        storage.ref().child('users').child(user.uid).child('profile.jpg');

    await ref.putData(bytes);
    final url = await ref.getDownloadURL();

    // save the url:
    await _userDoc(user.uid).update({'photoUrl': url});
    await user.updatePhotoURL(url);

    return url;
  }

  // upload covoer photo
  Future<String> uploadCoverImage(Uint8List bytes) async {
    final user = currentUser;
    if (user == null) {
      throw Exception('No logged in user');
    }

    final ref = storage.ref().child('users').child(user.uid).child('cover.jpg');

    await ref.putData(bytes);
    final url = await ref.getDownloadURL();

    // save the link in firestore
    await _userDoc(user.uid).update({'coverUrl': url});

    return url;
  }

  //update name + email
  Future<void> updateName(String name) async {
    final user = currentUser;
    if (user == null) {
      throw Exception('No logged in user');
    }

    if (name.isEmpty) return;

    await user.updateDisplayName(name);

    await _userDoc(user.uid).update({
      'name': name,
    });
  }

  Future<void> updateEmail(String email) async {
    final user = currentUser;
    if (user == null) {
      throw Exception('No logged in user');
    }

    if (email.isEmpty || email == user.email) return;

    // send verfy msg :
    await user.verifyBeforeUpdateEmail(email);

    await _userDoc(user.uid).update({
      'email': email,
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchProfile() {
    final user = currentUser;
    if (user == null) {
      return const Stream.empty();
    }
    return _userDoc(user.uid).snapshots();
  }
}
