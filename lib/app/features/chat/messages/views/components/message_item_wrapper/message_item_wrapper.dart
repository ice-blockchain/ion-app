// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/message_reaction_dialog/message_reaction_dialog.dart';
import 'package:ion/app/services/logger/logger.dart';

class MessageItemWrapper extends HookWidget {
  const MessageItemWrapper({
    required this.isMe,
    required this.child,
    required this.contentPadding,
    this.isLastMessageFromAuthor = true,
    super.key,
  });

  final bool isMe;
  final Widget child;
  final bool isLastMessageFromAuthor;
  final EdgeInsetsGeometry contentPadding;

  /// The maximum width of the message content in the chat
  static double get maxWidth => 282.0.s;

  @override
  Widget build(BuildContext context) {
    final messageItemKey = useMemoized(GlobalKey.new);

    final showReactDialog = useCallback(
      () {
        try {
          showDialog<void>(
            context: context,
            barrierColor: Colors.transparent,
            useSafeArea: false,
            builder: (context) => MessageReactionDialog(
              isMe: isMe,
              renderObject: messageItemKey.currentContext!.findRenderObject()!,
            ),
          );
        } catch (e, st) {
          Logger.log('Error showing message reaction dialog:', error: e, stackTrace: st);
        }
      },
      [messageItemKey, isMe],
    );

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
  }
}
