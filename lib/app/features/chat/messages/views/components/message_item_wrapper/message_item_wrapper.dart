// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/message_reaction_dialog/message_reaction_dialog.dart';
import 'package:ion/app/services/logger/logger.dart';

class MessageItemWrapper extends HookWidget {
  const MessageItemWrapper({
    required this.isMe,
    required this.child,
    required this.contentPadding,
    super.key,
  });
  final bool isMe;
  final Widget child;
  final EdgeInsetsGeometry contentPadding;

  /// The maximum width of the message content in the chat
  static double get maxWidth => 282.0.s;

  @override
  Widget build(BuildContext context) {
    final messagItemKey = useMemoized(GlobalKey.new);

    final showReactDialog = useCallback(
      () {
        try {
          showDialog<void>(
            context: context,
            barrierColor: Colors.transparent,
            useSafeArea: false,
            builder: (context) => MessageReactionDialog(
              isMe: isMe,
              renderObject: messagItemKey.currentContext!.findRenderObject()!,
            ),
          );
        } catch (e, st) {
          Logger.log('Error showing message reaction dialog:', error: e, stackTrace: st);
        }
      },
      [messagItemKey, isMe],
    );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () {
          HapticFeedback.mediumImpact();
          showReactDialog();
        },
        child: ScreenSideOffset.small(
          child: RepaintBoundary(
            key: messagItemKey,
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
                  topLeft: Radius.circular(20.0.s),
                  topRight: Radius.circular(20.0.s),
                  bottomLeft: isMe ? Radius.circular(20.0.s) : Radius.zero,
                  bottomRight: isMe ? Radius.zero : Radius.circular(20.0.s),
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
