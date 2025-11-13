import 'package:flutter/material.dart';
import 'package:notes_tasks/core/widgets/custom_text_field.dart';
import 'package:notes_tasks/core/widgets/primary_button.dart';

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
  State<EditFieldDialogContent> createState() =>
      _EditFieldDialogContentState();
}

class _EditFieldDialogContentState extends State<EditFieldDialogContent> {
  bool _isSaving = false;

  Future<void> _handleSave() async {
    final value = widget.controller.text.trim();
    if (value.isEmpty) return;

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
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: _isSaving ? null : () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 8),
            AppPrimaryButton(
              label: 'Save',
              isLoading: _isSaving,
              onPressed: _isSaving ? () {} : _handleSave,
            ),
          ],
        ),
      ],
    );
  }
}
