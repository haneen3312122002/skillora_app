import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/enums/page_mode.dart';
import 'package:notes_tasks/core/shared/widgets/buttons/primary_button.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_scaffold.dart';
import 'package:notes_tasks/core/shared/widgets/header/app_cover_header.dart';

// ✅ New: use your new details widgets
import 'package:notes_tasks/core/shared/widgets/details/details_section_title.dart';
import 'package:notes_tasks/core/shared/widgets/details/details_info_group.dart';

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
    this.proposalButtonLabelKey = 'make_proposal',
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

    final showProposalBtn = isView && onProposalPressed != null;
    final showPrimaryBtn =
        primaryButtonLabelKey != null && onPrimaryButtonPressed != null;

    return AppScaffold(
      actions: appBarActions,
      title: appBarTitleKey?.tr(),
      scrollable: false, // ✅ we control scrolling inside
      usePadding: false, // ✅ custom padding
      showSettingsButton: false,
      showLogout: false,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(
                left: AppSpacing.spaceMD,
                right: AppSpacing.spaceMD,
                top: AppSpacing.spaceMD,
                bottom: AppSpacing.spaceLG,
              ),
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
                // Sections as Cards
                // ======================
                if (sections.isNotEmpty)
                  ..._buildSectionCards(
                    context,
                    sections,
                    surface: colors.surface,
                    outline: colors.outlineVariant.withOpacity(0.6),
                  ),
              ],
            ),
          ),

          // ======================
          // Bottom action bar (always visible)
          // ======================
          if (showProposalBtn || showPrimaryBtn)
            SafeArea(
              top: false,
              child: Container(
                padding: EdgeInsets.all(AppSpacing.spaceMD),
                decoration: BoxDecoration(
                  color: colors.surface,
                  border: Border(
                    top: BorderSide(
                      color: colors.outlineVariant.withOpacity(0.7),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showProposalBtn)
                      AppPrimaryButton(
                        variant: AppButtonVariant.outlined,
                        label: proposalButtonLabelKey.tr(),
                        icon: proposalButtonIcon ?? Icons.send_outlined,
                        onPressed: onProposalPressed!,
                      ),
                    if (showProposalBtn && showPrimaryBtn)
                      SizedBox(height: AppSpacing.spaceSM),
                    if (showPrimaryBtn)
                      AppPrimaryButton(
                        variant: AppButtonVariant.primary,
                        label: primaryButtonLabelKey!.tr(),
                        icon: primaryButtonIcon ?? Icons.check,
                        onPressed: onPrimaryButtonPressed!,
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildSectionCards(
    BuildContext context,
    List<Widget> children, {
    required Color surface,
    required Color outline,
  }) {
    final filtered = children.where((w) => !_isLayoutSpacer(w)).toList();
    if (filtered.isEmpty) return [];

    return List.generate(filtered.length, (i) {
      return Padding(
        padding: EdgeInsets.only(bottom: AppSpacing.spaceMD),
        child: _DetailsCard(
          surface: surface,
          outline: outline,
          child: filtered[i],
        ),
      );
    });
  }

  bool _isLayoutSpacer(Widget w) {
    if (w is SizedBox) return w.child == null;
    return w is Divider;
  }
}

class _DetailsCard extends StatelessWidget {
  final Widget child;
  final Color surface;
  final Color outline;

  const _DetailsCard({
    required this.child,
    required this.surface,
    required this.outline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppSpacing.r(16)),
        border: Border.all(color: outline),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            spreadRadius: 0,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      padding: EdgeInsets.all(AppSpacing.spaceMD),
      child: child,
    );
  }
}
