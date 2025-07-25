// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class SendButton extends StatelessWidget {
  const SendButton({
    required this.onSend,
    this.disabled = false,
    super.key,
  });

  final bool disabled;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onSend,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.0.s, vertical: 4.0.s),
        margin: EdgeInsetsDirectional.symmetric(horizontal: 6.0.s),
        decoration: BoxDecoration(
          color:
              disabled ? context.theme.appColors.sheetLine : context.theme.appColors.primaryAccent,
          borderRadius: BorderRadius.circular(12.0.s),
        ),
        child: Assets.svg.iconChatSendmessage.icon(
          color: context.theme.appColors.onPrimaryAccent,
          size: 24.0.s,
        ),
      ),
    );
  }
}
