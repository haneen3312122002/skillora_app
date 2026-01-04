import 'package:flutter/material.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/widgets/buttons/primary_button.dart';

class AppForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> fields;

  final String submitLabel;
  final bool isLoading;
  final Future<void> Function() onSubmit;

  final EdgeInsetsGeometry? padding;

  final Widget? footer;

  const AppForm({
    super.key,
    required this.formKey,
    required this.fields,
    required this.submitLabel,
    required this.isLoading,
    required this.onSubmit,
    this.padding,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding ?? EdgeInsets.all(AppSpacing.spaceMD),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            ...fields,
            SizedBox(height: AppSpacing.spaceLG),
            AppPrimaryButton(
              variant: AppButtonVariant.outlined,
              label: submitLabel,
              isLoading: isLoading,
              onPressed: isLoading
                  ? () {}
                  : () async {
                      if (!formKey.currentState!.validate()) return;
                      await onSubmit();
                    },
            ),
            if (footer != null) ...[
              SizedBox(height: AppSpacing.spaceMD),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}
