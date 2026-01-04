import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/app/theme/text_styles.dart';
import 'package:notes_tasks/core/shared/enums/page_mode.dart';
import 'package:notes_tasks/core/shared/widgets/buttons/app_icon_button.dart';
import 'package:notes_tasks/core/shared/widgets/cards/app_section_card.dart';
import 'package:notes_tasks/core/shared/widgets/images/app_cover_images.dart';
import 'package:notes_tasks/core/shared/widgets/lists/app_grid_view.dart';
import 'package:notes_tasks/core/shared/widgets/lists/app_list_tile.dart';
import 'package:notes_tasks/core/shared/widgets/tags/app_tags_wrap.dart';
import 'package:notes_tasks/core/shared/widgets/texts/expandable_text.dart';
import 'package:notes_tasks/modules/job/presentation/services/job_cover_picker.dart';
import 'package:notes_tasks/modules/job/presentation/viewmodels/job_cover_image_viewmodel.dart';
import 'package:notes_tasks/modules/profile_projects/domain/entities/profile_item.dart';

/// ✅ Layout modes
enum ProfileItemsLayout { grid, horizontalList }

class ProfileItemsSection<T extends ProfileItem> extends ConsumerWidget {
  final List<T> items;
  final String titleKey;
  final String emptyHintKey;
  final VoidCallback onAdd;
  final void Function(BuildContext context, T item) onTap;
  final Future<void> Function(WidgetRef ref, T item)? onEdit;
  final Future<void> Function(WidgetRef ref, T item)? onDelete;

  /// optional: extra info under title
  final Widget Function(BuildContext context, T item)? extraInfoBuilder;

  /// build cover widget (can watch providers inside)
  final Widget Function(BuildContext context, WidgetRef ref, T item)?
      coverBuilder;

  /// fallback placeholder icon
  final IconData placeholderIcon;

  /// choose layout
  final ProfileItemsLayout layout;

  /// horizontal list sizing (base values, will be converted using ScreenUtil)
  final double horizontalItemWidth;
  final double horizontalListHeight;

  /// mode (view/edit)
  final PageMode mode;

  const ProfileItemsSection({
    super.key,
    required this.items,
    required this.titleKey,
    required this.emptyHintKey,
    required this.onAdd,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    this.extraInfoBuilder,
    this.coverBuilder,
    this.placeholderIcon = Icons.work_outline,

    /// defaults
    this.layout = ProfileItemsLayout.grid,
    this.horizontalItemWidth = 260,
    this.horizontalListHeight = 340,

    /// default mode
    this.mode = PageMode.edit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasItems = items.isNotEmpty;
    final canEdit = mode == PageMode.edit;

    // ✅ Responsive sizes using ScreenUtil helpers
    final listH = AppSpacing.y(horizontalListHeight);
    final itemW = AppSpacing.x(horizontalItemWidth);

    final padX = AppSpacing.x(16);
    final padY = AppSpacing.y(16);
    final gapX = AppSpacing.x(16);

    return ProfileSectionCard(
      titleKey: titleKey,
      useCard: false,
      actions: canEdit
          ? [
              AppIconButton(
                onTap: onAdd,
                icon: hasItems ? Icons.add : Icons.add_circle_outline,
              ),
            ]
          : const [],
      child: hasItems
          ? (layout == ProfileItemsLayout.grid
              ? AppGridView(
                  itemCount: items.length,
                  minItemWidth:
                      220, // ✅ خليها زي ما هي (غالبًا عندك داخليًا responsive)
                  childAspectRatio: 3 / 4,
                  mainAxisSpacing: AppSpacing.spaceXS,
                  crossAxisSpacing: AppSpacing.spaceSM,
                  padding: EdgeInsets.only(bottom: AppSpacing.spaceMD),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _ProfileItemTile<T>(
                      key: ValueKey('profile_item_${item.id}'),
                      item: item,
                      onTap: () => onTap(context, item),
                      onEdit: (canEdit && onEdit != null)
                          ? () => onEdit!(ref, item)
                          : null,
                      onDelete: (canEdit && onDelete != null)
                          ? () => onDelete!(ref, item)
                          : null,
                      extraInfo: extraInfoBuilder != null
                          ? extraInfoBuilder!(context, item)
                          : null,
                      placeholderIcon: placeholderIcon,
                      coverBuilder: coverBuilder,
                    );
                  },
                )
              : SizedBox(
                  height: listH,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(
                      left: padX,
                      right: padX,
                      bottom: padY,
                    ),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => SizedBox(width: gapX),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return SizedBox(
                        width: itemW,
                        child: _ProfileItemTile<T>(
                          key: ValueKey('profile_item_${item.id}'),
                          item: item,
                          onTap: () => onTap(context, item),
                          onEdit: (canEdit && onEdit != null)
                              ? () => onEdit!(ref, item)
                              : null,
                          onDelete: (canEdit && onDelete != null)
                              ? () => onDelete!(ref, item)
                              : null,
                          extraInfo: extraInfoBuilder != null
                              ? extraInfoBuilder!(context, item)
                              : null,
                          placeholderIcon: placeholderIcon,
                          coverBuilder: coverBuilder,
                        ),
                      );
                    },
                  ),
                ))
          : Padding(
              padding: EdgeInsets.only(
                bottom: AppSpacing.y(8),
                top: AppSpacing.y(4),
              ),
              child: Text(
                emptyHintKey.tr(),
                style: AppTextStyles.caption.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
    );
  }
}

