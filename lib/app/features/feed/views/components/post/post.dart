// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/counter_items_footer.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/views/components/article/article.dart';
import 'package:ion/app/features/feed/views/components/deleted_entity/deleted_entity.dart';
import 'package:ion/app/features/feed/views/components/overlay_menu/own_entity_menu.dart';
import 'package:ion/app/features/feed/views/components/overlay_menu/user_info_menu.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/post_body.dart';
import 'package:ion/app/features/feed/views/components/post/post_skeleton.dart';
import 'package:ion/app/features/feed/views/components/quoted_entity_frame/quoted_entity_frame.dart';
import 'package:ion/app/features/feed/views/components/time_ago/time_ago.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

enum FramedEventType { parent, quoted, none }

class Post extends ConsumerWidget {
  const Post({
    required this.eventReference,
    this.framedEventType = FramedEventType.quoted,
    this.timeFormat = TimestampFormat.short,
    this.header,
    this.footer,
    this.onDelete,
    this.isTextSelectable = false,
    this.bodyMaxLines = 6,
    super.key,
  });

  final EventReference eventReference;
  final FramedEventType framedEventType;
  final Widget? header;
  final Widget? footer;
  final TimestampFormat timeFormat;
  final VoidCallback? onDelete;
  final bool isTextSelectable;
  final int? bodyMaxLines;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = ref.watch(ionConnectSyncEntityProvider(eventReference: eventReference));

    if (entity == null) {
      return const Skeleton(child: PostSkeleton());
    }

    if (entity is ModifiablePostEntity && entity.isDeleted) {
      return DeletedEntity(entityType: DeletedEntityType.post);
    }

    final isOwnedByCurrentUser = ref.watch(isCurrentUserSelectorProvider(entity.masterPubkey));

    final framedEventReference =
        _getFramedEventReference(entity: entity, framedEventType: framedEventType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.0.s),
        ScreenSideOffset.small(
          child: Column(
            children: [
              header ??
                  UserInfo(
                    pubkey: eventReference.pubkey,
                    createdAt: entity is ModifiablePostEntity
                        ? entity.data.publishedAt.value
                        : entity.createdAt,
                    timeFormat: timeFormat,
                    trailing: isOwnedByCurrentUser
                        ? OwnEntityMenu(eventReference: eventReference, onDelete: onDelete)
                        : UserInfoMenu(pubkey: eventReference.pubkey),
                  ),
            ],
          ),
        ),
        SizedBox(height: 10.0.s),
        PostBody(
          entity: entity,
          isTextSelectable: isTextSelectable,
          maxLines: bodyMaxLines,
        ),
        ScreenSideOffset.small(
          child: Column(
            children: [
              if (framedEventReference != null) _FramedEvent(eventReference: framedEventReference),
              footer ??
                  CounterItemsFooter(
                    eventReference: eventReference,
                  ),
            ],
          ),
        ),
      ],
    );
  }

  EventReference? _getFramedEventReference({
    required IonConnectEntity entity,
    required FramedEventType framedEventType,
  }) {
    return switch (framedEventType) {
      FramedEventType.parent when entity is ModifiablePostEntity =>
        entity.data.parentEvent?.eventReference,
      FramedEventType.parent when entity is PostEntity => entity.data.parentEvent?.eventReference,
      FramedEventType.quoted when entity is ModifiablePostEntity =>
        entity.data.quotedEvent?.eventReference,
      FramedEventType.quoted when entity is PostEntity => entity.data.quotedEvent?.eventReference,
      _ => null,
    };
  }
}

class _FramedEvent extends HookConsumerWidget {
  const _FramedEvent({required this.eventReference});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = ref.watch(ionConnectSyncEntityProvider(eventReference: eventReference));

    if (entity is ModifiablePostEntity && entity.isDeleted) {
      return DeletedEntity(entityType: DeletedEntityType.post, bottomPadding: 0);
    }

    if (entity is ArticleEntity && entity.isDeleted) {
      return DeletedEntity(entityType: DeletedEntityType.article, bottomPadding: 0);
    }

    final quotedEntity = useMemoized(
      () {
        switch (entity) {
          case ModifiablePostEntity() || PostEntity():
            return _QuotedPost(eventReference: eventReference);
          case ArticleEntity():
            return _QuotedArticle(eventReference: eventReference);
          default:
            return const SizedBox.shrink();
        }
      },
      [entity],
    );

    return Padding(
      padding: EdgeInsets.only(top: 10.0.s),
      child: quotedEntity,
    );
  }
}

final class _QuotedPost extends ConsumerWidget {
  const _QuotedPost({required this.eventReference});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postEntity = ref.watch(ionConnectSyncEntityProvider(eventReference: eventReference));

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
              createdAt: postEntity is ModifiablePostEntity
                  ? postEntity.data.publishedAt.value
                  : postEntity?.createdAt,
            ),
            footer: const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

final class _QuotedArticle extends StatelessWidget {
  const _QuotedArticle({required this.eventReference});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
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
