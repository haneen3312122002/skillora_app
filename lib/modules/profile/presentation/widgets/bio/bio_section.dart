import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/app/theme/text_styles.dart';
import 'package:notes_tasks/core/shared/widgets/buttons/app_icon_button.dart';
import 'package:notes_tasks/core/shared/widgets/cards/app_section_card.dart';
import 'package:notes_tasks/core/shared/widgets/fields/custom_text_field.dart';
import 'package:notes_tasks/core/shared/widgets/texts/expandable_text.dart';

class BioSection extends StatefulWidget {
  final String titleKey; // ex: 'profile_bio'
  final String? bio; // النص الحالي
  final String emptyHintKey; // ex: 'bio_empty_hint'
  final bool canEdit;

  final bool isEditing;
  final bool isSaving;

  final VoidCallback onEdit;
  final VoidCallback onCancel;
  final ValueChanged<String> onChanged;
  final Future<void> Function() onSave;

  const BioSection({
    super.key,
    required this.titleKey,
    required this.bio,
    required this.emptyHintKey,
    required this.isEditing,
    required this.isSaving,
    required this.onEdit,
    required this.onCancel,
    required this.onChanged,
    required this.onSave,
    required this.canEdit,
  });

  @override
  State<BioSection> createState() => _BioSectionState();
}

class _BioSectionState extends State<BioSection> {
  late final TextEditingController _controller;

  bool get _isEmptyBio => widget.bio == null || widget.bio!.trim().isEmpty;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.bio ?? '');
  }

  @override
  void didUpdateWidget(covariant BioSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!widget.isEditing && oldWidget.bio != widget.bio) {
      _controller.text = widget.bio ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final titleText = widget.titleKey.tr(); // "About" / "نبذة"
    final emptyHintText = widget.emptyHintKey.tr(); // hint مترجم

    return ProfileSectionCard(
      titleKey: widget.titleKey,
      useCard: false,
      actions: [
        if (widget.canEdit) ...[
          if (!widget.isEditing)
            AppIconButton(
              onTap: widget.onEdit,
              icon: _isEmptyBio ? Icons.add : Icons.edit,
            )
          else ...[
            TextButton(
              onPressed: widget.isSaving ? null : widget.onCancel,
              child: Text('cancel'.tr()),
            ),
            const SizedBox(width: 4),
            TextButton.icon(
              onPressed: widget.isSaving ? null : widget.onSave,
              icon: widget.isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: Text('save'.tr()),
            ),
          ],
        ],
      ],
      child: Padding(
        padding: EdgeInsets.only(bottom: AppSpacing.spaceSM),
        child: widget.isEditing
            ? AppCustomTextField(
                controller: _controller,
                label: titleText, // 👈 هنا يظهر "About" / "نبذة"
                hint: emptyHintText, // 👈 نص الهنت مترجم
                maxLines: 5,
                animate: false,
                onSubmitted: (_) {},
                onChanged: widget.onChanged,
              )
            : _isEmptyBio
                ? Text(
                    emptyHintText,
                    style: AppTextStyles.caption.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  )
                : ExpandableText(
                    id: widget.titleKey,
                    text: widget.bio!,
                    trimLines: 2,
                  ),
      ),
    );
  }
}
