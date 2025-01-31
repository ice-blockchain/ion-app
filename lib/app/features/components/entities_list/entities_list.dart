// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/async_value_listener.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/entities_list/components/article_list_item.dart';
import 'package:ion/app/features/components/entities_list/components/generic_repost_list_item.dart';
import 'package:ion/app/features/components/entities_list/components/post_list_item.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/user/providers/block_list_notifier.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';

class EntitiesList extends HookWidget {
  const EntitiesList({
    required this.entities,
    this.framedEventType = FramedEventType.quoted,
    this.separatorHeight,
    this.hideBlocked = true,
    super.key,
  });

  final List<IonConnectEntity> entities;
  final double? separatorHeight;
  final FramedEventType framedEventType;
  final bool hideBlocked;

  @override
  Widget build(BuildContext context) {
    final blockedEntitiesIds = useState(<String, bool>{});

    return SliverList.builder(
      itemCount: entities.length,
      itemBuilder: (BuildContext context, int index) {
        return _EntityListItem(
          entity: entities[index],
          framedEventType: framedEventType,
          separatorHeight: separatorHeight,
          hideBlocked: hideBlocked,
          blockedIds: blockedEntitiesIds,
        );
      },
    );
  }
}

class _EntityListItem extends ConsumerWidget {
  const _EntityListItem({
    required this.entity,
    required this.separatorHeight,
    required this.framedEventType,
    required this.hideBlocked,
    required this.blockedIds,
  });

  final IonConnectEntity entity;
  final double? separatorHeight;
  final FramedEventType framedEventType;
  final bool hideBlocked;
  final ValueNotifier<Map<String, bool>> blockedIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata =
        ref.watch(userMetadataProvider(entity.masterPubkey, network: false)).valueOrNull;

    ref.listenAsyncValue(
      isEntityBlockedOrBlockingProvider(entity, cacheOnly: true),
      onSuccess: (blocked) {
        if (blocked != null && blockedIds.value[entity.id] != blocked) {
          blockedIds.value = {...blockedIds.value, entity.id: blocked};
        }
      },
    );
    final isBlockedOrBlocking = blockedIds.value[entity.id] ?? true;

    if (userMetadata == null || (isBlockedOrBlocking && hideBlocked)) {
      /// When we fetch lists (e.g. feed, search or data for tabs in profiles),
      /// we don't need to fetch the user metadata or block list explicitly - it is returned as a side effect to the
      /// main request.
      /// In such cases, we just have to wait until the metadata and block list appears
      /// in cache and then show the post (or not, if author is blocked/blocking).
      return const SizedBox.shrink();
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: separatorHeight ?? 12.0.s,
            color: context.theme.appColors.primaryBackground,
          ),
        ),
      ),
      child: switch (entity) {
        ModifiablePostEntity() ||
        PostEntity() =>
          PostListItem(eventReference: entity.toEventReference(), framedEventType: framedEventType),
        final ArticleEntity article => ArticleListItem(article: article),
        final GenericRepostEntity repost => GenericRepostListItem(repost: repost),
        _ => const SizedBox.shrink()
      },
    );
  }
}
