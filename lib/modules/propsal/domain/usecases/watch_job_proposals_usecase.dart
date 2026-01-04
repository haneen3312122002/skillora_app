import 'package:notes_tasks/core/services/proposals/service/proposal_service.dart';
import 'package:notes_tasks/modules/propsal/domain/entities/proposal_entity.dart';

class WatchJobProposalsUseCase {
  final ProposalsService _service;
  WatchJobProposalsUseCase(this._service);

  Stream<List<ProposalEntity>> call(String jobId) =>
      _service.watchJobProposals(jobId);
}
