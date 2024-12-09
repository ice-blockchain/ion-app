// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/features/components/entities_list/entities_list.dart';
import 'package:ion/app/features/components/entities_list/entities_list_skeleton.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/empty_state.dart';

class TabEntitiesList extends ConsumerWidget {
  const TabEntitiesList({
    required this.dataSource,
    this.builder,
    super.key,
  });

  final List<EntitiesDataSource>? dataSource;

  final Widget Function(List<NostrEntity> entities)? builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
    final entities = entitiesPagedData?.data.items;

    return LoadMoreBuilder(
      slivers: [
        if (entities == null)
          const EntitiesListSkeleton()
        else if (entities.isEmpty)
          const EmptyState()
        else
          builder != null ? builder!(entities.toList()) : EntitiesList(entities: entities.toList()),
      ],
      onLoadMore: ref.read(entitiesPagedDataProvider(dataSource).notifier).fetchEntities,
      hasMore: entitiesPagedData?.hasMore ?? true,
      builder: (context, slivers) => CustomScrollView(slivers: slivers),
    );
  }
}
