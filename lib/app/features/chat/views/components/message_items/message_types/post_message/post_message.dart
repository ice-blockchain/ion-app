// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_reactions/message_reactions.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/providers/ion_connect_entity_with_counters_provider.c.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/entity_data_with_media_content.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/views/hooks/use_parsed_media_content.dart';

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
    final isMe = ref.watch(isCurrentUserSelectorProvider(eventMessage.masterPubkey));

    final reference = EventReference.fromEncoded(eventMessage.content);
    final entity = ref.watch(ionConnectEntityWithCountersProvider(eventReference: reference));

    final postData = switch (entity) {
      final ModifiablePostEntity post => post.data,
      final PostEntity post => post.data,
      _ => null,
    };

    if (postData is! EntityDataWithMediaContent) {
      return const SizedBox.shrink();
    }

    final (:content, :media) = useParsedMediaContent(
      data: postData,
      key: ValueKey(postData.hashCode),
    );

    final contentAsPlainText = Document.fromDelta(content).toPlainText().trim();

    final messageItem = PostItem(
      medias: media,
      eventMessage: eventMessage,
      contentDescription:
          contentAsPlainText.isEmpty ? context.i18n.post_page_title : contentAsPlainText,
    );

    return MessageItemWrapper(
      isMe: isMe,
      messageItem: messageItem,
      contentPadding: EdgeInsets.symmetric(horizontal: 0.0.s, vertical: 8.0.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Post(
            eventReference: EventReference.fromEncoded(eventMessage.content),
            isShared: true,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0.s, vertical: 0.0.s),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: MessageReactions(eventMessage: eventMessage, isMe: isMe),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
