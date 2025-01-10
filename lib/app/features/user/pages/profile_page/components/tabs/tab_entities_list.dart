// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/components/entities_list/entities_list.dart';
import 'package:ion/app/features/components/entities_list/entities_list_skeleton.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/tab_entity_type.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/empty_state.dart';
import 'package:ion/app/features/user/providers/block_list_notifier.c.dart';
import 'package:ion/app/features/user/providers/tab_data_source_provider.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/utils/username.dart';

class TabEntitiesList extends ConsumerWidget {
  const TabEntitiesList({
    required this.type,
    required this.pubkey,
    this.builder,
    super.key,
  });

  factory TabEntitiesList.replies({
    required String pubkey,
    Key? key,
  }) {
    return TabEntitiesList(
      key: key,
      type: TabEntityType.replies,
      pubkey: pubkey,
      builder: (entities) => EntitiesList(entities: entities.toList(), showParent: true),
    );
  }

  final String pubkey;

  final Widget Function(List<IonConnectEntity> entities)? builder;

  final TabEntityType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(userMetadataProvider(pubkey)).valueOrNull;
    final dataSource = ref.watch(tabDataSourceProvider(type: type, pubkey: pubkey));
    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
    final isBlockedOrBlocking = ref.watch(isBlockedOrBlockingProvider(pubkey)).value;
    final entities = entitiesPagedData?.data.items;

    return LoadMoreBuilder(
      slivers: [
        if (entities == null || isBlockedOrBlocking == null)
          const EntitiesListSkeleton()
        else if (entities.isEmpty || isBlockedOrBlocking)
          EmptyState(
            type: type,
            isCurrentUserProfile: pubkey == ref.watch(currentPubkeySelectorProvider).valueOrNull,
            username: prefixUsername(username: userMetadata?.data.name, context: context),
          )
        else
          builder != null ? builder!(entities.toList()) : EntitiesList(entities: entities.toList()),
      ],
      onLoadMore: ref.read(entitiesPagedDataProvider(dataSource).notifier).fetchEntities,
      hasMore: entitiesPagedData?.hasMore ?? true,
      builder: (context, slivers) => CustomScrollView(slivers: slivers),
    );
  }
}
