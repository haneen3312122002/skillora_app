import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/widgets/buttons/primary_button.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';
import 'package:notes_tasks/core/shared/widgets/fields/custom_text_field.dart';

import 'package:notes_tasks/modules/propsal/domain/entities/proposal_entity.dart';
import 'package:notes_tasks/modules/propsal/domain/failures/proposal_failure.dart';
import 'package:notes_tasks/modules/propsal/presentation/viewmodels/proposal_form_viewmodel.dart';

class ProposalFormWidget extends ConsumerStatefulWidget {
  final String jobId;
  final String clientId;
  final ProposalEntity? initial;

  const ProposalFormWidget({
    super.key,
    required this.jobId,
    required this.clientId,
    this.initial,
  });

  @override
  ConsumerState<ProposalFormWidget> createState() => _ProposalFormWidgetState();
}

class _ProposalFormWidgetState extends ConsumerState<ProposalFormWidget> {
  final _formKey = GlobalKey<FormState>();

  late final _title = TextEditingController();
  late final _cover = TextEditingController();
  late final _price = TextEditingController();
  late final _duration = TextEditingController();

  @override
  void initState() {
    super.initState();

    final p = widget.initial;
    if (p != null) {
      _title.text = p.title;
      _cover.text = p.coverLetter;
      _price.text = p.price?.toString() ?? '';
      _duration.text = p.durationDays?.toString() ?? '';
    } else {
      _title.text = 'Proposal';
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final vm = ref.read(proposalFormViewModelProvider.notifier);

      if (widget.initial == null) {
        vm.initForCreate(
          jobId: widget.jobId,
          clientId: widget.clientId,
          defaultTitle: _title.text,
        );
      } else {
        vm.initForEdit(widget.initial!);
      }
    });
  }

  @override
  void dispose() {
    _title.dispose();
    _cover.dispose();
    _price.dispose();
    _duration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ snackbar on errors (UI-side)
    ref.listen(proposalFormViewModelProvider, (prev, next) {
      next.when(
        loading: () {
          
        },
        data: (data) {
          
        },
        error: (e, _) {
          final key =
              (e is ProposalFailure) ? e.messageKey : 'something_went_wrong';
          AppSnackbar.show(context, key.tr());
          ref.read(proposalFormViewModelProvider.notifier).reset();
        },
      );
    });

    final async = ref.watch(proposalFormViewModelProvider);
    final vm = ref.read(proposalFormViewModelProvider.notifier);

    final data = async.value;
    if (data == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.screenHorizontal,
        right: AppSpacing.screenHorizontal,
        top: AppSpacing.spaceLG,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.spaceLG,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppCustomTextField(
              controller: _title,
              label: 'proposal_title_label'.tr(),
              onChanged: vm.setTitle,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'required'.tr() : null,
            ),
            SizedBox(height: AppSpacing.spaceMD),
            AppCustomTextField(
              controller: _cover,
              label: 'proposal_cover_letter_label'.tr(),
              maxLines: 5,
              onChanged: vm.setCoverLetter,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'required'.tr() : null,
            ),
            SizedBox(height: AppSpacing.spaceMD),
            Row(
              children: [
                Expanded(
                  child: AppCustomTextField(
                    controller: _price,
                    label: 'proposal_price_label'.tr(),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => vm.setPrice(double.tryParse(v)),
                  ),
                ),
                SizedBox(width: AppSpacing.spaceMD),
                Expanded(
                  child: AppCustomTextField(
                    controller: _duration,
                    label: 'proposal_duration_days_label'.tr(),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => vm.setDurationDays(int.tryParse(v)),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.spaceLG),
            AppPrimaryButton(
              variant: AppButtonVariant.outlined,
              label: data.isEdit ? 'common_save'.tr() : 'common_add'.tr(),
              isLoading: async.isLoading,
              onPressed: () async {
                FocusScope.of(context).unfocus();

                if (!_formKey.currentState!.validate()) return;

                final id = await vm.submit(); // ✅ no context
                if (!mounted) return;

                if (id != null) {
                  AppSnackbar.show(context, 'operation_done'.tr());
                  Navigator.pop(context, id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
