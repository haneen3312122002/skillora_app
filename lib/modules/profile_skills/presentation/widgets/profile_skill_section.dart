import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/widgets/buttons/app_icon_button.dart';
import 'package:notes_tasks/core/shared/widgets/cards/app_section_card.dart';
import 'package:notes_tasks/core/shared/widgets/tags/app_tags_editor.dart';
import 'package:notes_tasks/core/shared/widgets/tags/app_tags_wrap.dart';

class ProfileSkillsSection extends StatefulWidget {
  final String titleKey;
  final List<String> skills;

  final bool canEdit; // ✅ جديد
  final bool isEditing;
  final bool isSaving;

  final VoidCallback onEdit;
  final VoidCallback onCancel;
  final Future<void> Function() onSave;

  final ValueChanged<String> onAddSkill;
  final ValueChanged<int> onRemoveSkillAt;

  const ProfileSkillsSection({
    super.key,
    this.titleKey = 'skills_title',
    required this.skills,
    required this.canEdit, // ✅
    required this.isEditing,
    required this.isSaving,
    required this.onEdit,
    required this.onCancel,
    required this.onSave,
    required this.onAddSkill,
    required this.onRemoveSkillAt,
  });

  @override
  State<ProfileSkillsSection> createState() => _ProfileSkillsSectionState();
}

class _ProfileSkillsSectionState extends State<ProfileSkillsSection> {
  final TextEditingController _newSkillCtrl = TextEditingController();

  bool get _hasSkills => widget.skills.isNotEmpty;

  @override
  void dispose() {
    _newSkillCtrl.dispose();
    super.dispose();
  }

  void _addSkill() {
    final text = _newSkillCtrl.text.trim();
    if (text.isEmpty) return;
    widget.onAddSkill(text);
    _newSkillCtrl.clear();
  }

  List<Widget> _buildActions() {
    // ✅ زائر: لا actions
    if (!widget.canEdit) return [];

    if (!widget.isEditing) {
      return [
        AppIconButton(
          icon: _hasSkills ? Icons.edit_outlined : Icons.add,
          onTap: widget.onEdit,
        ),
      ];
    }

    return [
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
    ];
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.spaceSM),
      child: widget.isEditing
          ? AppTagsEditor(
              tags: widget.skills,
              controller: _newSkillCtrl,
              onAddTag: _addSkill,
              onRemoveTagAt: widget.onRemoveSkillAt,
              emptyHintKey: 'skills_edit_empty_hint',
              labelKey: 'skills_new_label',
              hintKey: 'skills_new_hint',
              addTooltipKey: 'skills_add_tooltip',
            )
          : AppTagsWrap(
              tags: widget.skills,
              emptyTextKey: 'skills_empty_hint',
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      titleKey: widget.titleKey,
      actions: _buildActions(),
      useCard: false,
      child: _buildContent(),
    );
  }
}
