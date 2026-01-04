import 'package:notes_tasks/core/services/proposals/service/proposal_service.dart';
import 'package:notes_tasks/modules/propsal/domain/entities/proposal_entity.dart';

class WatchProposalByIdUseCase {
  final ProposalsService _service;
  WatchProposalByIdUseCase(this._service);

  Stream<ProposalEntity?> call(String proposalId) =>
      _service.watchProposalById(proposalId);
}
