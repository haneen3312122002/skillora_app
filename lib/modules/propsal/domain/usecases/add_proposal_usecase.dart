import 'package:notes_tasks/core/services/proposals/service/proposal_service.dart';

class AddProposalUseCase {
  final ProposalsService _service;
  AddProposalUseCase(this._service);

  Future<String> call({
    required String jobId,
    required String clientId,
    required String title,
    required String coverLetter,
    double? price,
    int? durationDays,
    List<String> tags = const [],
    String? imageUrl,
    String? linkUrl,
  }) {
    return _service.addProposal(
      jobId: jobId,
      clientId: clientId,
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
