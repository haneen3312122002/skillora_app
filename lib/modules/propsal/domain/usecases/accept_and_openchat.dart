import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_tasks/core/services/chat/chat_services.dart';
import 'package:notes_tasks/core/services/job/service/jobs_service.dart';
import 'package:notes_tasks/core/services/proposals/service/proposal_service.dart';

class AcceptProposalAndOpenChatUseCase {
  final FirebaseFirestore db;
  final ProposalsService proposals;
  final JobsService jobs;
  final ChatsService chats;

  AcceptProposalAndOpenChatUseCase({
    required this.db,
    required this.proposals,
    required this.jobs,
    required this.chats,
  });

  Future<String> call({required String proposalId}) async {
    // 1) proposal
    final pDoc = await db.collection('proposals').doc(proposalId).get();
    final p = pDoc.data();
    if (p == null) throw Exception('Proposal not found');

    final jobId = (p['jobId'] ?? '') as String;
    final clientId = (p['clientId'] ?? '') as String;
    final freelancerId = (p['freelancerId'] ?? '') as String;

    if (jobId.isEmpty || clientId.isEmpty || freelancerId.isEmpty) {
      throw Exception('Invalid proposal data');
    }

    // 2) job snapshot
    final jDoc = await db.collection('jobs').doc(jobId).get();
    final j = jDoc.data();
    if (j == null) throw Exception('Job not found');

    final jobTitle = (j['title'] ?? '-') as String;
    final jobCategory = (j['category'] ?? '-') as String;
    final jobCoverUrl = j['imageUrl'] as String?;

    // 3) fetch other pending proposals (OUTSIDE transaction)
    final othersSnap = await db
        .collection('proposals')
        .where('jobId', isEqualTo: jobId)
        .where('status', isEqualTo: 'pending')
        .get();

    // chat id
    final chatId = chats.chatIdForJob(jobId, freelancerId);

    // 4) batch write
    final batch = db.batch();

    final proposalRef = db.collection('proposals').doc(proposalId);
    final jobRef = db.collection('jobs').doc(jobId);
    final chatRef = db.collection('chats').doc(chatId);

    // ✅ accept selected proposal
    batch.update(proposalRef, {
      'status': 'accepted',
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // ✅ reject other pending proposals
    for (final d in othersSnap.docs) {
      if (d.id == proposalId) continue;
      batch.update(d.reference, {
        'status': 'rejected',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    // ✅ close job (اختياري)
    batch.update(jobRef, {
      'isOpen': false,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // ✅ create chat if not exists (لازم نقرأ أول!)
    final chatSnap = await chatRef.get();
    if (!chatSnap.exists) {
      batch.set(chatRef, {
        'jobId': jobId,
        'clientId': clientId,
        'freelancerId': freelancerId,
        'participants': [clientId, freelancerId],
        'jobTitle': jobTitle,
        'jobCategory': jobCategory,
        'jobCoverUrl': jobCoverUrl,
        'status': 'open',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'lastMessageText': null,
        'lastMessageAt': null,
        'lastMessageSenderId': null,
      });
    } else {
      // لو موجود، حدّث updatedAt فقط
      batch.update(chatRef, {
        'updatedAt': FieldValue.serverTimestamp(),
        'status': 'open',
      });
    }

    await batch.commit();
    return chatId;
  }
}
