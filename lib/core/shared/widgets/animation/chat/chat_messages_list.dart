import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/widgets/animation/chat/chat_message_bubble.dart';
import 'package:notes_tasks/core/shared/widgets/common/empty_view.dart';
import 'package:notes_tasks/core/shared/widgets/common/error_view.dart';

/// Generic reusable chat messages list widget.
/// - Handles: loading / error / empty / list
/// - Supports: reverse list (newest at bottom) + auto scroll to bottom
class ChatMessagesList<T> extends StatelessWidget {
  final AsyncValue<List<T>> messagesAsync;

  /// Extractors so widget is reusable with any message model
  final String Function(T message) textOf;
  final String Function(T message) senderIdOf;

  final String? currentUserId;

  final ScrollController controller;

  /// Called when user taps retry in ErrorView
  final VoidCallback onRetry;

  /// Translated strings passed from UI (to keep widget UI-only and reusable)
  final String somethingWentWrongText;

  /// Optional customization
  final Widget? emptyWidget;
  final bool autoScrollOnNewData;

  const ChatMessagesList({
    super.key,
    required this.messagesAsync,
    required this.textOf,
    required this.senderIdOf,
    required this.currentUserId,
    required this.controller,
    required this.onRetry,
    required this.somethingWentWrongText,
    this.emptyWidget,
    this.autoScrollOnNewData = true,
  });

  void _safeJumpToBottom() {
    if (!controller.hasClients) return;

    // reverse:true => newest at bottom, offset 0 is bottom
    controller.animateTo(
      0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return messagesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => ErrorView(
        message: somethingWentWrongText,
        fullScreen: false,
        onRetry: onRetry,
      ),
      data: (messages) {
        if (messages.isEmpty) {
          return emptyWidget ??
              const EmptyView(
                message: null,
                icon: Icons.chat_bubble_outline,
              );
        }

        final list = messages.reversed.toList();

        if (autoScrollOnNewData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _safeJumpToBottom();
          });
        }

        return ListView.builder(
          controller: controller,
          reverse: true,
          padding: EdgeInsets.all(AppSpacing.spaceMD),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final m = list[i];
            final isMe =
                currentUserId != null && senderIdOf(m) == currentUserId;

            return Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.spaceSM),
              child: ChatMessageBubble(
                text: textOf(m),
                isMe: isMe,
              ),
            );
          },
        );
      },
    );
  }
}
