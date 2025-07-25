// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.f.dart';
import 'package:ion/app/features/chat/e2ee/providers/shared_post_message_provider.r.dart';
import 'package:ion/app/features/chat/model/message_list_item.f.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/post_message/shared_post_message.dart'
    as shared_post_ui;
import 'package:ion/app/features/chat/views/components/message_items/message_types/post_message/shared_post_wrapper.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/post_message/shared_story_message.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.f.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';

class PostMessage extends HookConsumerWidget {
  const PostMessage({
    required this.eventMessage,
    this.margin,
    this.onTapReply,
    super.key,
  });

  final EventMessage eventMessage;
  final VoidCallback? onTapReply;
  final EdgeInsetsDirectional? margin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sharedEntity =
        useMemoized(() => ReplaceablePrivateDirectMessageEntity.fromEventMessage(eventMessage));

    final postEntity = sharedEntity.data.quotedEvent != null
        ? ref
            .watch(
              sharedPostMessageProvider(sharedEntity.data.quotedEvent!.eventReference),
            )
            .valueOrNull
        : null;

    if (postEntity == null) {
      return const SizedBox.shrink();
    }

    final isStory = switch (postEntity) {
      final ModifiablePostEntity post => post.data.expiration != null,
      final PostEntity post => post.data.expiration != null,
      _ => false,
    };

    return isStory
        ? SharedStoryWrapper(
            sharedEntity: sharedEntity,
            messageItem: ChatMessageInfoItem.post(
              eventMessage: eventMessage,
              contentDescription: '',
              medias: [],
            ),
            child: SharedStoryMessage(
              margin: margin,
              storyEntity: postEntity,
              replyEventMessage: eventMessage,
            ),
          )
        : shared_post_ui.SharedPostMessage(
            margin: margin,
            onTapReply: onTapReply,
            postEntity: postEntity,
            sharedEventMessage: eventMessage,
          );
  }
}
