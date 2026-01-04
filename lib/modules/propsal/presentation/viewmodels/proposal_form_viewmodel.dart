import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/modules/propsal/domain/entities/proposal_entity.dart';
import 'package:notes_tasks/modules/propsal/domain/failures/proposal_failure.dart';
import 'package:notes_tasks/modules/propsal/presentation/providers/proposal_usecases_providers.dart';

final proposalFormViewModelProvider =
    AsyncNotifierProvider<ProposalFormViewModel, ProposalFormState?>(
  ProposalFormViewModel.new,
);

class ProposalFormState {
  final String? id;

  final String jobId;
  final String clientId;

  final String title;
  final String coverLetter;
  final double? price;
  final int? durationDays;

  const ProposalFormState({
    this.id,
    this.jobId = '',
    this.clientId = '',
    this.title = '',
    this.coverLetter = '',
    this.price,
    this.durationDays,
  });

  bool get isEdit => id != null;

  ProposalFormState copyWith({
    String? id,
    String? jobId,
    String? clientId,
    String? title,
    String? coverLetter,
    double? price,
    int? durationDays,
  }) {
    return ProposalFormState(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      clientId: clientId ?? this.clientId,
      title: title ?? this.title,
      coverLetter: coverLetter ?? this.coverLetter,
      price: price ?? this.price,
      durationDays: durationDays ?? this.durationDays,
    );
  }
}

class ProposalFormViewModel extends AsyncNotifier<ProposalFormState?> {
  late final _add = ref.read(addProposalUseCaseProvider);
  late final _update = ref.read(updateProposalUseCaseProvider);

  @override
  FutureOr<ProposalFormState?> build() async => null;

  void initForCreate({
    required String jobId,
    required String clientId,
    String? defaultTitle,
  }) {
    state = AsyncData(
      ProposalFormState(
        jobId: jobId.trim(),
        clientId: clientId.trim(),
        title: (defaultTitle ?? 'Proposal').trim(),
      ),
    );
  }

  void initForEdit(ProposalEntity proposal) {
    state = AsyncData(
      ProposalFormState(
        id: proposal.id,
        jobId: proposal.jobId,
        clientId: proposal.clientId,
        title: proposal.title,
        coverLetter: proposal.coverLetter,
        price: proposal.price,
        durationDays: proposal.durationDays,
      ),
    );
  }

  void setTitle(String v) => _set((s) => s.copyWith(title: v));
  void setCoverLetter(String v) => _set((s) => s.copyWith(coverLetter: v));
  void setPrice(double? v) => _set((s) => s.copyWith(price: v));
  void setDurationDays(int? v) => _set((s) => s.copyWith(durationDays: v));

  void _set(ProposalFormState Function(ProposalFormState s) fn) {
    final cur = state.value;
    if (cur == null) return;
    if (state.isLoading) return; // avoid editing while submitting
    state = AsyncData(fn(cur));
  }

  /// ✅ UI will show snackbar using listener
  /// Returns proposalId if success
  Future<String?> submit() async {
    final cur = state.value;
    if (cur == null || state.isLoading) return null;

    // ===== Validate (general & safe messages) =====
    if (cur.jobId.trim().isEmpty || cur.clientId.trim().isEmpty) {
      state = AsyncError(
          const ProposalFailure('operation_failed'), StackTrace.empty);
      return null;
    }

    if (cur.title.trim().isEmpty || cur.coverLetter.trim().isEmpty) {
      state = AsyncError(const ProposalFailure('required'), StackTrace.empty);
      return null;
    }

    state = const AsyncLoading();

    try {
      if (cur.isEdit && cur.id != null) {
        await _update(
          id: cur.id!,
          title: cur.title.trim(),
          coverLetter: cur.coverLetter.trim(),
          price: cur.price,
          durationDays: cur.durationDays,
        );

        state = const AsyncData(null);
        return cur.id;
      } else {
        final id = await _add(
          jobId: cur.jobId.trim(),
          clientId: cur.clientId.trim(),
          title: cur.title.trim(),
          coverLetter: cur.coverLetter.trim(),
          price: cur.price,
          durationDays: cur.durationDays,
        );

        state = const AsyncData(null);
        return id;
      }
    } catch (e, st) {
      // ✅ NEVER leak backend error details to UI
      state = AsyncError(const ProposalFailure('operation_failed'), st);
      return null;
    }
  }

  void reset() {
    if (state.isLoading) return;
    state = const AsyncData(null);
  }
}
