// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class ChatAttachmentMenuSwitchButton extends HookConsumerWidget {
  const ChatAttachmentMenuSwitchButton({
    required this.onTap,
    required this.isAttachMenuShown,
    super.key,
  });

  final VoidCallback onTap;
  final bool isAttachMenuShown;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(4.0.s),
        child: (isAttachMenuShown ? Assets.svg.iconChatKeyboard : Assets.svg.iconChatAttatch).icon(
          color: context.theme.appColors.primaryText,
          size: 24.0.s,
        ),
      ),
    );
  }
}
