import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_tasks/modules/propsal/domain/failures/proposal_failure.dart';

ProposalFailure mapProposalErrorToFailure(Object e) {
  // لو انت رميت ProposalFailure أصلاً
  if (e is ProposalFailure) return e;

  // Firestore errors -> general
  if (e is FirebaseException) {
    return ProposalFailure.somethingWentWrong;
  }

  // أي شي ثاني
  return ProposalFailure.somethingWentWrong;
}
