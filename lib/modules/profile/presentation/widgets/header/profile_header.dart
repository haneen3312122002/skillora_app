import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/shared/providers/local_image_storage_provider.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';
import 'package:notes_tasks/core/shared/widgets/header/app_cover_header.dart';
import 'package:notes_tasks/modules/profile/domain/entities/profile_entity.dart';
import 'package:notes_tasks/modules/profile/presentation/viewmodels/profile/profile_header_actions_viewmodel.dart';

class ProfileHeader extends ConsumerWidget {
  final ProfileEntity profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localImages = ref.watch(localImageStorageProvider);
    final vm = ref.read(profileHeaderActionsViewModelProvider);
    final uid = profile.uid;

    Future<void> _handleResult(String? err,
        {required String successKey}) async {
      if (!context.mounted || err == 'cancelled') return;

      AppSnackbar.show(
        context,
        err == null ? successKey.tr() : err.tr(),
      );
    }

    return AppCoverHeader(
      title: profile.name,
      subtitle: null,
      coverUrl: profile.coverUrl,
      coverBytes: localImages.coverFor(uid),
      avatarUrl: profile.photoUrl,
      avatarBytes: localImages.avatarFor(uid),
      showAvatar: true,
      isCoverLoading: false,
      isAvatarLoading: false,
      onChangeCover: () async {
        final err = await vm.changeCover(uid: uid);
        await _handleResult(err, successKey: 'cover_image_updated');
      },
      onChangeAvatar: () async {
        final err = await vm.changeAvatar(uid: uid);
        await _handleResult(err, successKey: 'profile_image_updated');
      },
    );
  }
}
