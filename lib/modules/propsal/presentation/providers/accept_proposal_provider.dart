import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_tasks/core/services/chat/chat_provider.dart';

import 'package:notes_tasks/core/services/proposals/service/proposal_provider.dart'; // proposalsServiceProvider
import 'package:notes_tasks/core/services/job/service/job_provider.dart'; // jobsServiceProvider

import 'package:notes_tasks/modules/propsal/domain/usecases/accept_and_openchat.dart';

final acceptProposalAndOpenChatUseCaseProvider =
    Provider<AcceptProposalAndOpenChatUseCase>((ref) {
  final db = FirebaseFirestore.instance;

  final proposals = ref.read(proposalsServiceProvider);
  final jobs = ref.read(jobsServiceProvider);
  final chats = ref.read(chatsServiceProvider);

  return AcceptProposalAndOpenChatUseCase(
    db: db,
    proposals: proposals,
    jobs: jobs,
    chats: chats,
  );
});
