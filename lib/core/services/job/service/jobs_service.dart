import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import 'package:notes_tasks/modules/job/data/models/job_model.dart';
import 'package:notes_tasks/modules/job/domain/entities/job_entity.dart';
import 'package:notes_tasks/modules/job/domain/failures/job_failure.dart';

class JobsService {
  final fb.FirebaseAuth auth;
  final FirebaseFirestore db;

  JobsService({
    required this.auth,
    required this.db,
  });

  fb.User? get currentUser => auth.currentUser;

  CollectionReference<Map<String, dynamic>> get _jobsCol =>
      db.collection('jobs');

  // =============================
  // Create
  // =============================
  Future<String> addJob({
    required String title,
    required String description,
    List<String> skills = const [],
    String? imageUrl,
    String? jobUrl,
    double? budget,
    DateTime? deadline,
    required String category,
  }) async {
    final user = currentUser;
    if (user == null) throw const JobFailure('auth_required');

    final docRef = _jobsCol.doc();

    final model = JobModel(
      id: docRef.id,
      clientId: user.uid,
      title: title,
      description: description,
      skills: skills,
      imageUrl: imageUrl,
      jobUrl: jobUrl,
      budget: budget,
      deadline: deadline,
      isOpen: true,
      category: category,
    );

    await docRef.set(model.toMapForCreate(clientId: user.uid));
    return docRef.id;
  }

  // =============================
  // Update
  // =============================
  Future<void> updateJob({
    required String id,
    required String title,
    required String description,
    required String category,
    List<String> skills = const [],
    String? imageUrl,
    String? jobUrl,
    double? budget,
    DateTime? deadline,
    bool? isOpen,
  }) async {
    final user = currentUser;
    if (user == null) throw const JobFailure('auth_required');

    final doc = await _jobsCol.doc(id).get();
    final data = doc.data();
    if (data == null) throw const JobFailure('job_not_found');

    if (data['clientId'] != user.uid) {
      throw const JobFailure('not_allowed');
    }

    final model = JobModel(
      id: id,
      clientId: data['clientId'] as String? ?? '',
      title: title,
      description: description,
      skills: skills,
      imageUrl: imageUrl,
      jobUrl: jobUrl,
      budget: budget,
      deadline: deadline,
      isOpen: isOpen ?? true,
      category: category,
    );

    await _jobsCol.doc(id).update(model.toMapForUpdate());
  }

  // =============================
  // Delete
  // =============================
  Future<void> deleteJob(String id) async {
    final user = currentUser;
    if (user == null) throw const JobFailure('auth_required');

    final doc = await _jobsCol.doc(id).get();
    final data = doc.data();
    if (data == null) return;

    if (data['clientId'] != user.uid) {
      throw const JobFailure('not_allowed');
    }

    await _jobsCol.doc(id).delete();
  }

  // =============================
  // Streams
  // =============================
  Stream<List<JobEntity>> watchJobsFeed() {
    return _jobsCol
        .where('isOpen', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(JobModel.fromDoc).toList());
  }

  Stream<List<JobEntity>> watchMyJobs(String uid) {
    if (uid.trim().isEmpty) return const Stream.empty();

    return _jobsCol
        .where('clientId', isEqualTo: uid) // ✅ بدل current user
        .snapshots()
        .map((snap) => snap.docs.map(JobModel.fromDoc).toList());
  }

  Stream<JobEntity?> watchJobById(String jobId) {
    return _jobsCol.doc(jobId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return JobModel.fromDoc(doc);
    });
  }

  Stream<List<JobEntity>> watchJobsByCategoryAndOpen({
    required String category,
    required bool isOpen,
  }) {
    return _jobsCol
        .where('category', isEqualTo: category)
        .where('isOpen', isEqualTo: isOpen)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(JobModel.fromDoc).toList());
  }
}
