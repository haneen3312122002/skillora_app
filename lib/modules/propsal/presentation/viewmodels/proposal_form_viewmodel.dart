import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';
import 'package:notes_tasks/modules/propsal/domain/entities/proposal_entity.dart';
import 'package:notes_tasks/modules/propsal/presentation/providers/proposal_usecases_providers.dart';

final proposalFormViewModelProvider =
    AsyncNotifierProvider<ProposalFormViewModel, ProposalFormState?>(
  ProposalFormViewModel.new,
);

class ProposalFormState {
  final String? id;

  final String jobId;
  final String clientId;

  final String title; // ✅ required for add usecase
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
  late final _update = ref.read(updateProposalUseCaseProvider); // ✅ صح

  @override
  FutureOr<ProposalFormState?> build() async => null;

  void initForCreate({
    required String jobId,
    required String clientId,
    String? defaultTitle,
  }) {
    state = AsyncData(
      ProposalFormState(
        jobId: jobId,
        clientId: clientId,
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
    state = AsyncData(fn(cur));
  }

  Future<String?> submit(BuildContext context) async {
    final cur = state.value;
    if (cur == null || state.isLoading) return null;

    if (cur.jobId.trim().isEmpty || cur.clientId.trim().isEmpty) {
      AppSnackbar.show(
        context,
        'failed_with_error'.tr(namedArgs: {'error': 'missing_job_or_client'}),
      );
      return null;
    }

    if (cur.title.trim().isEmpty || cur.coverLetter.trim().isEmpty) {
      AppSnackbar.show(context, 'required'.tr());
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

        AppSnackbar.show(context, 'common_saved'.tr());
        state = const AsyncData(null);
        return cur.id;
      } else {
        final id = await _add(
          jobId: cur.jobId,
          clientId: cur.clientId,
          title: cur.title.trim(),
          coverLetter: cur.coverLetter.trim(),
          price: cur.price,
          durationDays: cur.durationDays,
        );

        AppSnackbar.show(context, 'common_added'.tr());
        state = const AsyncData(null);
        return id;
      }
    } catch (e, st) {
      state = AsyncError(e, st);
      AppSnackbar.show(
        context,
        'failed_with_error'.tr(namedArgs: {'error': e.toString()}),
      );
      return null;
    }
  }
}
