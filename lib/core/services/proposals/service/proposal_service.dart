import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import 'package:notes_tasks/modules/propsal/data/models/proposal_model.dart';
import 'package:notes_tasks/modules/propsal/domain/entities/proposal_entity.dart';
import 'package:notes_tasks/modules/propsal/domain/entities/proposal_status.dart';
import 'package:notes_tasks/modules/propsal/domain/failures/proposal_failure.dart';

class ProposalsService {
  final fb.FirebaseAuth auth;
  final FirebaseFirestore db;

  ProposalsService({
    required this.auth,
    required this.db,
  });

  fb.User? get currentUser => auth.currentUser;

  CollectionReference<Map<String, dynamic>> get _proposalsCol =>
      db.collection('proposals');
  CollectionReference<Map<String, dynamic>> get _usersCol =>
      db.collection('users');
  CollectionReference<Map<String, dynamic>> get _jobsCol =>
      db.collection('jobs');

  Future<String> addProposal({
    required String jobId,
    required String clientId,
    required String title,
    required String coverLetter,
    double? price,
    int? durationDays,
    List<String> tags = const [],
    String? imageUrl,
    String? linkUrl,
  }) async {
    final user = currentUser;
    if (user == null) throw ProposalFailure.notAllowed;

    final existing =
        await getMyProposalForJob(jobId: jobId, freelancerId: user.uid);
    if (existing != null) {
      // لا تفشي معلومة "انت قدّمت قبل" إذا بدك، بس عادي نخليها عامة:
      throw ProposalFailure.invalidData;
    }

    final jobDoc = await _jobsCol.doc(jobId).get();
    final jobData = jobDoc.data();
    if (jobData == null) throw ProposalFailure.notFound;

    final jobTitle = (jobData['title'] as String?) ?? '';
    final jobCategory = (jobData['category'] as String?) ?? '';
    final jobBudget = (jobData['budget'] as num?)?.toDouble();
    final jobDeadline = (jobData['deadline'] as Timestamp?)?.toDate();

    final clientDoc = await _usersCol.doc(clientId).get();
    final clientData = clientDoc.data();
    if (clientData == null) throw ProposalFailure.notFound;

    final clientName = (clientData['name'] as String?) ?? '';
    final clientPhotoUrl = clientData['photoUrl'] as String?;

    final docRef = _proposalsCol.doc();

    final model = ProposalModel(
      id: docRef.id,
      jobId: jobId,
      clientId: clientId,
      freelancerId: user.uid,
      jobTitle: jobTitle,
      jobCategory: jobCategory,
      jobBudget: jobBudget,
      jobDeadline: jobDeadline,
      clientName: clientName,
      clientPhotoUrl: clientPhotoUrl,
      title: title,
      description: '',
      tags: tags,
      imageUrl: imageUrl,
      linkUrl: linkUrl,
      coverLetter: coverLetter,
      price: price,
      durationDays: durationDays,
      status: ProposalStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: null,
    );

    await docRef.set({
      ...model.toFirestore(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': null,
    });

    return docRef.id;
  }

  Future<void> updateProposal({
    required String id,
    required String title,
    required String coverLetter,
    double? price,
    int? durationDays,
    List<String> tags = const [],
    String? imageUrl,
    String? linkUrl,
  }) async {
    final user = currentUser;
    if (user == null) throw ProposalFailure.notAllowed;

    final doc = await _proposalsCol.doc(id).get();
    final data = doc.data();
    if (data == null) throw ProposalFailure.notFound;

    if (data['freelancerId'] != user.uid) throw ProposalFailure.notAllowed;

    final currentStatus = (data['status'] ?? 'pending') as String;
    if (currentStatus != 'pending') throw ProposalFailure.notAllowed;

    await _proposalsCol.doc(id).update({
      'title': title.trim(),
      'coverLetter': coverLetter.trim(),
      'price': price,
      'durationDays': durationDays,
      'tags': tags,
      'imageUrl': imageUrl,
      'linkUrl': linkUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateProposalStatus({
    required String proposalId,
    required ProposalStatus status,
  }) async {
    final user = currentUser;
    if (user == null) throw ProposalFailure.notAllowed;

    final doc = await _proposalsCol.doc(proposalId).get();
    final data = doc.data();
    if (data == null) throw ProposalFailure.notFound;

    if (data['clientId'] != user.uid) throw ProposalFailure.notAllowed;

    await _proposalsCol.doc(proposalId).update({
      'status': _statusToString(status),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<ProposalEntity>> watchJobProposals(String jobId) {
    return _proposalsCol
        .where('jobId', isEqualTo: jobId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => ProposalModel.fromFirestore(d)).toList());
  }

  Stream<List<ProposalEntity>> watchMyProposals() {
    final user = currentUser;
    if (user == null) return const Stream.empty();

    return _proposalsCol
        .where('freelancerId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => ProposalModel.fromFirestore(d)).toList());
  }

  Stream<ProposalEntity?> watchProposalById(String proposalId) {
    return _proposalsCol.doc(proposalId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return ProposalModel.fromFirestore(doc);
    });
  }

  Future<ProposalEntity?> getMyProposalForJob({
    required String jobId,
    required String freelancerId,
  }) async {
    final snap = await _proposalsCol
        .where('jobId', isEqualTo: jobId)
        .where('freelancerId', isEqualTo: freelancerId)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;
    return ProposalModel.fromFirestore(snap.docs.first);
  }

  Stream<ProposalEntity?> watchMyProposalForJob(String jobId) {
    final user = currentUser;
    if (user == null) return const Stream.empty();

    return _proposalsCol
        .where('jobId', isEqualTo: jobId)
        .where('freelancerId', isEqualTo: user.uid)
        .limit(1)
        .snapshots()
        .map((snap) {
      if (snap.docs.isEmpty) return null;
      return ProposalModel.fromFirestore(snap.docs.first);
    });
  }

  String _statusToString(ProposalStatus s) {
    switch (s) {
      case ProposalStatus.accepted:
        return 'accepted';
      case ProposalStatus.rejected:
        return 'rejected';
      case ProposalStatus.pending:
      default:
        return 'pending';
    }
  }
}
