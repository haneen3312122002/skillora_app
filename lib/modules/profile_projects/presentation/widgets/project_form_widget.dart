import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/widgets/fields/custom_text_field.dart';
import 'package:notes_tasks/core/shared/widgets/pages/app_form.dart';
import 'package:notes_tasks/core/shared/widgets/tags/app_tags_editor.dart';

import 'package:notes_tasks/modules/profile_projects/domain/entities/project_entity.dart';
import 'package:notes_tasks/modules/profile_projects/presentation/viewmodels/project_form_viewmodel.dart';

class ProjectFormWidget extends ConsumerStatefulWidget {
  final ProjectEntity? initialProject;

  const ProjectFormWidget({
    super.key,
    this.initialProject,
  });

  @override
  ConsumerState<ProjectFormWidget> createState() => _ProjectFormWidgetState();
}

class _ProjectFormWidgetState extends ConsumerState<ProjectFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _imageUrlCtrl = TextEditingController();
  final _projectUrlCtrl = TextEditingController();
  final _toolCtrl = TextEditingController();

  bool _vmInitialized = false;

  @override
  void initState() {
    super.initState();

    final p = widget.initialProject;
    if (p != null) {
      _titleCtrl.text = p.title;
      _descriptionCtrl.text = p.description;
      _imageUrlCtrl.text = p.imageUrl ?? '';
      _projectUrlCtrl.text = p.projectUrl ?? '';
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _vmInitialized) return;
      _vmInitialized = true;

      final vm = ref.read(projectFormViewModelProvider.notifier);

      if (widget.initialProject != null) {
        vm.initForEdit(widget.initialProject!);
      } else {
        vm.initForCreate();
      }
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _imageUrlCtrl.dispose();
    _projectUrlCtrl.dispose();
    _toolCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(projectFormViewModelProvider);
    final formState = asyncState.value;
    final isLoading = asyncState.isLoading;

    if (formState == null) {
      return Padding(
        padding: EdgeInsets.all(AppSpacing.spaceMD),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final tools = formState.tools;

    return AppForm(
      formKey: _formKey,
      isLoading: isLoading,
      submitLabel: formState.isEdit
          ? 'project_save_changes'.tr()
          : 'project_add_button'.tr(),
      onSubmit: () async => _handleSubmit(context),
      fields: [
        AppCustomTextField(
          controller: _titleCtrl,
          label: 'project_title_label'.tr(),
          inputAction: TextInputAction.next,
          animate: false,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'project_title_required'.tr();
            }
            return null;
          },
        ),
        SizedBox(height: AppSpacing.spaceMD),
        AppCustomTextField(
          controller: _descriptionCtrl,
          label: 'project_description_label'.tr(),
          maxLines: 4,
          inputAction: TextInputAction.newline,
          animate: false,
        ),
        SizedBox(height: AppSpacing.spaceMD),
        AppCustomTextField(
          controller: _imageUrlCtrl,
          label: 'project_image_url_label'.tr(),
          keyboardType: TextInputType.url,
          inputAction: TextInputAction.next,
          animate: false,
        ),
        SizedBox(height: AppSpacing.spaceMD),
        AppCustomTextField(
          controller: _projectUrlCtrl,
          label: 'project_link_label'.tr(),
          keyboardType: TextInputType.url,
          inputAction: TextInputAction.next,
          animate: false,
        ),
        SizedBox(height: AppSpacing.spaceMD),
        AppTagsEditor(
          tags: tools,
          controller: _toolCtrl,
          onAddTag: _addTool,
          onRemoveTagAt: (index) => ref
              .read(projectFormViewModelProvider.notifier)
              .removeToolAt(index),
          labelKey: 'project_tool_new_label',
          hintKey: 'project_tool_new_hint',
          addTooltipKey: 'project_tool_add_tooltip',
          emptyHintKey: 'project_tools_empty_hint',
        ),
      ],
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final vm = ref.read(projectFormViewModelProvider.notifier);
    vm.updateFields(
      title: _titleCtrl.text.trim(),
      description: _descriptionCtrl.text.trim(),
      imageUrl: _imageUrlCtrl.text.trim(),
      projectUrl: _projectUrlCtrl.text.trim(),
    );
    final success = await vm.submit(context);

    if (mounted && success) {
      Navigator.of(context).maybePop();
    }
  }

  void _addTool() {
    final text = _toolCtrl.text.trim();
    if (text.isEmpty) return;

    ref.read(projectFormViewModelProvider.notifier).addTool(text);
    _toolCtrl.clear();
  }
}
