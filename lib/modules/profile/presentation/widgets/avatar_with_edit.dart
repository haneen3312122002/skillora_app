import 'package:flutter/material.dart';
import 'package:notes_tasks/core/constants/colors.dart';

class AvatarWithEdit extends StatelessWidget {
  final String? photoUrl;
  final bool isLoading;
  final VoidCallback onChangeAvatar;

  const AvatarWithEdit({
    super.key,
    required this.photoUrl,
    required this.isLoading,
    required this.onChangeAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.border,
          backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
          child: photoUrl == null
              ? const Icon(Icons.person, size: 40, color: Colors.white)
              : null,
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: isLoading ? null : onChangeAvatar,
          icon: isLoading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.edit),
          label: const Text('Change photo'),
        ),
      ],
    );
  }
}
