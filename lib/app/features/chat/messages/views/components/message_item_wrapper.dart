// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';

class MessageItemWrapper extends StatelessWidget {
  const MessageItemWrapper({
    required this.isMe,
    required this.child,
    required this.contentPadding,
    super.key,
  });
  final bool isMe;
  final Widget child;
  final EdgeInsetsGeometry contentPadding;

  static double get maxWidth => 282.0.s;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ScreenSideOffset.small(
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
    );
  }
}
