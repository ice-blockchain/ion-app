// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_e2ee_message_provider.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_metadata/message_metadata.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_reactions/message_reactions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';

class TextMessage extends HookConsumerWidget {
  const TextMessage({
    required this.eventMessage,
    this.isLastMessageFromAuthor = true,
    super.key,
  });

  final bool isLastMessageFromAuthor;
  final EventMessage eventMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = useMemoized(() => PrivateDirectMessageEntity.fromEventMessage(eventMessage));

    final isMe = ref.watch(isCurrentUserSelectorProvider(eventMessage.masterPubkey));

    return MessageItemWrapper(
      messageEvent: eventMessage,
      onReactionSelected: (emoji) async {
        final e2eeMessageService = await ref.watch(sendE2eeMessageServiceProvider.future);
        await e2eeMessageService.sendReaction(
          content: emoji,
          kind14Rumor: eventMessage,
        );
      },
      isLastMessageFromAuthor: isLastMessageFromAuthor,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12.0.s,
        vertical: 12.0.s,
      ),
      isMe: isMe,
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entity.data.content,
                        style: context.theme.appTextThemes.body2.copyWith(
                          color: isMe
                              ? context.theme.appColors.onPrimaryAccent
                              : context.theme.appColors.primaryText,
                        ),
                      ),
                      MessageReactions(eventMessage: eventMessage, isMe: isMe),
                    ],
                  ),
                ),
                MessageMetaData(eventMessage: eventMessage),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
