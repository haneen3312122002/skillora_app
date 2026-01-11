import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:notes_tasks/core/app/routes/app_routes.dart';
import 'package:notes_tasks/core/shared/enums/page_mode.dart';
import 'package:notes_tasks/core/shared/widgets/common/profile_items_section.dart';
import 'package:notes_tasks/core/shared/widgets/pages/app_bottom_sheet.dart';

import 'package:notes_tasks/modules/profile_projects/domain/entities/project_entity.dart';
import 'package:notes_tasks/modules/profile_projects/domain/usecases/delete_project_usecase.dart';
import 'package:notes_tasks/modules/profile_projects/presentation/widgets/project_detail_page.dart';
import 'package:notes_tasks/modules/profile_projects/presentation/widgets/project_form_widget.dart';

class ProfileProjectsSection extends ConsumerWidget {
  final List<ProjectEntity> projects;
  final bool canEdit; // ✅ جديد

  const ProfileProjectsSection({
    super.key,
    required this.projects,
    required this.canEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProfileItemsSection<ProjectEntity>(
      items: projects,
      titleKey: 'projects_title',
      emptyHintKey: 'projects_empty_hint',

      // ✅ إذا زائر: لا Add
      onAdd: canEdit
          ? () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return const AppBottomSheet(
                    child: ProjectFormWidget(),
                  );
                },
              );
            }
          : null,

      onTap: (context, project) {
        context.push(
          AppRoutes.projectDetails,
          extra: ProjectDetailsArgs(
            project: project,
            mode: canEdit ? PageMode.edit : PageMode.view, // ✅ زائر view
          ),
        );
      },

      // ✅ إذا زائر: لا Edit
      onEdit: canEdit
          ? (ref, project) async {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return AppBottomSheet(
                    child: ProjectFormWidget(initialProject: project),
                  );
                },
              );
            }
          : null,

      // ✅ إذا زائر: لا Delete
      onDelete: canEdit
          ? (ref, project) async {
              final deleteUseCase = ref.read(deleteProjectUseCaseProvider);
              await deleteUseCase(project.id);
            }
          : null,
    );
  }
}
