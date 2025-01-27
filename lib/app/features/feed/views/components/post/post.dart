// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/counter_items_footer.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/views/components/article/article.dart';
import 'package:ion/app/features/feed/views/components/delete_feed_item_menu/delete_feed_item_menu.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/post_body.dart';
import 'package:ion/app/features/feed/views/components/post/post_skeleton.dart';
import 'package:ion/app/features/feed/views/components/quoted_entity_frame/quoted_entity_frame.dart';
import 'package:ion/app/features/feed/views/components/timestamp_widget.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/features/feed/views/components/user_info_menu/user_info_menu.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

enum FramedEventType { parent, quoted, none }

class Post extends ConsumerWidget {
  const Post({
    required this.eventReference,
    super.key,
    this.framedEventType = FramedEventType.quoted,
    this.repostReference,
    this.header,
    this.footer,
    this.timeFormat = TimestampFormat.short,
    this.onDelete,
    super.key,
  });

  final EventReference eventReference;
  final FramedEventType framedEventType;
  final EventReference? repostReference;
  final Widget? header;
  final Widget? footer;
  final TimestampFormat timeFormat;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postEntity = ref
        .watch(ionConnectEntityProvider(eventReference: eventReference))
        .valueOrNull as ModifiablePostEntity?;

    if (postEntity == null) {
      return const Skeleton(child: PostSkeleton());
    }

    final isOwnedByCurrentUser = ref.watch(isCurrentUserSelectorProvider(postEntity.masterPubkey));

    final framedEventReference =
        _getFramedEventReference(postEntity: postEntity, framedEventType: framedEventType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.0.s),
        header ??
            UserInfo(
              pubkey: eventReference.pubkey,
              createdAt: postEntity.createdAt,
              timeFormat: timeFormat,
              trailing: isOwnedByCurrentUser
                  ? DeleteFeedItemMenu(
                      eventReference: eventReference,
                      onDelete: onDelete,
                    )
                  : UserInfoMenu(pubkey: eventReference.pubkey),
            ),
        SizedBox(height: 10.0.s),
        PostBody(postEntity: postEntity),
        if (framedEventReference != null) _FramedEvent(eventReference: framedEventReference),
        footer ??
            CounterItemsFooter(eventReference: eventReference, repostReference: repostReference),
      ],
    );
  }

  EventReference? _getFramedEventReference({
    required ModifiablePostEntity postEntity,
    required FramedEventType framedEventType,
  }) {
    return switch (framedEventType) {
      FramedEventType.parent when postEntity.data.parentEvent != null =>
        postEntity.data.parentEvent!.eventReference,
      FramedEventType.quoted when postEntity.data.quotedEvent != null =>
        postEntity.data.quotedEvent!.eventReference,
      _ => null,
    };
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
          case ModifiablePostEntity():
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
    final postEntity = ref
        .watch(ionConnectEntityProvider(eventReference: eventReference))
        .valueOrNull as PostEntity?;

    return QuotedEntityFrame.post(
      child: GestureDetector(
        onTap: () {
          PostDetailsRoute(eventReference: eventReference.encode()).push<void>(context);
        },
        child: AbsorbPointer(
          child: Post(
            eventReference: eventReference,
            framedEventType: FramedEventType.none,
            header: UserInfo(
              pubkey: eventReference.pubkey,
              createdAt: postEntity?.createdAt,
            ),
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
          ArticleDetailsRoute(eventReference: eventReference.encode()).push<void>(context);
        },
        child: AbsorbPointer(child: Article.quoted(eventReference: eventReference)),
      ),
    );
  }
}
