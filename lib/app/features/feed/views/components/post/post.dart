// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/counter_items_footer.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/views/components/article/article.dart';
import 'package:ion/app/features/feed/views/components/delete_feed_item_menu/delete_feed_item_menu.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/post_body.dart';
import 'package:ion/app/features/feed/views/components/post/post_skeleton.dart';
import 'package:ion/app/features/feed/views/components/quoted_entity_frame/quoted_entity_frame.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/features/feed/views/components/user_info_menu/user_info_menu.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

class Post extends ConsumerWidget {
  const Post({
    required this.eventReference,
    this.repostEventReference,
    this.header,
    this.footer,
    this.showParent = false,
    this.onDelete,
    super.key,
  });

  final EventReference eventReference;
  final EventReference? repostEventReference;
  final bool showParent;
  final Widget? header;
  final Widget? footer;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postEntity = ref
        .watch(ionConnectEntityProvider(eventReference: eventReference))
        .valueOrNull as PostEntity?;

    if (postEntity == null) {
      return const Skeleton(child: PostSkeleton());
    }

    final isOwnedByCurrentUser = ref.watch(isCurrentUserSelectorProvider(postEntity.masterPubkey));

    final framedEvent = _getFramedEventReference(postEntity);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.0.s),
        header ??
            UserInfo(
              pubkey: eventReference.pubkey,
              trailing: isOwnedByCurrentUser
                  ? DeleteFeedItemMenu(
                      entity: postEntity,
                      onDelete: onDelete,
                    )
                  : UserInfoMenu(pubkey: eventReference.pubkey),
            ),
        SizedBox(height: 10.0.s),
        PostBody(postEntity: postEntity),
        if (framedEvent != null) _FramedEvent(eventReference: framedEvent),
        footer ??
            CounterItemsFooter(
              eventReference: eventReference,
            ),
      ],
    );
  }

  EventReference? _getFramedEventReference(PostEntity postEntity) {
    if (showParent) {
      final parentEvent = postEntity.data.parentEvent;
      if (parentEvent != null) {
        return EventReference(eventId: parentEvent.eventId, pubkey: parentEvent.pubkey);
      }
    } else {
      final quotedEvent = postEntity.data.quotedEvent;
      if (quotedEvent != null) {
        return EventReference(eventId: quotedEvent.eventId, pubkey: quotedEvent.pubkey);
      }
    }
    return null;
  }
}

class _FramedEvent extends HookConsumerWidget {
  const _FramedEvent({required this.eventReference});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ionConnectEntity =
        ref.watch(ionConnectEntityProvider(eventReference: eventReference)).valueOrNull;

    final quotedEntity = useMemoized(
      () {
        switch (ionConnectEntity) {
          case PostEntity():
            return _QuotedPost(eventReference: eventReference);
          case ArticleEntity():
            return _QuotedArticle(eventReference: eventReference);
          default:
            return const SizedBox.shrink();
        }
      },
      [ionConnectEntity],
    );

    return Padding(
      padding: EdgeInsets.only(top: 6.0.s),
      child: quotedEntity,
    );
  }
}

final class _QuotedPost extends ConsumerWidget {
  const _QuotedPost({required this.eventReference});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return QuotedEntityFrame.post(
      child: GestureDetector(
        onTap: () {
          PostDetailsRoute(eventReference: eventReference.toString()).push<void>(context);
        },
        child: AbsorbPointer(
          child: Post(
            eventReference: eventReference,
            header: UserInfo(pubkey: eventReference.pubkey),
            footer: const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

final class _QuotedArticle extends ConsumerWidget {
  const _QuotedArticle({required this.eventReference});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return QuotedEntityFrame.article(
      child: GestureDetector(
        onTap: () {
          ArticleDetailsRoute(eventReference: eventReference.toString()).push<void>(context);
        },
        child: AbsorbPointer(child: Article.quoted(eventReference: eventReference)),
      ),
    );
  }
}
