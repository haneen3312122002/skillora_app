class ProposalFailure implements Exception {
  final String messageKey;
  const ProposalFailure(this.messageKey);

  static const ProposalFailure somethingWentWrong =
      ProposalFailure('something_went_wrong');
  static const ProposalFailure notAllowed =
      ProposalFailure('operation_failed'); // عام وآمن
  static const ProposalFailure notFound =
      ProposalFailure('operation_failed'); // عام وآمن
  static const ProposalFailure invalidData =
      ProposalFailure('operation_failed'); // عام وآمن
}
