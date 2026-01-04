import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/providers/date_range_provider.dart';
import 'package:notes_tasks/core/shared/services/utils/date_picker_service.dart';
import 'package:notes_tasks/core/shared/services/utils/dialog_service.dart';
import 'package:notes_tasks/core/app/theme/text_styles.dart';
import 'package:notes_tasks/core/shared/widgets/pages/app_form.dart';
import 'package:notes_tasks/core/shared/widgets/fields/custom_text_field.dart';
import 'package:notes_tasks/core/shared/widgets/fields/app_date_range_fields.dart';
import 'package:notes_tasks/modules/profile_experience/domain/entities/experience_entity.dart';
import 'package:notes_tasks/modules/profile_experience/presentation/viewmodels/experience_form_viewmodel.dart';

class ExperienceFormWidget extends ConsumerStatefulWidget {
  final ExperienceEntity? initial; // null = add mode

  const ExperienceFormWidget({super.key, this.initial});

  @override
  ConsumerState<ExperienceFormWidget> createState() =>
      _ExperienceFormWidgetState();
}

class _ExperienceFormWidgetState extends ConsumerState<ExperienceFormWidget> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleCtrl;
  late TextEditingController companyCtrl;
  late TextEditingController locationCtrl;
  late TextEditingController descriptionCtrl;

  bool get isEdit => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;

    titleCtrl = TextEditingController(text: i?.title ?? '');
    companyCtrl = TextEditingController(text: i?.company ?? '');
    locationCtrl = TextEditingController(text: i?.location ?? '');
    descriptionCtrl = TextEditingController(text: i?.description ?? '');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      DateRangeUtils.setInitial(
        ref,
        start: i?.startDate,
        end: i?.endDate,
      );
    });
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    companyCtrl.dispose();
    locationCtrl.dispose();
    descriptionCtrl.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'field_required'.tr();
    }
    return null;
  }

  bool _isPresentRange(DateTimeRange? range) {
    if (range == null) return false;

    return range.start == range.end;
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(experienceFormViewModelProvider.notifier);
    final state = ref.watch(experienceFormViewModelProvider);
    final theme = Theme.of(context);

    final experienceId = widget.initial?.id;

    return AppForm(
      formKey: _formKey,
      submitLabel: isEdit
          ? 'experience_update_button'.tr()
          : 'experience_add_button'.tr(),
      isLoading: state.isLoading,
      fields: [
        AppCustomTextField(
          controller: titleCtrl,
          label: 'experience_title_label'.tr(),
          inputAction: TextInputAction.next,
          validator: _requiredValidator,
        ),
        SizedBox(height: AppSpacing.spaceMD),
        AppCustomTextField(
          controller: companyCtrl,
          label: 'experience_company_label'.tr(),
          inputAction: TextInputAction.next,
          validator: _requiredValidator,
        ),
        SizedBox(height: AppSpacing.spaceMD),
        AppCustomTextField(
          controller: locationCtrl,
          label: 'experience_location_label'.tr(),
          inputAction: TextInputAction.next,
        ),
        SizedBox(height: AppSpacing.spaceMD),
        const AppDateRangeFields(
          startLabelKey: 'experience_start_date_label',
          endLabelKey: 'experience_end_date_label',
          presentLabelKey: 'experience_present_label',
          markPresentLabelKey: 'experience_mark_present',
        ),
        SizedBox(height: AppSpacing.spaceMD),
        AppCustomTextField(
          controller: descriptionCtrl,
          label: 'experience_description_label'.tr(),
          maxLines: 4,
        ),
        SizedBox(height: AppSpacing.spaceLG),
      ],
      onSubmit: () async {
        final currentRange = ref.read(dateRangeProvider);

        final startDate = currentRange?.start;
        DateTime? endDate;

        if (_isPresentRange(currentRange)) {
          endDate = null; // "حتى الآن"
        } else {
          endDate = currentRange?.end;
        }

        if (isEdit) {
          if (experienceId == null) {
            return;
          }

          await vm.updateExperience(
            context,
            id: experienceId,
            title: titleCtrl.text.trim(),
            company: companyCtrl.text.trim(),
            startDate: startDate,
            endDate: endDate,
            location: locationCtrl.text.trim(),
            description: descriptionCtrl.text.trim(),
          );
        } else {
          await vm.addExperience(
            context,
            title: titleCtrl.text.trim(),
            company: companyCtrl.text.trim(),
            startDate: startDate,
            endDate: endDate,
            location: locationCtrl.text.trim(),
            description: descriptionCtrl.text.trim(),
          );
        }

        if (!mounted) return;
        context.pop(); // سكّر الشيت
      },
      footer: isEdit && experienceId != null
          ? Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: Icon(
                  Icons.delete_outline,
                  color: theme.colorScheme.error,
                ),
                label: Text(
                  'experience_delete_button'.tr(),
                  style: AppTextStyles.body.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
                onPressed: state.isLoading
                    ? null
                    : () async {
                        final confirmed = await DialogService.showConfirmDialog(
                          context: context,
                          title: 'experience_delete_confirm_title'.tr(),
                          message: 'experience_delete_confirm_message'.tr(),
                          cancelLabel: 'cancel'.tr(),
                          confirmLabel: 'delete'.tr(),
                          confirmColor: theme.colorScheme.error,
                        );

                        if (!confirmed) return;

                        await vm.deleteExperience(
                          context,
                          id: experienceId,
                        );

                        if (!mounted) return;
                        context.pop(); // سكّر الشيت بعد الحذف
                      },
              ),
            )
          : null,
    );
  }
}
