import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/session/providers/current_user_provider.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/widgets/animation/chat/chat_input_bar.dart';
import 'package:notes_tasks/core/shared/widgets/animation/chat/chat_messages_list.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_scaffold.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';
import 'package:notes_tasks/core/data/remote/firebase/providers/firebase_providers.dart';

import 'package:notes_tasks/modules/chat/domain/failures/chat_failure.dart';
import 'package:notes_tasks/modules/chat/presentation/providers/chat_stream_providers.dart';
import 'package:notes_tasks/modules/chat/presentation/viewmodels/chat_actions_viewmodel.dart';

// ✅ new reusable list widget (adjust path to your project structure)

class ChatDetailsScreen extends ConsumerStatefulWidget {
  final String chatId;
  const ChatDetailsScreen({super.key, required this.chatId});

  @override
  ConsumerState<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends ConsumerState<ChatDetailsScreen> {
  final _ctrl = TextEditingController();
  late final ProviderSubscription _chatSub;

  final ScrollController _scroll = ScrollController();

  void _safeJumpToBottom() {
    if (!_scroll.hasClients) return;
    _scroll.animateTo(
      0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  void _resetInput() {
    _ctrl.clear();
    _safeJumpToBottom();
  }

  @override
  void initState() {
    super.initState();

    // ✅ listen only for errors (snackbar)
    _chatSub = ref.listenManual(chatActionsViewModelProvider, (prev, next) {
      next.whenOrNull(
        error: (e, _) {
          if (!mounted) return;
          final key =
              (e is ChatFailure) ? e.messageKey : 'something_went_wrong';
          AppSnackbar.show(context, key.tr());

          // optional: clear sticky error state
          ref.read(chatActionsViewModelProvider.notifier).reset();
        },
      );
    });
  }

  @override
  void dispose() {
    _chatSub.close();
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;

    final vm = ref.read(chatActionsViewModelProvider.notifier);

    final ok = await vm.send(
      chatId: widget.chatId,
      text: text,
    );

    if (!mounted) return;

    if (ok) {
      _resetInput(); // ✅ clear immediately after success
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesStreamProvider(widget.chatId));
    final sending = ref.watch(chatActionsViewModelProvider).isLoading;

    final currentUserId = ref.watch(currentUserIdProvider);

    return AppScaffold(
      scrollable: false,
      title: 'chat'.tr(),
      body: Column(
        children: [
          Expanded(
            child: ChatMessagesList(
              messagesAsync: messagesAsync,
              controller: _scroll,
              currentUserId: currentUserId,
              onRetry: () =>
                  ref.refresh(chatMessagesStreamProvider(widget.chatId)),
              somethingWentWrongText: 'something_went_wrong'.tr(),

              // ✅ adapt to your message model
              textOf: (m) => m.text,
              senderIdOf: (m) => m.senderId,
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.spaceMD,
                right: AppSpacing.spaceMD,
                bottom: AppSpacing.spaceSM,
              ),
              child: ChatInputBar(
                controller: _ctrl,
                sending: sending,
                onSend: _sendMessage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
