// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/generated/assets.gen.dart';

class MessageMetaData extends ConsumerWidget {
  const MessageMetaData({
    required this.eventMessage,
    super.key,
    this.startPadding = 8.0,
  });

  final EventMessage eventMessage;
  final double startPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveryStatus = ref.watch(conversationMessageDataDaoProvider).messageStatus(
          sharedId: eventMessage.sharedId!,
          masterPubkey: eventMessage.masterPubkey,
        );

    final isMe = ref.watch(isCurrentUserSelectorProvider(eventMessage.masterPubkey));

    return Padding(
      padding: EdgeInsetsDirectional.only(start: startPadding.s),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            toTimeDisplayValue(eventMessage.createdAt.millisecondsSinceEpoch),
            style: context.theme.appTextThemes.caption4.copyWith(
              color: isMe
                  ? context.theme.appColors.strokeElements
                  : context.theme.appColors.quaternaryText,
            ),
          ),
          if (isMe)
            StreamBuilder<MessageDeliveryStatus>(
              stream: deliveryStatus,
              builder: (context, snapshot) => Padding(
                padding: EdgeInsetsDirectional.only(start: 2.0.s),
                child: statusIcon(context, snapshot.data ?? MessageDeliveryStatus.created),
              ),
            ),
        ],
      ),
    );
  }

  Widget statusIcon(BuildContext context, MessageDeliveryStatus deliveryStatus) {
    return switch (deliveryStatus) {
      MessageDeliveryStatus.deleted => const SizedBox.shrink(),
      MessageDeliveryStatus.created => const SizedBox.shrink(),
      MessageDeliveryStatus.failed => const SizedBox.shrink(),
      MessageDeliveryStatus.sent => Assets.svg.iconMessageSent.icon(
          color: context.theme.appColors.strokeElements,
          size: 12.0.s,
        ),
      MessageDeliveryStatus.received => Assets.svg.iconMessageDelivered.icon(
          color: context.theme.appColors.strokeElements,
          size: 12.0.s,
        ),
      MessageDeliveryStatus.read => Assets.svg.iconMessageDelivered.icon(
          color: context.theme.appColors.success,
          size: 12.0.s,
        ),
    };
  }
}
