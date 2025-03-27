// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_metadata/message_metadata.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_reactions/message_reactions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';

class EmojiMessage extends HookConsumerWidget {
  const EmojiMessage({
    required this.eventMessage,
    super.key,
  });

  final EventMessage eventMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = useMemoized(() => PrivateDirectMessageEntity.fromEventMessage(eventMessage));

    final isMe = ref.watch(isCurrentUserSelectorProvider(eventMessage.masterPubkey));

    return MessageItemWrapper(
      isMe: isMe,
      messageItem: EmojiItem(
        eventMessage: eventMessage,
        contentDescription: entity.data.content,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.0.s, vertical: 6.0.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  entity.data.content,
                  style: context.theme.appTextThemes.headline1.copyWith(height: 1),
                ),
              ),
              MessageMetaData(eventMessage: eventMessage),
            ],
          ),
          MessageReactions(eventMessage: eventMessage, isMe: isMe),
        ],
      ),
    );
  }
}
