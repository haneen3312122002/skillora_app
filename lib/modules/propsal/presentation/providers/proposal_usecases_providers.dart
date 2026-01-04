import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/services/proposals/service/proposal_provider.dart';

import 'package:notes_tasks/modules/propsal/domain/usecases/add_proposal_usecase.dart';
import 'package:notes_tasks/modules/propsal/domain/usecases/update_proposal_status_usecase.dart';
import 'package:notes_tasks/modules/propsal/domain/usecases/update_propsal.dart';
import 'package:notes_tasks/modules/propsal/domain/usecases/watch_job_proposals_usecase.dart';
import 'package:notes_tasks/modules/propsal/domain/usecases/watch_my_proposals_usecase.dart';
import 'package:notes_tasks/modules/propsal/domain/usecases/watch_proposal_by_id_usecase.dart';

final addProposalUseCaseProvider = Provider<AddProposalUseCase>((ref) {
  final service = ref.read(proposalsServiceProvider);
  return AddProposalUseCase(service);
});
final updateProposalUseCaseProvider = Provider<UpdateProposalUseCase>((ref) {
  final service = ref.read(proposalsServiceProvider);
  return UpdateProposalUseCase(service);
});

final updateProposalStatusUseCaseProvider =
    Provider<UpdateProposalStatusUseCase>((ref) {
  final service = ref.read(proposalsServiceProvider);
  return UpdateProposalStatusUseCase(service);
});

final watchJobProposalsUseCaseProvider =
    Provider<WatchJobProposalsUseCase>((ref) {
  final service = ref.read(proposalsServiceProvider);
  return WatchJobProposalsUseCase(service);
});

final watchMyProposalsUseCaseProvider =
    Provider<WatchMyProposalsUseCase>((ref) {
  final service = ref.read(proposalsServiceProvider);
  return WatchMyProposalsUseCase(service);
});

final watchProposalByIdUseCaseProvider =
    Provider<WatchProposalByIdUseCase>((ref) {
  final service = ref.read(proposalsServiceProvider);
  return WatchProposalByIdUseCase(service);
});
