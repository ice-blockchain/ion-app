// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class ChatPrivacyTooltip extends StatelessWidget {
  const ChatPrivacyTooltip({
    required this.canSendMessage,
    required this.child,
    super.key,
  });

  final Widget child;
  final bool canSendMessage;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      triggerMode: canSendMessage ? TooltipTriggerMode.manual : TooltipTriggerMode.tap,
      textStyle: context.theme.appTextThemes.body2.copyWith(
        color: context.theme.appColors.secondaryText,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0.s, vertical: 11.0.s),
      decoration: BoxDecoration(
        color: context.theme.appColors.onPrimaryAccent,
        borderRadius: BorderRadius.circular(16.0.s),
        boxShadow: [
          BoxShadow(
            color: context.theme.appColors.primaryText.withValues(alpha: 0.08),
            blurRadius: 16.0.s,
          ),
        ],
      ),
      constraints: BoxConstraints(
        maxWidth: 300.0.s,
        maxHeight: 76.0.s,
      ),
      message: context.i18n.chat_privacy_cant_send_message,
      child: Opacity(opacity: canSendMessage ? 1.0 : 0.3, child: child),
    );
  }
}
