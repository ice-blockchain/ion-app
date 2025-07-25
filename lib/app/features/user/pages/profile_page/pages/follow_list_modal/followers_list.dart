// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/nothing_is_found/nothing_is_found.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.m.dart';
import 'package:ion/app/features/user/model/follow_type.dart';
import 'package:ion/app/features/user/model/user_metadata.f.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_app_bar.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_list_item.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_list_loading.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_search_bar.dart';
import 'package:ion/app/features/user/providers/followers_data_source_provider.r.dart';

final _followersEntitiesProvider = Provider.autoDispose
    .family<List<UserMetadataEntity>?, ({String pubkey, String? query})>((ref, params) {
  final dataSource = ref.watch(followersDataSourceProvider(params.pubkey, query: params.query));
  final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
  return entitiesPagedData?.data.items?.whereType<UserMetadataEntity>().toList();
});

class FollowersList extends HookConsumerWidget {
  const FollowersList({required this.pubkey, super.key});

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = useState('');
    final debouncedQuery = useDebounced(searchQuery.value, const Duration(milliseconds: 300)) ?? '';

    final entities = ref.watch(
      _followersEntitiesProvider(
        (pubkey: pubkey, query: debouncedQuery.isEmpty ? null : debouncedQuery),
      ),
    );

    final followersCount = entities?.length ?? 0;

    final currentDataSource = ref.watch(
      followersDataSourceProvider(pubkey, query: debouncedQuery.isEmpty ? null : debouncedQuery),
    );
    final currentEntitiesPagedData = ref.watch(entitiesPagedDataProvider(currentDataSource));

    final slivers = [
      FollowAppBar(title: FollowType.followers.getTitleWithCounter(context, followersCount)),
      FollowSearchBar(onTextChanged: (query) => searchQuery.value = query),
      if (entities == null)
        const FollowListLoading()
      else if (entities.isEmpty)
        const NothingIsFound()
      else
        SliverList.builder(
          itemCount: entities.length,
          itemBuilder: (context, index) => ScreenSideOffset.small(
            child: FollowListItem(pubkey: entities[index].masterPubkey),
          ),
        ),
      SliverPadding(padding: EdgeInsetsDirectional.only(bottom: 32.0.s)),
    ];

    return LoadMoreBuilder(
      slivers: slivers,
      hasMore: currentEntitiesPagedData?.hasMore ?? false,
      onLoadMore: ref.read(entitiesPagedDataProvider(currentDataSource).notifier).fetchEntities,
    );
  }
}
