// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/model/message_type.dart';
import 'package:ion/app/features/chat/providers/message_status_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/user_block/providers/block_list_notifier.c.dart';
import 'package:ion/app/utils/date.dart';
import 'package:ion/generated/assets.gen.dart';

class MessageMetaData extends HookConsumerWidget {
  const MessageMetaData({
    required this.eventMessage,
    this.displayTime = true,
    super.key,
    this.startPadding = 8.0,
  });

  final bool displayTime;
  final double startPadding;
  final EventMessage eventMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventReference =
        ReplaceablePrivateDirectMessageEntity.fromEventMessage(eventMessage).toEventReference();

    final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);

    if (currentUserMasterPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }
    final isMe = ref.watch(isCurrentUserSelectorProvider(eventMessage.masterPubkey));

    final deliveryStatus = ref.watch(messageStatusProvider(eventReference));
    final isBlockedBy = ref
            .watch(
              isBlockedByNotifierProvider(
                eventMessage.participantsMasterPubkeys.firstWhere(
                  (masterPubkey) => masterPubkey != currentUserMasterPubkey,
                ),
              ),
            )
            .valueOrNull ??
        true;

    final entityData = ReplaceablePrivateDirectMessageData.fromEventMessage(eventMessage);

    return Padding(
      padding: EdgeInsetsDirectional.only(start: startPadding.s),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if ((entityData.messageType == MessageType.text ||
                  entityData.messageType == MessageType.emoji) &&
              (eventMessage.createdAt.difference(entityData.publishedAt.value).inSeconds > 2))
            Text(
              context.i18n.common_message_edited,
              style: context.theme.appTextThemes.caption4.copyWith(
                color: isMe
                    ? context.theme.appColors.strokeElements
                    : context.theme.appColors.quaternaryText,
              ),
            ),
          SizedBox(width: 2.0.s),
          if (displayTime)
            Text(
              toTimeDisplayValue(entityData.publishedAt.value.millisecondsSinceEpoch),
              style: context.theme.appTextThemes.caption4.copyWith(
                color: isMe
                    ? context.theme.appColors.strokeElements
                    : context.theme.appColors.quaternaryText,
              ),
            ),
          if (isMe)
            Padding(
              padding: EdgeInsetsDirectional.only(start: 2.0.s),
              child: statusIcon(
                context: context,
                isBlockedBy: isBlockedBy,
                deliveryStatus: deliveryStatus.valueOrNull ?? MessageDeliveryStatus.created,
              ),
            ),
        ],
      ),
    );
  }

  Widget statusIcon({
    required bool isBlockedBy,
    required BuildContext context,
    required MessageDeliveryStatus deliveryStatus,
  }) {
    return switch (deliveryStatus) {
      MessageDeliveryStatus.deleted => const SizedBox.shrink(),
      MessageDeliveryStatus.created => const SizedBox.shrink(),
      MessageDeliveryStatus.failed => const SizedBox.shrink(),
      MessageDeliveryStatus.sent => Assets.svg.iconMessageSent.icon(
          color: context.theme.appColors.strokeElements,
          size: 12.0.s,
        ),
      MessageDeliveryStatus.received => isBlockedBy
          ? Assets.svg.iconMessageSent.icon(
              color: context.theme.appColors.strokeElements,
              size: 12.0.s,
            )
          : Assets.svg.iconMessageDelivered.icon(
              color: context.theme.appColors.strokeElements,
              size: 12.0.s,
            ),
      MessageDeliveryStatus.read => isBlockedBy
          ? Assets.svg.iconMessageSent.icon(
              color: context.theme.appColors.strokeElements,
              size: 12.0.s,
            )
          : Assets.svg.iconMessageDelivered.icon(
              color: context.theme.appColors.success,
              size: 12.0.s,
            )
    };
  }
}
