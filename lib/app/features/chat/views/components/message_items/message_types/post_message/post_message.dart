// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/shared_post_message_provider.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_types/post_message/shared_post_message.dart'
    as shared_post_ui;
import 'package:ion/app/features/chat/views/components/message_items/message_types/post_message/shared_story_message.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';

class PostMessage extends HookConsumerWidget {
  const PostMessage({
    required this.eventMessage,
    this.onTapReply,
    super.key,
  });

  final EventMessage eventMessage;
  final VoidCallback? onTapReply;

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
        ? SharedStoryMessage(
            storyEntity: postEntity,
            replyEventMessage: eventMessage,
          )
        : shared_post_ui.SharedPostMessage(
            onTapReply: onTapReply,
            postEntity: postEntity,
            sharedEventMessage: eventMessage,
          );
  }
}
