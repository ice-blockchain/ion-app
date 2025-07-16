// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/chat/model/message_list_item.f.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_item_wrapper/message_item_wrapper.dart';
import 'package:ion/app/features/chat/views/components/message_items/message_reactions/message_reactions.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.f.dart';
import 'package:ion/app/features/feed/views/components/article/article.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/entity_data_with_media_content.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/views/hooks/use_parsed_media_content.dart';
import 'package:ion/app/router/app_routes.gr.dart';

class SharedPostMessage extends HookConsumerWidget {
  const SharedPostMessage({
    required this.onTapReply,
    required this.postEntity,
    required this.sharedEventMessage,
    this.margin,
    super.key,
  });

  final VoidCallback? onTapReply;
  final IonConnectEntity postEntity;
  final EventMessage sharedEventMessage;
  final EdgeInsetsDirectional? margin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final isMe = ref.watch(isCurrentUserSelectorProvider(sharedEventMessage.masterPubkey));

    final postData = useMemoized(
      () => switch (postEntity) {
        final PostEntity post => post.data,
        final ArticleEntity article => article.data,
        final ModifiablePostEntity post => post.data,
        _ => false,
      },
    );

    final createdAt = useMemoized(
      () => switch (postEntity) {
        final PostEntity post => post.createdAt,
        final ArticleEntity article => article.data.publishedAt.value,
        final ModifiablePostEntity post => post.data.publishedAt.value,
        _ => DateTime.now().microsecondsSinceEpoch,
      },
    );

    final isDeleted = useMemoized(
      () => switch (postEntity) {
        final ArticleEntity article => article.isDeleted,
        final ModifiablePostEntity post => post.isDeleted,
        _ => false,
      },
    );

    if (postData is! EntityDataWithMediaContent || isDeleted) {
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

    final userInfo = UserInfo(
      accentTheme: isMe,
      createdAt: createdAt,
      pubkey: postEntity.masterPubkey,
      textStyle: isMe
          ? context.theme.appTextThemes.caption.copyWith(
              color: context.theme.appColors.onPrimaryAccent,
            )
          : null,
    );
    return MessageItemWrapper(
      isMe: isMe,
      margin: margin,
      messageItem: messageItem,
      contentPadding: EdgeInsets.symmetric(horizontal: 0.0.s, vertical: 8.0.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (postEntity is ArticleEntity)
            GestureDetector(
              onTap: () =>
                  ArticleDetailsRoute(eventReference: postEntity.toEventReference().encode())
                      .push<void>(context),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsetsDirectional.only(end: 12.0.s, top: 4.0.s, bottom: 4.0.s),
                child: Article(
                  header:
                      Padding(padding: EdgeInsetsDirectional.only(bottom: 10.0.s), child: userInfo),
                  accentTheme: isMe,
                  footer: const SizedBox.shrink(),
                  eventReference: postEntity.toEventReference(),
                ),
              ),
            )
          else
            GestureDetector(
              onTap: () => PostDetailsRoute(eventReference: postEntity.toEventReference().encode())
                  .push<void>(context),
              behavior: HitTestBehavior.opaque,
              child: Post(
                header: userInfo,
                accentTheme: isMe,
                footer: const SizedBox.shrink(),
                eventReference: postEntity.toEventReference(),
                quotedEventFooter: const SizedBox.shrink(),
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
