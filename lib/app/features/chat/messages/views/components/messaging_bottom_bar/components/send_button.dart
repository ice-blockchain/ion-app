// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class SendButton extends StatelessWidget {
  const SendButton({
    required this.onSend,
    super.key,
  });

  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSend,
      child: Container(
        padding: EdgeInsets.all(4.0.s),
        decoration: BoxDecoration(
          color: context.theme.appColors.primaryAccent,
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
