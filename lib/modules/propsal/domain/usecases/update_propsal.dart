import 'package:notes_tasks/core/services/proposals/service/proposal_service.dart';

class UpdateProposalUseCase {
  final ProposalsService _service;
  UpdateProposalUseCase(this._service);

  Future<void> call({
    required String id,
    required String title,
    required String coverLetter,
    double? price,
    int? durationDays,
    List<String> tags = const [],
    String? imageUrl,
    String? linkUrl,
  }) {
    return _service.updateProposal(
      id: id,
      title: title,
      coverLetter: coverLetter,
      price: price,
      durationDays: durationDays,
      tags: tags,
      imageUrl: imageUrl,
      linkUrl: linkUrl,
    );
  }
}
