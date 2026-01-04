import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/services/notifications/notifications_providers.dart';
import 'package:notes_tasks/core/shared/enums/role.dart';
import 'package:notes_tasks/modules/profile/domain/entities/profile_entity.dart';

typedef HomeNavigateToChat = void Function(String chatId);
typedef HomeNavigateToProposal = void Function(String proposalId);

final homeBootstrapViewModelProvider =
    NotifierProvider<HomeBootstrapViewModel, void>(HomeBootstrapViewModel.new);

class HomeBootstrapViewModel extends Notifier<void> {
  bool _didInitNotifications = false;
  String? _lastUid;

  @override
  void build() {
    // no-op
  }

  /// Call this whenever profile is available.
  /// It will init notifications only once per user session.
  void bootstrap({
    required ProfileEntity profile,
    required HomeNavigateToChat onChat,
    required HomeNavigateToProposal onProposal,
  }) {
    // If user changed, allow init again.
    if (_lastUid != null && _lastUid != profile.uid) {
      _didInitNotifications = false;
    }
    _lastUid = profile.uid;

    if (_didInitNotifications) return;
    _didInitNotifications = true;

    ref.read(notificationsBootstrapProvider).init(
          uid: profile.uid,
          isFreelancer: profile.role == UserRole.freelancer,
          onTap: (data) {
            final type = (data['type'] ?? '').toString();

            if (type == 'chat_message') {
              final chatId = (data['chatId'] ?? '').toString();
              if (chatId.isNotEmpty) onChat(chatId);
              return;
            }

            if (type == 'proposal_status') {
              final proposalId =
                  (data['proposalId'] ?? data['refId'] ?? '').toString();
              if (proposalId.isNotEmpty) onProposal(proposalId);
              return;
            }
          },
        );
  }

  /// Call this on logout / guest.
  void reset() {
    _didInitNotifications = false;
    _lastUid = null;

    // reset underlying notifications service state too
    ref.read(notificationsBootstrapProvider).reset();
  }
}
