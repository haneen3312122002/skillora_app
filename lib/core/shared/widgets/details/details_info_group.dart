import 'package:flutter/material.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';

class DetailsInfoGroup extends StatelessWidget {
  final List<Widget> children;
  const DetailsInfoGroup({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...children,
        SizedBox(height: AppSpacing.spaceSM),
      ],
    );
  }
}
