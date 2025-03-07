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
import 'package:ion/generated/assets.gen.dart';

class MessageItemWrapper extends HookConsumerWidget {
  const MessageItemWrapper({
    required this.isMe,
    required this.child,
    required this.messageEvent,
    required this.contentPadding,
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

    final deliveryStatus =
        ref.watch(conversationMessageDataDaoProvider).messageStatus(messageEvent!.id);

    final showReactDialog = useCallback(
      () async {
        try {
          if (messageEvent == null) {
            return;
          }

          var messageStatus = MessageDeliveryStatus.created;

          final subscription = deliveryStatus.listen((status) {
            messageStatus = status;
          });

          final emoji = await showDialog<String>(
            context: context,
            barrierColor: Colors.transparent,
            useSafeArea: false,
            builder: (context) => MessageReactionDialog(
              isMe: isMe,
              messageEvent: messageEvent!,
              messageStatus: messageStatus,
              renderObject: messageItemKey.currentContext!.findRenderObject()!,
            ),
          );

          if (emoji != null) {
            onReactionSelected?.call(emoji);
          }

          await subscription.cancel();
        } catch (e, st) {
          Logger.log('Error showing message reaction dialog:', error: e, stackTrace: st);
        }
      },
      [messageItemKey, isMe],
    );

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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
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
                        bottomLeft: !isLastMessageFromAuthor || isMe
                            ? Radius.circular(12.0.s)
                            : Radius.zero,
                        bottomRight:
                            isMe && isLastMessageFromAuthor ? Radius.zero : Radius.circular(12.0.s),
                      ),
                    ),
                    child: child,
                  ),
                  if (snapshot.hasData && snapshot.data == MessageDeliveryStatus.failed)
                    Row(
                      children: [
                        SizedBox(width: 6.0.s),
                        Assets.svg.iconMessageFailed.icon(
                          color: context.theme.appColors.attentionRed,
                          size: 16.0.s,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
