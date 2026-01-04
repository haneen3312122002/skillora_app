import 'package:notes_tasks/core/services/proposals/service/proposal_service.dart';
import 'package:notes_tasks/modules/propsal/domain/entities/proposal_entity.dart';

class WatchMyProposalsUseCase {
  final ProposalsService _service;
  WatchMyProposalsUseCase(this._service);

  Stream<List<ProposalEntity>> call() => _service.watchMyProposals();
}
