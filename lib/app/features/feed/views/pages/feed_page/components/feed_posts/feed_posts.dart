// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/components/entities_list/entities_list.dart';
import 'package:ion/app/features/components/entities_list/entities_list_skeleton.dart';
import 'package:ion/app/features/feed/providers/feed_posts_data_source_provider.c.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.c.dart';

class FeedPosts extends ConsumerWidget {
  const FeedPosts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(feedPostsDataSourceProvider);

    List<NostrEntity>? entities;

    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
    if (entitiesPagedData?.data.items != null) {
      entities = entitiesPagedData?.data.items?.toList();
    }

    if (entities == null || entities.isEmpty) {
      return const EntitiesListSkeleton();
    }

    return EntitiesList(
      entities: entities,
    );
  }
}