class _ProfileItemTile<T extends ProfileItem> extends ConsumerWidget {
  final T item;
  final VoidCallback onTap;
  final Future<void> Function()? onEdit;
  final Future<void> Function()? onDelete;

  final Widget? extraInfo;
  final IconData placeholderIcon;

  final Widget Function(BuildContext context, WidgetRef ref, T item)?
      coverBuilder;

  const _ProfileItemTile({
    super.key,
    required this.item,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    this.extraInfo,
    this.placeholderIcon = Icons.work_outline,
    this.coverBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final hasDescription = item.description.trim().isNotEmpty;
    final hasTags = item.tags.isNotEmpty;

    final cover = coverBuilder != null
        ? coverBuilder!(context, ref, item)
        : Consumer(
            builder: (context, ref, _) {
              final bytes = ref.watch(jobCoverImageViewModelProvider(item.id));
              return AppRectImage(
                key: ValueKey(bytes?.length ?? 0),
                imageUrl: item.imageUrl,
                bytes: bytes,
                placeholderIcon: placeholderIcon,
              );
            },
          );

    final showMenu = (onEdit != null || onDelete != null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        cover,
        SizedBox(height: AppSpacing.y(8)),
        AppListTile(
          onTap: onTap,
          animate: false,
          title: item.title,
          subtitle: null,
          leading: null,
          trailing: showMenu
              ? PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.r(12)),
                  ),
                  onSelected: (value) async {
                    switch (value) {
                      case 'edit':
                        if (onEdit != null) await onEdit!();
                        break;
                      case 'delete':
                        if (onDelete != null) await onDelete!();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    if (onEdit != null)
                      PopupMenuItem(
                        value: 'edit',
                        child: Text(
                          'common_menu_edit'.tr(),
                          style: AppTextStyles.body.copyWith(fontSize: 13),
                        ),
                      ),
                    if (onDelete != null)
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'common_menu_delete'.tr(),
                          style: AppTextStyles.body.copyWith(
                            fontSize: 13,
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                  ],
                )
              : null,
        ),
        if (extraInfo != null) ...[
          SizedBox(height: AppSpacing.y(4)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.x(8)),
            child: extraInfo!,
          ),
        ],
        if (hasDescription) ...[
          SizedBox(height: AppSpacing.y(4)),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.x(8),
              vertical: AppSpacing.y(4),
            ),
            child: ExpandableText(
              id: 'profile_item_desc_${item.id}',
              text: item.description,
              enableToggle: false,
              trimLines: 2,
              style: AppTextStyles.caption.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.9),
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
        if (hasTags) ...[
          SizedBox(height: AppSpacing.y(8)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.x(8)),
            child: AppTagsWrap(tags: item.tags),
          ),
        ],
      ],
    );
  }
}
