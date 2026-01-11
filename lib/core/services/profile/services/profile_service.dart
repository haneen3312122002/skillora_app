import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_storage/firebase_storage.dart';

import 'package:notes_tasks/core/services/profile/services/profile_api.dart';
import 'package:notes_tasks/core/services/profile/services/profile_experiences_services.dart';
import 'package:notes_tasks/core/services/profile/services/profile_projects_services.dart';
import 'package:notes_tasks/core/services/profile/services/profile_skills_services.dart';

class ProfileService
    implements
        ProfileApi,
        ProfileProjectsApi,
        ProfileExperiencesApi,
        ProfileSkillsApi {
  final fb.FirebaseAuth auth;
  final FirebaseFirestore db;
  final FirebaseStorage storage;

  ProfileService({
    required this.auth,
    required this.db,
    required this.storage,
  });

  // =============================
  // Helpers
  // =============================

  fb.User? get _currentUser => auth.currentUser;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) {
    return db.collection('users').doc(uid);
  }

  CollectionReference<Map<String, dynamic>> _experiencesCol(String uid) {
    return _userDoc(uid).collection('experiences');
  }

  CollectionReference<Map<String, dynamic>> _projectsCol(String uid) {
    return _userDoc(uid).collection('projects');
  }

  DateTime? _toDate(dynamic v) {
    if (v is Timestamp) return v.toDate();
    return null;
  }

  // =============================
  // PROFILE (Api)
  // =============================

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> watchProfile(String uid) {
    final cleaned = uid.trim();
    if (cleaned.isEmpty) return const Stream.empty();

    // ✅ FIX: must be a full doc ref: users/{uid}
    return _userDoc(cleaned).snapshots();
  }

  // =============================
  // EXPERIENCES (Maps stream)
  // =============================

  Stream<List<Map<String, dynamic>>> watchExperiencesMaps(String uid) {
    final cleaned = uid.trim();
    if (cleaned.isEmpty) return const Stream.empty();

    return _experiencesCol(cleaned)
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) {
        final data = doc.data();
        return <String, dynamic>{
          'id': doc.id,
          'title': (data['title'] as String?) ?? '',
          'company': (data['company'] as String?) ?? '',
          'startDate': _toDate(data['startDate']),
          'endDate': _toDate(data['endDate']),
          'location': (data['location'] as String?) ?? '',
          'description': (data['description'] as String?) ?? '',
        };
      }).toList();
    });
  }

  // =============================
  // PROJECTS (Maps stream)
  // =============================

  Stream<List<Map<String, dynamic>>> watchProjectsMaps(String uid) {
    final cleaned = uid.trim();
    if (cleaned.isEmpty) return const Stream.empty();

    return _projectsCol(cleaned)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) {
        final data = doc.data();
        return <String, dynamic>{
          'id': doc.id,
          'title': (data['title'] as String?) ?? '',
          'description': (data['description'] as String?) ?? '',
          'tools': (data['tools'] as List<dynamic>? ?? const [])
              .map((e) => e.toString())
              .toList(),
          'imageUrl': data['imageUrl'] as String?,
          'projectUrl': data['projectUrl'] as String?,
          'createdAt': _toDate(data['createdAt']),
          'updatedAt': _toDate(data['updatedAt']),
        };
      }).toList();
    });
  }

  void _requireUser() {
    if (_currentUser == null) {
      throw Exception('No logged in user');
    }
  }

  // =============================
  // PROFILE UPDATE
  // =============================

  @override
  Future<void> updateName(String name) async {
    final user = _currentUser;
    if (user == null) throw Exception('No logged in user');

    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    await user.updateDisplayName(trimmed);
    await _userDoc(user.uid).update({'name': trimmed});
  }

  @override
  Future<void> updateEmail(String email) async {
    final user = _currentUser;
    if (user == null) throw Exception('No logged in user');

    final trimmed = email.trim();
    if (trimmed.isEmpty || trimmed == user.email) return;

    await user.verifyBeforeUpdateEmail(trimmed);
    await _userDoc(user.uid).update({'email': trimmed});
  }

  @override
  Future<void> setBio(String? bio) async {
    final user = _currentUser;
    if (user == null) throw Exception('No logged in user');

    await _userDoc(user.uid).update({'bio': bio});
  }

  // =============================
  // PROFILE IMAGES
  // =============================

  @override
  Future<String> uploadProfileImage(Uint8List bytes) async {
    final user = _currentUser;
    if (user == null) throw Exception('No logged in user');

    final ref = storage.ref().child('users/${user.uid}/profile.jpg');
    await ref.putData(bytes);

    final url = await ref.getDownloadURL();
    await _userDoc(user.uid).update({'photoUrl': url});
    await user.updatePhotoURL(url);

    return url;
  }

  @override
  Future<String> uploadCoverImage(Uint8List bytes) async {
    final user = _currentUser;
    if (user == null) throw Exception('No logged in user');

    final ref = storage.ref().child('users/${user.uid}/cover.jpg');
    await ref.putData(bytes);

    final url = await ref.getDownloadURL();
    await _userDoc(user.uid).update({'coverUrl': url});

    return url;
  }

  // =============================
  // SKILLS
  // =============================

  @override
  Future<void> addSkill(String skill) async {
    final user = _currentUser;
    if (user == null) throw Exception('No logged in user');

    final trimmed = skill.trim();
    if (trimmed.isEmpty) return;

    await _userDoc(user.uid).update({
      'skills': FieldValue.arrayUnion([trimmed]),
    });
  }

  @override
  Future<void> removeSkill(String skill) async {
    final user = _currentUser;
    if (user == null) throw Exception('No logged in user');

    final trimmed = skill.trim();
    if (trimmed.isEmpty) return;

    await _userDoc(user.uid).update({
      'skills': FieldValue.arrayRemove([trimmed]),
    });
  }

  @override
  Future<void> setSkills(List<String> skills) async {
    final user = _currentUser;
    if (user == null) throw Exception('No logged in user');

    final cleaned =
        skills.map((s) => s.trim()).where((s) => s.isNotEmpty).toSet().toList();

    await _userDoc(user.uid).update({'skills': cleaned});
  }

  // =============================
  // EXPERIENCES (CRUD)
  // =============================

  @override
  Future<String> addExperience({
    required String title,
    required String company,
    DateTime? startDate,
    DateTime? endDate,
    required String location,
    required String description,
  }) async {
    final user = _currentUser;
    if (user == null) throw Exception('No logged in user');

    final docRef = _experiencesCol(user.uid).doc();
    await docRef.set({
      'title': title,
      'company': company,
      'startDate': startDate,
      'endDate': endDate,
      'location': location,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  @override
  Future<void> updateExperience({
    required String id,
    required String title,
    required String company,
    DateTime? startDate,
    DateTime? endDate,
    required String location,
    required String description,
  }) async {
    final user = _currentUser;
    if (user == null) throw Exception('No logged in user');

    await _experiencesCol(user.uid).doc(id).update({
      'title': title,
      'company': company,
      'startDate': startDate,
      'endDate': endDate,
      'location': location,
      'description': description,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteExperience(String id) async {
    final user = _currentUser;
    if (user == null) throw Exception('No logged in user');

    await _experiencesCol(user.uid).doc(id).delete();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> watchExperiences() {
    final user = _currentUser;
    if (user == null) return const Stream.empty();

    return _experiencesCol(user.uid)
        .orderBy('startDate', descending: true)
        .snapshots();
  }

  // =============================
  // PROJECTS (CRUD)
  // =============================

  @override
  Future<String> addProject({
    required String title,
    required String description,
    List<String> tools = const [],
    String? imageUrl,
    String? projectUrl,
  }) async {
    final user = _currentUser;
    if (user == null) throw Exception('No logged in user');

    final docRef = _projectsCol(user.uid).doc();
    await docRef.set({
      'title': title,
      'description': description,
      'tools': tools,
      'imageUrl': imageUrl,
      'projectUrl': projectUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  @override
  Future<void> updateProject({
    required String id,
    required String title,
    required String description,
    List<String> tools = const [],
    String? imageUrl,
    String? projectUrl,
  }) async {
    final user = _currentUser;
    if (user == null) throw Exception('No logged in user');

    await _projectsCol(user.uid).doc(id).update({
      'title': title,
      'description': description,
      'tools': tools,
      'imageUrl': imageUrl,
      'projectUrl': projectUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> deleteProject(String id) async {
    final user = _currentUser;
    if (user == null) throw Exception('No logged in user');

    await _projectsCol(user.uid).doc(id).delete();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> watchProjects() {
    final user = _currentUser;
    if (user == null) return const Stream.empty();

    return _projectsCol(user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // =============================
  // Optional legacy getter
  // =============================

  Future<Map<String, dynamic>?> getProfile() async {
    final user = _currentUser;
    if (user == null) return null;

    final doc = await _userDoc(user.uid).get();
    if (!doc.exists) return null;

    final data = doc.data() ?? {};
    return {
      'uid': user.uid,
      'name': data['name'] ?? user.displayName,
      'email': data['email'] ?? user.email,
      'photoUrl': data['photoUrl'],
      'coverUrl': data['coverUrl'],
      'createdAt': data['createdAt'],
      'role': data['role'],
      'skills': data['skills'],
      'bio': data['bio'],
    };
  }
}
