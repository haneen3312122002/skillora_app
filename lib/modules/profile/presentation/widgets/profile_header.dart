import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/constants/colors.dart';
import 'package:notes_tasks/core/theme/text_styles.dart';
import 'package:notes_tasks/core/widgets/app_card.dart';
import 'package:notes_tasks/modules/profile/presentation/viewmodels/UploadCoverImageViewModel.dart';
import 'package:notes_tasks/modules/profile/presentation/viewmodels/UploadProfileImageViewModel.dart';
import 'package:notes_tasks/modules/profile/presentation/widgets/avatar_with_edit.dart';
import 'package:notes_tasks/modules/profile/presentation/widgets/cover_image_widget.dart';
import 'package:notes_tasks/modules/profile/services/photo_services.dart';

class ProfileHeader extends ConsumerWidget {
  final Map<String, dynamic> profile;

  const ProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = profile['name'] as String? ?? 'No name';
    final email = profile['email'] as String? ?? '';
    final photoUrl = profile['photoUrl'] as String?;
    final coverUrl = profile['coverUrl'] as String?;

    final uploadAvatarState = ref.watch(uploadProfileImageViewModelProvider);
    final uploadCoverState = ref.watch(uploadCoverImageViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //cover
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CoverImage(
              coverUrl: coverUrl,
              isLoading: uploadCoverState.isLoading,
              onChangeCover: () => pickAndUploadCover(context, ref),
            ),
            Positioned(
              bottom: -40,
              child: AvatarWithEdit(
                photoUrl: photoUrl,
                isLoading: uploadAvatarState.isLoading,
                onChangeAvatar: () => pickAndUploadAvatar(context, ref),
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),
        Center(
          child: Column(
            children: [
              Text(
                name,
                style: AppTextStyles.title,
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.textPrimary.withOpacity(0.7)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
