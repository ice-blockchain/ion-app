// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_item_wrapper/message_item_wrapper.dart';

class SystemMessage extends StatelessWidget {
  const SystemMessage({
    required this.message,
    super.key,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MessageItemWrapper.maxWidth,
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: context.theme.appTextThemes.caption2.copyWith(
          color: context.theme.appColors.tertararyText,
        ),
      ),
    );
  }
}
