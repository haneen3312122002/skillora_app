import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // 👈 أضف هذا

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/app/theme/text_styles.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_scaffold.dart';
import 'package:notes_tasks/core/shared/widgets/buttons/primary_button.dart';

class AppTextEditPage extends StatefulWidget {
  final String title;
  final String? description;
  final String initialText;
  final String buttonLabel;

  final int minLines;
  final int maxLines;

  final Future<void> Function(String newValue)? onSave;

  const AppTextEditPage({
    super.key,
    required this.title,
    required this.initialText,
    required this.buttonLabel,
    this.description,
    this.minLines = 4,
    this.maxLines = 6,
    this.onSave,
  });

  @override
  State<AppTextEditPage> createState() => _AppTextEditPageState();
}

class _AppTextEditPageState extends State<AppTextEditPage> {
  late final TextEditingController _controller;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_isSubmitting) return;
    if (widget.onSave == null) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.onSave!.call(_controller.text);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      actions: const [],
      title: widget.title,
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.description != null) ...[
              Text(
                widget.description!,
                style: AppTextStyles.body,
              ),
              SizedBox(height: AppSpacing.spaceMD),
            ],
            TextField(
              controller: _controller,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: AppSpacing.spaceLG),
            AppPrimaryButton(
              variant: AppButtonVariant.outlined,
              label: _isSubmitting ? 'saving'.tr() : widget.buttonLabel,
              onPressed: _handleSubmit,
              isLoading: _isSubmitting,
            ),
          ],
        ),
      ),
    );
  }
}
