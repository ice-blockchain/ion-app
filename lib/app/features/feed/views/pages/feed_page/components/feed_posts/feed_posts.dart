// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/empty_list/empty_list.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/entities_list/entities_list.dart';
import 'package:ion/app/features/components/entities_list/entities_list_skeleton.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_posts_data_source_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/providers/block_list_notifier.c.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/generated/assets.gen.dart';

class FeedPosts extends HookConsumerWidget {
  const FeedPosts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(feedPostsDataSourceProvider);

    // Prefetching block list here so it can be used later with sync provider
    useOnInit(() {
      ref.read(currentUserBlockListProvider);
    });

    List<IonConnectEntity>? entities;

    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
    if (entitiesPagedData?.data.items != null) {
      entities = entitiesPagedData?.data.items?.toList();
    }

    if (entities == null) {
      return const EntitiesListSkeleton();
    } else if (entities.isEmpty) {
      return const _EmptyState();
    }

    return EntitiesList(
      entities: entities,
    );
  }
}

class _EmptyState extends ConsumerWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedCategory = ref.watch(feedCurrentFilterProvider.select((state) => state.category));
    final postsTypes = feedCategory.getPostsNames(context);
    return SliverFillRemaining(
      hasScrollBody: false,
      child: EmptyList(
        asset: Assets.svg.walletIconProfileEmptyposts,
        title: context.i18n.feed_posts_empty(postsTypes),
      ),
    );
  }
}
