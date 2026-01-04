import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:notes_tasks/core/shared/constants/job_categories.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';
import 'package:notes_tasks/core/shared/widgets/fields/app_dropdown.dart';
import 'package:notes_tasks/core/shared/widgets/fields/custom_text_field.dart';
import 'package:notes_tasks/core/shared/widgets/buttons/primary_button.dart';

import 'package:notes_tasks/modules/job/domain/entities/job_entity.dart';
import 'package:notes_tasks/modules/job/presentation/viewmodels/job_form_viewmodel.dart';

class JobFormWidget extends ConsumerStatefulWidget {
  final JobEntity? initial;

  const JobFormWidget({super.key, this.initial});

  @override
  ConsumerState<JobFormWidget> createState() => _JobFormWidgetState();
}

class _JobFormWidgetState extends ConsumerState<JobFormWidget> {
  final _formKey = GlobalKey<FormState>();

  late final _title = TextEditingController();
  late final _desc = TextEditingController();
  late final _jobUrl = TextEditingController();
  late final _imageUrl = TextEditingController();
  late final _skill = TextEditingController();
  late final _budget = TextEditingController();

  @override
  void initState() {
    super.initState();

    final p = widget.initial;
    if (p != null) {
      _title.text = p.title;
      _desc.text = p.description;
      _jobUrl.text = p.jobUrl ?? '';
      _imageUrl.text = p.imageUrl ?? '';
      _budget.text = p.budget?.toString() ?? '';
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final vm = ref.read(jobFormViewModelProvider.notifier);
      if (widget.initial == null) {
        vm.initForCreate();
      } else {
        vm.initForEdit(widget.initial!);
      }
    });
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _jobUrl.dispose();
    _imageUrl.dispose();
    _skill.dispose();
    _budget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(jobFormViewModelProvider);
    final vm = ref.read(jobFormViewModelProvider.notifier);

    final data = async.value;
    if (data == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final skills = data.skills;

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
              label: 'job_title_label'.tr(),
              onChanged: vm.setTitle,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'required'.tr() : null,
            ),
            SizedBox(height: AppSpacing.spaceMD),

            AppCustomTextField(
              controller: _desc,
              label: 'job_description_label'.tr(),
              maxLines: 4,
              onChanged: vm.setDescription,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'required'.tr() : null,
            ),
            SizedBox(height: AppSpacing.spaceMD),

            Row(
              children: [
                Expanded(
                  child: AppCustomTextField(
                    controller: _budget,
                    label: 'job_budget_label'.tr(),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => vm.setBudget(double.tryParse(v)),
                  ),
                ),
                SizedBox(width: AppSpacing.spaceMD),
                ElevatedButton.icon(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 5),
                    );
                    vm.setDeadline(picked);
                  },
                  icon: const Icon(Icons.event),
                  label: Text('job_deadline_label'.tr()),
                )
              ],
            ),
            SizedBox(height: AppSpacing.spaceMD),

            // ✅ Category dropdown
            AppDropdown<String>(
              label: 'category'.tr(),
              hint: 'select_category'.tr(),
              items: JobCategories.ids(),
              value: data.category.isEmpty ? null : data.category,
              onChanged: (v) => vm.setCategory(v ?? ''),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'required'.tr() : null,
            ),
            SizedBox(height: AppSpacing.spaceMD),

            Row(
              children: [
                Expanded(
                  child: AppCustomTextField(
                    controller: _skill,
                    label: 'job_add_skill_label'.tr(),
                  ),
                ),
                SizedBox(width: AppSpacing.spaceSM),
                IconButton(
                  onPressed: () {
                    vm.addSkill(_skill.text);
                    _skill.clear();
                  },
                  icon: const Icon(Icons.add_circle_outline),
                )
              ],
            ),

            if (skills.isNotEmpty) ...[
              SizedBox(height: AppSpacing.spaceSM),
              Wrap(
                spacing: 8,
                children: [
                  for (int i = 0; i < skills.length; i++)
                    Chip(
                      label: Text(skills[i]),
                      onDeleted: () => vm.removeSkillAt(i),
                    ),
                ],
              ),
            ],

            SizedBox(height: AppSpacing.spaceLG),

            AppPrimaryButton(
              variant: AppButtonVariant.outlined,
              label: data.isEdit ? 'common_save'.tr() : 'common_add'.tr(),
              isLoading: async.isLoading,
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;

                final errKey = await vm.submit(); // ✅ no context
                if (errKey != null) {
                  if (!context.mounted) return;
                  AppSnackbar.show(context, errKey.tr());
                  return;
                }

                if (context.mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
