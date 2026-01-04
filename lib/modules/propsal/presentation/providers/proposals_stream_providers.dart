import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/services/proposals/service/proposal_provider.dart';
import 'package:notes_tasks/modules/propsal/domain/entities/proposal_entity.dart';
import 'package:notes_tasks/modules/propsal/presentation/providers/proposal_usecases_providers.dart';

/// ✅ للكلاينت: بروبوزالات جوب معيّن
final jobProposalsStreamProvider =
    StreamProvider.family<List<ProposalEntity>, String>((ref, jobId) {
  final useCase = ref.watch(watchJobProposalsUseCaseProvider);
  return useCase(jobId);
});

/// ✅ للفريلانسر: بروبوزالاتي
final myProposalsStreamProvider = StreamProvider<List<ProposalEntity>>((ref) {
  final useCase = ref.watch(watchMyProposalsUseCaseProvider);
  return useCase();
});

/// ✅ للطرفين: بروبوزال واحد
final proposalByIdStreamProvider =
    StreamProvider.family<ProposalEntity?, String>((ref, proposalId) {
  final useCase = ref.watch(watchProposalByIdUseCaseProvider);
  return useCase(proposalId);
});
final myProposalForJobStreamProvider =
    StreamProvider.family<ProposalEntity?, String>((ref, jobId) {
  final service = ref.read(proposalsServiceProvider);
  return service.watchMyProposalForJob(jobId);
});
