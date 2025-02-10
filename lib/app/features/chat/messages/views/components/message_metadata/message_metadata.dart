// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/message_delivery_status.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/generated/assets.gen.dart';

class MessageMetaData extends StatelessWidget {
  const MessageMetaData({
    required this.isMe,
    required this.createdAt,
    required this.deliveryStatus,
    super.key,
  });

  final bool isMe;
  final DateTime createdAt;
  final MessageDeliveryStatus deliveryStatus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0.s),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            toTimeDisplayValue(createdAt.millisecondsSinceEpoch),
            style: context.theme.appTextThemes.caption4.copyWith(
              color: isMe
                  ? context.theme.appColors.strokeElements
                  : context.theme.appColors.quaternaryText,
            ),
          ),
          if (isMe)
            Padding(
              padding: EdgeInsets.only(left: 2.0.s),
              child: statusIcon(context),
            ),
        ],
      ),
    );
  }

  Widget statusIcon(BuildContext context) {
    return switch (deliveryStatus) {
      MessageDeliveryStatus.deleted => const SizedBox.shrink(),
      MessageDeliveryStatus.created => const SizedBox.shrink(),
      MessageDeliveryStatus.sent => Assets.svg.iconMessageSent.icon(
          color: context.theme.appColors.strokeElements,
          size: 12.0.s,
        ),
      MessageDeliveryStatus.received => Assets.svg.iconMessageDelivered.icon(
          color: context.theme.appColors.strokeElements,
          size: 12.0.s,
        ),
      MessageDeliveryStatus.read => Assets.svg.iconMessageRead.icon(
          color: context.theme.appColors.strokeElements,
          size: 12.0.s,
        ),
      MessageDeliveryStatus.failed => Assets.svg.iconMessageFailed.icon(
          color: context.theme.appColors.strokeElements,
          size: 12.0.s,
        ),
    };
  }
}
