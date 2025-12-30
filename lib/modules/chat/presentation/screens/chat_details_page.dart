import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/widgets/animation/chat/chat_input_bar.dart';
import 'package:notes_tasks/core/shared/widgets/animation/chat/chat_message_bubble.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_scaffold.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';
import 'package:notes_tasks/core/shared/widgets/common/error_view.dart';
import 'package:notes_tasks/core/shared/widgets/common/empty_view.dart';
import 'package:notes_tasks/core/data/remote/firebase/providers/firebase_providers.dart';

import 'package:notes_tasks/modules/chat/presentation/providers/chat_providers.dart';
import 'package:notes_tasks/modules/chat/domain/failures/chat_failure.dart';
import 'package:notes_tasks/modules/chat/presentation/viewmodels/chat_actions_viewmodel.dart';

class ChatDetailsScreen extends ConsumerStatefulWidget {
  final String chatId;
  const ChatDetailsScreen({super.key, required this.chatId});

  @override
  ConsumerState<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends ConsumerState<ChatDetailsScreen> {
  final _ctrl = TextEditingController();
  late final ProviderSubscription _chatSub;

  // ✅ optional: scroll controller لتحسين UX
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();

    _chatSub = ref.listenManual(chatActionsViewModelProvider, (prev, next) {
      final wasLoading = prev?.isLoading ?? false;
      final nowSuccess = next.hasValue && !next.isLoading && !next.hasError;

      if (wasLoading && nowSuccess) {
        if (!mounted) return;
        _ctrl.clear();

        // ✅ بعد إرسال رسالة: انزل لآخر الشات (reverse=true => offset 0)
        _safeJumpToBottom();
      }

      next.whenOrNull(
        error: (e, _) {
          if (!mounted) return;
          final key =
              (e is ChatFailure) ? e.messageKey : 'something_went_wrong';
          AppSnackbar.show(context, key.tr());
        },
      );
    });
  }

  void _safeJumpToBottom() {
    if (!_scroll.hasClients) return;
    // reverse:true => أحدث الرسائل تحت، والـ offset 0 هو أسفل
    _scroll.animateTo(
      0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
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

    if (ref.read(chatActionsViewModelProvider).isLoading) return;

    await ref.read(chatActionsViewModelProvider.notifier).send(
          chatId: widget.chatId,
          text: text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesStreamProvider(widget.chatId));
    final sending = ref.watch(chatActionsViewModelProvider).isLoading;

    final currentUserId = ref.read(firebaseAuthProvider).currentUser?.uid;

    return AppScaffold(
      scrollable: false,
      title: 'chat'.tr(),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => ErrorView(
                message: 'something_went_wrong'.tr(),
                fullScreen: false,
                onRetry: () =>
                    ref.refresh(chatMessagesStreamProvider(widget.chatId)),
              ),
              data: (messages) {
                if (messages.isEmpty) {
                  return const EmptyView(
                    message: null,
                    icon: Icons.chat_bubble_outline,
                  );
                }

                // ✅ UX: أحدث الرسائل تحت
                final list = messages.reversed.toList();

                // ✅ بعد ما تجي رسائل جديدة: انزل للأسفل مرة واحدة (خفيف)
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _safeJumpToBottom();
                });

                return ListView.builder(
                  controller: _scroll,
                  reverse: true, // ✅ أهم سطر
                  padding: EdgeInsets.all(AppSpacing.spaceMD),
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final m = list[i];

                    final isMe = (currentUserId != null &&
                        (m.senderId == currentUserId));

                    return Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.spaceSM),
                      child: ChatMessageBubble(
                        text: m.text,
                        isMe: isMe,
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // ✅ مهم عشان الكيبورد
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
