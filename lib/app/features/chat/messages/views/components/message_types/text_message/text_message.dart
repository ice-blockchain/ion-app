// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/messages/views/components/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/messages/views/components/message_metadata/message_metadata.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';

class TextMessage extends HookConsumerWidget {
  const TextMessage({
    required this.eventMessage,
    this.isLastMessageFromAuthor = true,
    super.key,
  });

  final bool isLastMessageFromAuthor;
  // final RepliedMessage? repliedMessage;
  final EventMessage eventMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserPubkey =
        ref.watch(currentUserIonConnectEventSignerProvider).valueOrNull?.publicKey;

    final entity = useMemoized(() => PrivateDirectMessageEntity.fromEventMessage(eventMessage));

    final isMe = eventMessage.pubkey == currentUserPubkey;

    return MessageItemWrapper(
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
            // MessageAuthorNameWidget(author: author),
            // if (repliedMessage case final RepliedMessage replied)
            //   RepliedMessageInfo(
            //     isMe: isMe,
            //     sender: replied.author,
            //     message: replied.message,
            //   ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entity.data.content.map((e) => e.text).join(),
                        style: context.theme.appTextThemes.body2.copyWith(
                          color: isMe
                              ? context.theme.appColors.onPrimaryAccent
                              : context.theme.appColors.primaryText,
                        ),
                      ),
                      // if (reactions.isNotEmpty) MessageReactions(reactions: reactions),
                    ],
                  ),
                ),
                MessageMetaData(
                  isMe: isMe,
                  createdAt: eventMessage.createdAt,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
