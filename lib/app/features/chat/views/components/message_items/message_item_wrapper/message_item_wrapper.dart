// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_reaction_dialog/message_reaction_dialog.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/services/logger/logger.dart';

class MessageItemWrapper extends HookConsumerWidget {
  const MessageItemWrapper({
    required this.isMe,
    required this.child,
    required this.contentPadding,
    this.messageEvent,
    this.onReactionSelected,
    this.isLastMessageFromAuthor = true,
    super.key,
  });

  final bool isMe;
  final Widget child;
  final EventMessage? messageEvent;
  final bool isLastMessageFromAuthor;
  final EdgeInsetsGeometry contentPadding;
  final void Function(String reaction)? onReactionSelected;

  /// The maximum width of the message content in the chat
  static double get maxWidth => 282.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageItemKey = useMemoized(GlobalKey.new);

    final showReactDialog = useCallback(
      () async {
        try {
          if (messageEvent == null) {
            return;
          }

          final emoji = await showDialog<String>(
            context: context,
            barrierColor: Colors.transparent,
            useSafeArea: false,
            builder: (context) => MessageReactionDialog(
              isMe: isMe,
              messageEvent: messageEvent!,
              renderObject: messageItemKey.currentContext!.findRenderObject()!,
            ),
          );
          if (emoji != null) {
            onReactionSelected?.call(emoji);
          }
        } catch (e, st) {
          Logger.log('Error showing message reaction dialog:', error: e, stackTrace: st);
        }
      },
      [messageItemKey, isMe],
    );

    final deliveryStatus = messageEvent != null
        ? ref.watch(conversationMessageDataDaoProvider).messageStatus(messageEvent!.id)
        : Stream.value(MessageDeliveryStatus.created);

    return StreamBuilder<MessageDeliveryStatus>(
      stream: deliveryStatus,
      initialData: MessageDeliveryStatus.deleted,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == MessageDeliveryStatus.deleted) {
          return const SizedBox.shrink();
        }

        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: GestureDetector(
            onLongPress: () {
              HapticFeedback.mediumImpact();
              showReactDialog();
            },
            child: RepaintBoundary(
              key: messageItemKey,
              child: Container(
                padding: contentPadding,
                constraints: BoxConstraints(
                  maxWidth: maxWidth,
                ),
                decoration: BoxDecoration(
                  color: isMe
                      ? context.theme.appColors.primaryAccent
                      : context.theme.appColors.onPrimaryAccent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0.s),
                    topRight: Radius.circular(12.0.s),
                    bottomLeft:
                        !isLastMessageFromAuthor || isMe ? Radius.circular(12.0.s) : Radius.zero,
                    bottomRight:
                        isMe && isLastMessageFromAuthor ? Radius.zero : Radius.circular(12.0.s),
                  ),
                ),
                // Sender name shouldn't be shown for messages of the current user
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
