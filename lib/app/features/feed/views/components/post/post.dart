// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/counter_items_footer.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/create_post/views/pages/create_post_modal/components/parent_entity.dart';
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
    this.topOffset,
    this.headerOffset,
    this.header,
    this.footer,
    this.onDelete,
    this.isTextSelectable = false,
    this.bodyMaxLines = 6,
    this.contentWrapper,
    super.key,
  });

  final EventReference eventReference;
  final FramedEventType framedEventType;
  final double? topOffset;
  final double? headerOffset;
  final Widget? header;
  final Widget? footer;
  final TimestampFormat timeFormat;
  final VoidCallback? onDelete;
  final bool isTextSelectable;
  final int? bodyMaxLines;
  final Widget Function(Widget content)? contentWrapper;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = ref.watch(ionConnectSyncEntityProvider(eventReference: eventReference));

    if (entity == null) {
      return ScreenSideOffset.small(child: const Skeleton(child: PostSkeleton()));
    }

    if (entity is ModifiablePostEntity && entity.isDeleted) {
      return ScreenSideOffset.small(child: DeletedEntity(entityType: DeletedEntityType.post));
    }

    final isOwnedByCurrentUser = ref.watch(isCurrentUserSelectorProvider(entity.masterPubkey));

    final framedEventReference =
        _getFramedEventReference(entity: entity, framedEventType: framedEventType);

    final content = Column(
      children: [
        SizedBox(height: headerOffset ?? 10.0.s),
        PostBody(
          entity: entity,
          isTextSelectable: isTextSelectable,
          maxLines: bodyMaxLines,
        ),
        ScreenSideOffset.small(
          child: Column(
            children: [
              if (framedEventType == FramedEventType.quoted)
                _QuotedEvent(eventReference: framedEventReference),
              footer ?? CounterItemsFooter(eventReference: eventReference),
            ],
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: topOffset ?? 12.0.s),
        if (framedEventType == FramedEventType.parent)
          _ParentEvent(eventReference: framedEventReference),
        ScreenSideOffset.small(
          child: header ??
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
        ),
        if (contentWrapper != null) contentWrapper!(content) else content,
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

class _QuotedEvent extends StatelessWidget {
  const _QuotedEvent({required this.eventReference});

  final EventReference? eventReference;

  @override
  Widget build(BuildContext context) {
    final eventReference = this.eventReference;
    if (eventReference == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.only(top: 12.0.s),
      child: _FramedEvent(
        eventReference: eventReference,
        framedEventType: FramedEventType.quoted,
        postWidget: _QuotedPost(eventReference: eventReference),
        articleWidget: _QuotedArticle(eventReference: eventReference),
      ),
    );
  }
}

final class _ParentEvent extends StatelessWidget {
  const _ParentEvent({required this.eventReference});

  final EventReference? eventReference;

  @override
  Widget build(BuildContext context) {
    final eventReference = this.eventReference;
    if (eventReference == null) {
      return const SizedBox.shrink();
    }
    return _FramedEvent(
      eventReference: eventReference,
      framedEventType: FramedEventType.parent,
      postWidget: _ParentPost(eventReference: eventReference),
      articleWidget: _ParentArticle(eventReference: eventReference),
    );
  }
}

final class _FramedEvent extends HookConsumerWidget {
  const _FramedEvent({
    required this.eventReference,
    required this.postWidget,
    required this.articleWidget,
    required this.framedEventType,
  });

  final EventReference eventReference;
  final Widget postWidget;
  final Widget articleWidget;
  final FramedEventType framedEventType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = ref.watch(ionConnectSyncEntityProvider(eventReference: eventReference));
    final isParent = framedEventType == FramedEventType.parent;
    Widget? deletedEntity;

    if (entity is ModifiablePostEntity && entity.isDeleted) {
      deletedEntity = Padding(
        padding: EdgeInsets.symmetric(horizontal: isParent ? 16.0.s : 0),
        child: DeletedEntity(
          entityType: DeletedEntityType.post,
          bottomPadding: isParent ? 4.0.s : 0,
          topPadding: 0,
        ),
      );
    }

    if (entity is ArticleEntity && entity.isDeleted) {
      deletedEntity = Padding(
        padding: EdgeInsets.symmetric(horizontal: isParent ? 16.0.s : 0),
        child: DeletedEntity(
          entityType: DeletedEntityType.article,
          bottomPadding: isParent ? 4.0.s : 0,
          topPadding: 0,
        ),
      );
    }

    if (deletedEntity != null && isParent) {
      deletedEntity = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          deletedEntity,
          ParentDottedLine(
            padding: EdgeInsetsDirectional.only(start: 32.0.s),
            child: SizedBox(height: 14.0.s),
          ),
          SizedBox(height: 4.0.s),
        ],
      );
    }

    final repliedEntity = useMemoized(
      () {
        switch (entity) {
          case ModifiablePostEntity() || PostEntity():
            return postWidget;
          case ArticleEntity():
            return articleWidget;
          default:
            return const SizedBox.shrink();
        }
      },
      [entity],
    );

    return deletedEntity ?? repliedEntity;
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

final class _ParentPost extends StatelessWidget {
  const _ParentPost({required this.eventReference});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        PostDetailsRoute(eventReference: eventReference.encode()).push<void>(context);
      },
      child: Post(
        eventReference: eventReference,
        framedEventType: FramedEventType.none,
        headerOffset: 0,
        topOffset: 0,
        contentWrapper: (content) {
          return ParentDottedLine(
            padding: EdgeInsetsDirectional.only(
              start: 31.0.s,
              top: 8.0.s,
              end: 8.0.s,
              bottom: 4.0.s,
            ),
            child: content,
          );
        },
      ),
    );
  }
}

final class _ParentArticle extends StatelessWidget {
  const _ParentArticle({required this.eventReference});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ArticleDetailsRoute(eventReference: eventReference.encode()).push<void>(context);
      },
      child: AbsorbPointer(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.s),
          child: Article.replied(eventReference: eventReference),
        ),
      ),
    );
  }
}
