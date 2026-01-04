import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/modules/propsal/domain/entities/proposal_status.dart';
import 'package:notes_tasks/modules/propsal/presentation/providers/accept_proposal_provider.dart';
import 'package:notes_tasks/modules/propsal/presentation/providers/proposal_usecases_providers.dart';

final proposalActionsViewModelProvider =
    AsyncNotifierProvider<ProposalActionsViewModel, void>(
        ProposalActionsViewModel.new);

class ProposalActionsViewModel extends AsyncNotifier<void> {
  late final _updateStatus = ref.read(updateProposalStatusUseCaseProvider);
  late final _accept = ref.read(acceptProposalAndOpenChatUseCaseProvider);
  late final _reject = ref.read(updateProposalStatusUseCaseProvider);

  @override
  FutureOr<void> build() {}

  Future<void> accept(BuildContext context, String proposalId) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    try {
      await _accept(proposalId: proposalId);
      state = const AsyncData(null);
      // snackbar success
    } catch (e, st) {
      state = AsyncError(e, st);
      // snackbar error
    }
  }

  Future<void> reject(BuildContext context, String proposalId) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    try {
      await _reject(proposalId: proposalId, status: ProposalStatus.rejected);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
