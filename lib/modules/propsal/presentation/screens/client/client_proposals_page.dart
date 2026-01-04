import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_scaffold.dart';
import 'package:notes_tasks/modules/propsal/presentation/screens/client/client_job_proposals_section.dart';

class ClientJobProposalsPage extends StatelessWidget {
  final String jobId;
  const ClientJobProposalsPage({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scrollable: false,
      title: 'proposals_title'.tr(),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.spaceMD),
        child: ClientJobProposalsSection(jobId: jobId),
      ),
    );
  }
}
