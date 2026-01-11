import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/shared/providers/local_image_storage_provider.dart';
import 'package:notes_tasks/core/shared/widgets/header/app_cover_header.dart';
import 'package:notes_tasks/modules/profile/domain/entities/profile_entity.dart';

class PublicProfileHeader extends ConsumerWidget {
  final ProfileEntity profile;

  const PublicProfileHeader({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localImages = ref.watch(localImageStorageProvider);
    final uid = profile.uid;

    return AppCoverHeader(
      title: profile.name,
      subtitle: null,
      coverUrl: profile.coverUrl,
      coverBytes: localImages.coverFor(uid), // اختياري: لو عندك كاش محلي
      avatarUrl: profile.photoUrl,
      avatarBytes: localImages.avatarFor(uid),
      showAvatar: true,
      isCoverLoading: false,
      isAvatarLoading: false,
      onChangeCover: null, // ✅ read-only
      onChangeAvatar: null, // ✅ read-only
    );
  }
}
