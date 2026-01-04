import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/enums/page_mode.dart';
import 'package:notes_tasks/core/shared/widgets/buttons/primary_button.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_scaffold.dart';
import 'package:notes_tasks/core/shared/widgets/header/app_cover_header.dart';

class AppDetailsPage extends StatelessWidget {
  final String? appBarTitleKey;

  final String? coverImageUrl;
  final Uint8List? coverBytes;

  final String? avatarImageUrl;
  final Uint8List? avatarBytes;

  final String title;
  final String? subtitle;

  final String? primaryButtonLabelKey;
  final IconData? primaryButtonIcon;
  final VoidCallback? onPrimaryButtonPressed;

  final String proposalButtonLabelKey;
  final IconData? proposalButtonIcon;
  final VoidCallback? onProposalPressed;

  final List<Widget> sections;
  final List<IconButton> appBarActions;

  final bool showAvatar;
  final PageMode mode;

  final VoidCallback? onChangeCover;
  final VoidCallback? onChangeAvatar;

  final bool isCoverLoading;
  final bool isAvatarLoading;

  const AppDetailsPage({
    super.key,
    required this.mode,
    this.appBarTitleKey,
    this.coverImageUrl,
    this.coverBytes,
    this.avatarImageUrl,
    this.avatarBytes,
    required this.title,
    this.subtitle,
    this.primaryButtonLabelKey,
    this.primaryButtonIcon,
    this.onPrimaryButtonPressed,
    this.proposalButtonLabelKey = 'Make Proposal',
    this.proposalButtonIcon,
    this.onProposalPressed,
    this.sections = const [],
    this.appBarActions = const [],
    this.showAvatar = false,
    this.onChangeCover,
    this.onChangeAvatar,
    this.isCoverLoading = false,
    this.isAvatarLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEdit = mode == PageMode.edit;
    final isView = mode == PageMode.view;

    final colors = Theme.of(context).colorScheme;

    final bool showProposalBtn = isView && onProposalPressed != null;
    final bool showPrimaryBtn =
        primaryButtonLabelKey != null && onPrimaryButtonPressed != null;
    if (showProposalBtn || showPrimaryBtn) {
      debugPrint('DetailsPage buttons visible');
    }

    return AppScaffold(
      actions: appBarActions,
      title: appBarTitleKey?.tr(),
      scrollable: true,
      usePadding: true,
      showSettingsButton: false,
      showLogout: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ======================
          // Header
          // ======================
          AppCoverHeader(
            title: title,
            subtitle: subtitle,
            coverUrl: coverImageUrl,
            coverBytes: coverBytes,
            avatarUrl: avatarImageUrl,
            avatarBytes: avatarBytes,
            showAvatar: showAvatar,
            isCoverLoading: isCoverLoading,
            isAvatarLoading: isAvatarLoading,
            onChangeCover: isEdit ? onChangeCover : null,
            onChangeAvatar: isEdit ? onChangeAvatar : null,
          ),

          SizedBox(height: AppSpacing.spaceLG),

          // ======================
          // Buttons under header
          // ======================
          if (showProposalBtn || showPrimaryBtn)
            Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.spaceLG),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (showProposalBtn)
                    AppPrimaryButton(
                      variant: AppButtonVariant.outlined, // ✅ مفرّغ
                      label: proposalButtonLabelKey.tr(),
                      icon: proposalButtonIcon ?? Icons.send_outlined,
                      onPressed: onProposalPressed!,
                    ),
                  if (showProposalBtn && showPrimaryBtn)
                    SizedBox(height: AppSpacing.spaceSM),
                  if (showPrimaryBtn)
                    AppPrimaryButton(
                      variant: AppButtonVariant.primary, // ✅ ملوّن
                      label: primaryButtonLabelKey!.tr(),
                      icon: primaryButtonIcon ?? Icons.check,
                      onPressed: onPrimaryButtonPressed!,
                    ),
                ],
              ),
            ),

          // ======================
          // Sections
          // ======================
          if (sections.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _asProfessionalBlocks(
                context,
                sections,
                accent: colors.primary,
              ),
            ),

          SizedBox(height: AppSpacing.spaceLG),
        ],
      ),
    );
  }

  // Skip spacing-only widgets
  bool _isLayoutSpacer(Widget w) {
    if (w is SizedBox) {
      return w.child == null;
    }
    return w is Divider;
  }

  // Professional blocks with left accent line
  List<Widget> _asProfessionalBlocks(
    BuildContext context,
    List<Widget> children, {
    required Color accent,
  }) {
    final filtered = children.where((w) => !_isLayoutSpacer(w)).toList();
    if (filtered.isEmpty) return [];

    final out = <Widget>[];

    for (var i = 0; i < filtered.length; i++) {
      out.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: AppSpacing.r(4),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.85),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSpacing.r(14)),
                    bottomLeft: Radius.circular(AppSpacing.r(14)),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.spaceMD),
                  child: filtered[i],
                ),
              ),
            ],
          ),
        ),
      );

      if (i != filtered.length - 1) {
        out.add(SizedBox(height: AppSpacing.spaceMD));
      }
    }

    return out;
  }
}
