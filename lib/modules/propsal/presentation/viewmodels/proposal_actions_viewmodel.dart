import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/services/proposals/mappers/proposal_failure_mapper.dart';
import 'package:notes_tasks/modules/propsal/domain/entities/proposal_status.dart';
import 'package:notes_tasks/modules/propsal/domain/failures/proposal_failure.dart';
import 'package:notes_tasks/modules/propsal/presentation/providers/accept_proposal_provider.dart';
import 'package:notes_tasks/modules/propsal/presentation/providers/proposal_usecases_providers.dart';

final proposalActionsViewModelProvider =
    AsyncNotifierProvider<ProposalActionsViewModel, void>(
  ProposalActionsViewModel.new,
);

class ProposalActionsViewModel extends AsyncNotifier<void> {
  late final _accept = ref.read(acceptProposalAndOpenChatUseCaseProvider);
  late final _updateStatus = ref.read(updateProposalStatusUseCaseProvider);

  @override
  FutureOr<void> build() {}

  Future<String?> accept(String proposalId) async {
    if (state.isLoading) return null;
    state = const AsyncLoading();

    try {
      final chatId = await _accept(proposalId: proposalId);
      state = const AsyncData(null);
      return chatId;
    } catch (e, st) {
      // ✅ map to safe failure
      ProposalFailure failure;
      try {
        failure = mapProposalErrorToFailure(e as Object);
      } catch (_) {
        failure = const ProposalFailure('operation_failed');
      }
      state = AsyncError(failure, st);
      return null;
    }
  }

  Future<bool> reject(String proposalId) async {
    if (state.isLoading) return false;
    state = const AsyncLoading();

    try {
      await _updateStatus(
        proposalId: proposalId,
        status: ProposalStatus.rejected,
      );
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      ProposalFailure failure;
      try {
        failure = mapProposalErrorToFailure(e as Object);
      } catch (_) {
        failure = const ProposalFailure('operation_failed');
      }
      state = AsyncError(failure, st);
      return false;
    }
  }

  void reset() {
    if (state.isLoading) return;
    state = const AsyncData(null);
  }
}
