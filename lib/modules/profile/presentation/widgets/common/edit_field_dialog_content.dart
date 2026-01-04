import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';
import 'package:notes_tasks/core/shared/widgets/fields/custom_text_field.dart';
import 'package:notes_tasks/core/shared/widgets/buttons/primary_button.dart';

class EditFieldDialogContent extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final Future<void> Function(String value) onSave;

  const EditFieldDialogContent({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
    required this.onSave,
  });

  @override
  State<EditFieldDialogContent> createState() => _EditFieldDialogContentState();
}

class _EditFieldDialogContentState extends State<EditFieldDialogContent> {
  bool _isSaving = false;

  Future<void> _handleSave() async {
    final value = widget.controller.text.trim();
    if (value.isEmpty) {
      return AppSnackbar.show(context, 'empty_field'.tr());
    }

    setState(() => _isSaving = true);
    try {
      await widget.onSave(value);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppCustomTextField(
          controller: widget.controller,
          label: widget.label,
          keyboardType: widget.keyboardType,
          inputAction: TextInputAction.done,
          onSubmitted: (_) => _handleSave(),
        ),
        SizedBox(height: AppSpacing.spaceMD),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: Text('dialog_cancel'.tr()),
              onPressed: _isSaving ? null : () => Navigator.pop(context),
            ),
            SizedBox(width: AppSpacing.spaceXS),
            AppPrimaryButton(
              variant: AppButtonVariant.outlined,
              label: 'dialog_save'.tr(),
              isLoading: _isSaving,
              onPressed: _isSaving ? () {} : _handleSave,
            ),
          ],
        ),
      ],
    );
  }
}
