// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/components/entities_list/entities_list.dart';
import 'package:ion/app/features/components/entities_list/entities_list_skeleton.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/tab_entity_type.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/empty_state.dart';
import 'package:ion/app/features/user/providers/tab_data_source_family.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/utils/username.dart';

class TabEntitiesList extends ConsumerWidget {
  factory TabEntitiesList({
    required String pubkey,
    required TabEntityType type,
    Key? key,
  }) {
    return TabEntitiesList._(
      type: type,
      pubkey: pubkey,
      builder: type == TabEntityType.replies
          ? (entities) => EntitiesList(entities: entities.toList(), showParent: true)
          : null,
      key: key,
    );
  }

  const TabEntitiesList._({
    required this.type,
    required this.pubkey,
    this.builder,
    super.key,
  });

  final String pubkey;

  final Widget Function(List<NostrEntity> entities)? builder;

  final TabEntityType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(userMetadataProvider(pubkey)).valueOrNull;
    final dataSource = ref.watch(tabDataSourceProviderFamily((type, pubkey)));
    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
    final entities = entitiesPagedData?.data.items;

    return LoadMoreBuilder(
      slivers: [
        if (entities == null)
          const EntitiesListSkeleton()
        else if (entities.isEmpty)
          EmptyState(
            type: type,
            isCurrentUserProfile: pubkey == ref.watch(currentPubkeySelectorProvider),
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
