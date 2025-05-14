// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_reactions/message_reactions.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/entity_data_with_media_content.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/views/hooks/use_parsed_media_content.dart';
import 'package:ion/app/router/app_routes.c.dart';

class SharedPostMessage extends HookConsumerWidget {
  const SharedPostMessage({
    required this.onTapReply,
    required this.postEntity,
    required this.sharedEventMessage,
    super.key,
  });

  final VoidCallback? onTapReply;
  final IonConnectEntity postEntity;
  final EventMessage sharedEventMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMe = ref.watch(isCurrentUserSelectorProvider(sharedEventMessage.masterPubkey));

    final postData = useMemoized(
      () => switch (postEntity) {
        final ModifiablePostEntity post => post.data,
        final PostEntity post => post.data,
        _ => false,
      },
    );

    final createdAt = useMemoized(
      () => switch (postEntity) {
        final ModifiablePostEntity post => post.data.publishedAt.value,
        final PostEntity post => post.createdAt,
        _ => DateTime.now(),
      },
    );

    final postDeleted = useMemoized(
      () => switch (postEntity) {
        final ModifiablePostEntity post => post.isDeleted,
        _ => false,
      },
    );

    if (postData is! EntityDataWithMediaContent || postDeleted) {
      return const SizedBox.shrink();
    }

    final (:content, :media) = useParsedMediaContent(
      data: postData,
      key: ValueKey(postData.hashCode),
    );

    final contentAsPlainText = useMemoized(() => Document.fromDelta(content).toPlainText().trim());

    final messageItem = PostItem(
      medias: media,
      eventMessage: sharedEventMessage,
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
          GestureDetector(
            onTap: () => PostDetailsRoute(eventReference: postEntity.toEventReference().encode())
                .push<void>(context),
            behavior: HitTestBehavior.opaque,
            child: Post(
              isShared: isMe,
              header: UserInfo(
                createdAt: createdAt,
                pubkey: postEntity.masterPubkey,
                textStyle: isMe
                    ? context.theme.appTextThemes.caption.copyWith(
                        color: context.theme.appColors.onPrimaryAccent,
                      )
                    : null,
              ),
              footer: const SizedBox.shrink(),
              eventReference: postEntity.toEventReference(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0.s, vertical: 0.0.s),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: MessageReactions(eventMessage: sharedEventMessage, isMe: isMe),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
