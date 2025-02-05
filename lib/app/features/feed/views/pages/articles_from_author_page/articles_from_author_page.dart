// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/features/components/entities_list/entities_list.dart';
import 'package:ion/app/features/components/entities_list/entities_list_skeleton.dart';
import 'package:ion/app/features/feed/providers/user_articles_data_source_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';

class ArticlesFromAuthorPage extends ConsumerWidget {
  const ArticlesFromAuthorPage({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(userMetadataProvider(pubkey)).valueOrNull;
    final dataSource = ref.watch(userArticlesDataSourceProvider(pubkey));
    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
    final entities = entitiesPagedData?.data.items;

    return Scaffold(
      appBar: NavigationAppBar.screen(
        title: Text(userMetadata?.data.displayName ?? ''),
      ),
      body: LoadMoreBuilder(
        hasMore: entitiesPagedData?.hasMore ?? false,
        onLoadMore: ref.read(entitiesPagedDataProvider(dataSource).notifier).fetchEntities,
        slivers: [
          if (entities == null)
            const EntitiesListSkeleton()
          else
            EntitiesList(
              entities: entities.toList(),
              hideBlocked: false,
            ),
        ],
      ),
    );
  }
}
