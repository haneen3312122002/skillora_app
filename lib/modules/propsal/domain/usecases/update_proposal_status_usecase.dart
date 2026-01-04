import 'package:notes_tasks/core/services/proposals/service/proposal_service.dart';
import 'package:notes_tasks/modules/propsal/domain/entities/proposal_status.dart';

class UpdateProposalStatusUseCase {
  final ProposalsService _service;
  UpdateProposalStatusUseCase(this._service);

  Future<void> call({
    required String proposalId,
    required ProposalStatus status,
  }) {
    return _service.updateProposalStatus(
      proposalId: proposalId,
      status: status,
    );
  }
}
