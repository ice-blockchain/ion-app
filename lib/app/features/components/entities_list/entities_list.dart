// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/entities_list/components/article_list_item.dart';
import 'package:ion/app/features/components/entities_list/components/post_list_item.dart';
import 'package:ion/app/features/components/entities_list/components/repost_list_item.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/user/providers/block_list_notifier.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';

class EntitiesList extends HookWidget {
  const EntitiesList({
    required this.entities,
    this.framedEventType = FramedEventType.quoted,
    this.separatorHeight,
    super.key,
  });

  final List<IonConnectEntity> entities;
  final double? separatorHeight;
  final FramedEventType framedEventType;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: entities.length,
      itemBuilder: (BuildContext context, int index) {
        return _EntityListItem(
          eventReference: entities[index].toEventReference(),
          framedEventType: framedEventType,
          separatorHeight: separatorHeight,
        );
      },
    );
  }
}

class _EntityListItem extends ConsumerWidget {
  _EntityListItem({
    required this.eventReference,
    required this.framedEventType,
    double? separatorHeight,
  }) : separatorHeight = separatorHeight ?? 12.0.s;

  final EventReference eventReference;
  final double separatorHeight;
  final FramedEventType framedEventType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Subscribing to the entity here instead of passing it as param to get the updates
    // e.g. when the entity is deleted
    final entity = ref.watch(ionConnectSyncEntityProvider(eventReference: eventReference));

    if (entity == null ||
        isBlockedOrBlocking(ref, entity) ||
        isDeleted(ref, entity) ||
        !hasMetadata(ref, entity)) {
      return const SizedBox.shrink();
    }

    return _BottomSeparator(
      height: separatorHeight,
      child: switch (entity) {
        ModifiablePostEntity() || PostEntity() => PostListItem(
            eventReference: entity.toEventReference(),
            framedEventType: framedEventType,
          ),
        final ArticleEntity article => ArticleListItem(article: article),
        GenericRepostEntity() ||
        RepostEntity() =>
          RepostListItem(eventReference: entity.toEventReference()),
        _ => const SizedBox.shrink()
      },
    );
  }

  bool isDeleted(WidgetRef ref, IonConnectEntity entity) {
    return (entity is ModifiablePostEntity && entity.isDeleted) ||
        (entity is ArticleEntity && entity.isDeleted);
  }

  bool isBlockedOrBlocking(WidgetRef ref, IonConnectEntity entity) {
    return ref.watch(isEntityBlockedOrBlockingProvider(entity));
  }

  /// When we fetch lists (e.g. feed, search or data for tabs in profiles),
  /// we don't need to fetch the user metadata or block list explicitly - it is returned as a side effect to the
  /// main request.
  /// In such cases, we just have to wait until the metadata and block list appears
  /// in cache and then show the post (or not, if author is blocked/blocking).
  bool hasMetadata(WidgetRef ref, IonConnectEntity entity) {
    final userMetadata = ref.watch(cachedUserMetadataProvider(entity.masterPubkey));
    return userMetadata != null;
  }
}

class _BottomSeparator extends StatelessWidget {
  const _BottomSeparator({required this.height, required this.child});

  final double height;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: height,
            color: context.theme.appColors.primaryBackground,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: height),
        child: child,
      ),
    );
  }
}
