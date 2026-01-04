import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import 'package:notes_tasks/modules/propsal/data/models/proposal_model.dart';
import 'package:notes_tasks/modules/propsal/domain/entities/proposal_entity.dart';
import 'package:notes_tasks/modules/propsal/domain/entities/proposal_status.dart';

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

  // =============================
  // Create
  // =============================

  /// ✅ Create proposal (freelancer submits)
  /// - prevents duplicate per (jobId + freelancerId)
  /// - saves snapshot fields: job info + client info
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
    if (user == null) throw Exception('No logged in user');

    // ✅ prevent duplicate proposal for same job by same freelancer
    final existing =
        await getMyProposalForJob(jobId: jobId, freelancerId: user.uid);
    if (existing != null) {
      throw Exception('You already submitted a proposal for this job');
    }

    // ✅ fetch job snapshot
    final jobDoc = await _jobsCol.doc(jobId).get();
    final jobData = jobDoc.data() ?? {};
    final jobTitle = (jobData['title'] as String?) ?? '';
    final jobCategory = (jobData['category'] as String?) ?? '';
    final jobBudget = (jobData['budget'] as num?)?.toDouble();
    final jobDeadline = (jobData['deadline'] as Timestamp?)?.toDate();

    // ✅ fetch client snapshot
    final clientDoc = await _usersCol.doc(clientId).get();
    final clientData = clientDoc.data() ?? {};
    final clientName = (clientData['name'] as String?) ?? '';
    final clientPhotoUrl = clientData['photoUrl'] as String?;

    final docRef = _proposalsCol.doc();

    final model = ProposalModel(
      id: docRef.id,

      // relations
      jobId: jobId,
      clientId: clientId,
      freelancerId: user.uid,

      // snapshot fields
      jobTitle: jobTitle,
      jobCategory: jobCategory,
      jobBudget: jobBudget,
      jobDeadline: jobDeadline,
      clientName: clientName,
      clientPhotoUrl: clientPhotoUrl,

      // ProfileItem fields
      title: title,
      description: '',
      tags: tags,
      imageUrl: imageUrl,
      linkUrl: linkUrl,

      // content
      coverLetter: coverLetter,
      price: price,
      durationDays: durationDays,

      // status & dates
      status: ProposalStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: null,
    );

    await docRef.set({
      ...model.toFirestore(),

      // ✅ better timestamps from server (recommended)
      // (createdAt داخل toFirestore رح ينكتب، بس بنستبدله بالـ serverTimestamp)
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': null,
    });

    return docRef.id;
  }

  // =============================
  // Update (freelancer edits proposal content)
  // =============================

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
    if (user == null) throw Exception('No logged in user');

    final doc = await _proposalsCol.doc(id).get();
    final data = doc.data();
    if (data == null) throw Exception('Proposal not found');

    // ✅ only freelancer صاحب البروبوزال يقدر يعدل
    if (data['freelancerId'] != user.uid) {
      throw Exception('Not allowed');
    }

    // ✅ (اختياري) امنع التعديل إذا مش pending
    final currentStatus = (data['status'] ?? 'pending') as String;
    if (currentStatus != 'pending') {
      throw Exception('Cannot edit proposal after decision');
    }

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

  // =============================
  // Update status (client decision)
  // =============================

  Future<void> updateProposalStatus({
    required String proposalId,
    required ProposalStatus status,
  }) async {
    final user = currentUser;
    if (user == null) throw Exception('No logged in user');

    final doc = await _proposalsCol.doc(proposalId).get();
    final data = doc.data();
    if (data == null) throw Exception('Proposal not found');

    // ✅ only client can decide
    if (data['clientId'] != user.uid) {
      throw Exception('Not allowed');
    }

    await _proposalsCol.doc(proposalId).update({
      'status': _statusToString(status),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // =============================
  // Streams
  // =============================

  /// ✅ All proposals for a job (client view)
  Stream<List<ProposalEntity>> watchJobProposals(String jobId) {
    return _proposalsCol
        .where('jobId', isEqualTo: jobId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => ProposalModel.fromFirestore(d)).toList());
  }

  /// ✅ My proposals (freelancer view)
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

  /// ✅ watch single proposal
  Stream<ProposalEntity?> watchProposalById(String proposalId) {
    return _proposalsCol.doc(proposalId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return ProposalModel.fromFirestore(doc);
    });
  }

  // =============================
  // Helpers
  // =============================

  /// ✅ Check if freelancer already submitted proposal for a job
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

  //,,,,,
  Future<void> acceptProposalAndRejectOthers({
    required String proposalId,
    bool closeJob = true,
  }) async {
    final user = currentUser;
    if (user == null) throw Exception('No logged in user');

    final proposalDocRef = _proposalsCol.doc(proposalId);
    final proposalSnap = await proposalDocRef.get();
    final proposalData = proposalSnap.data();
    if (proposalData == null) throw Exception('Proposal not found');

    // ✅ فقط الكلاينت صاحب الجوب يقدر يقبل
    if (proposalData['clientId'] != user.uid) throw Exception('Not allowed');

    final jobId = proposalData['jobId'] as String? ?? '';
    if (jobId.isEmpty) throw Exception('Missing jobId');

    final currentStatus = (proposalData['status'] ?? 'pending') as String;
    if (currentStatus != 'pending') {
      throw Exception('Proposal is not pending');
    }

    // ✅ هات كل pending proposals للجوب
    final pendingSnap = await _proposalsCol
        .where('jobId', isEqualTo: jobId)
        .where('status', isEqualTo: 'pending')
        .get();

    final batch = db.batch();

    // ✅ 1) accept المختار
    batch.update(proposalDocRef, {
      'status': 'accepted',
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // ✅ 2) reject الباقي
    for (final d in pendingSnap.docs) {
      if (d.id == proposalId) continue;
      batch.update(d.reference, {
        'status': 'rejected',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    // ✅ 3) (اختياري) close job
    if (closeJob) {
      batch.update(db.collection('jobs').doc(jobId), {
        'isOpen': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  //...
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
}
