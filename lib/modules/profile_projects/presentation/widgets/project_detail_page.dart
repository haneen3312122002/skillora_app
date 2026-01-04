import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/app/theme/text_styles.dart';
import 'package:notes_tasks/core/shared/enums/page_mode.dart';

import 'package:notes_tasks/core/shared/widgets/pages/details_page.dart';
import 'package:notes_tasks/core/shared/widgets/tags/app_tags_wrap.dart';
import 'package:notes_tasks/modules/profile/presentation/services/project_image_helpers.dart';

import 'package:notes_tasks/modules/profile_projects/domain/entities/project_entity.dart';
import 'package:notes_tasks/modules/profile_projects/presentation/providers/project_image_storage_provider.dart';

import 'package:notes_tasks/modules/profile_projects/presentation/viewmodels/project_cover_image_viewmodel.dart';

class ProjectDetailsArgs {
  final ProjectEntity project;
  final PageMode mode;

  const ProjectDetailsArgs({
    required this.project,
    this.mode = PageMode.view,
  });
}

class ProjectDetailsPage extends ConsumerWidget {
  final ProjectEntity project;
  final PageMode mode;

  const ProjectDetailsPage({
    super.key,
    required this.project,
    this.mode = PageMode.view,
  });

  bool get _canEditHeader => mode == PageMode.edit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasDescription = project.description.trim().isNotEmpty;
    final hasTools = project.tools.isNotEmpty;
    final hasLink =
        project.projectUrl != null && project.projectUrl!.trim().isNotEmpty;

    final localCoverBytes =
        ref.watch(projectImageStorageProvider).covers[project.id];
    return AppDetailsPage(
      mode: mode,
      appBarTitleKey: 'project_details_title',
      coverImageUrl: project.imageUrl,
      coverBytes: localCoverBytes,
      avatarImageUrl: null,
      avatarBytes: null,
      showAvatar: false,
      title: project.title,
      subtitle: null,
      onChangeCover: _canEditHeader
          ? () {
              pickAndUploadProjectCover(
                context,
                ref,
                projectId: project.id,
              );
            }
          : null,
      onChangeAvatar: null,
      sections: [
        if (hasDescription)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'project_description_title'.tr(),
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSpacing.spaceSM),
              Text(
                project.description,
                style: AppTextStyles.body,
              ),
            ],
          ),
        if (hasTools)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'project_tools_label'.tr(),
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSpacing.spaceSM),
              AppTagsWrap(
                tags: project.tools,
              ),
            ],
          ),
      ],
    );
  }
}
