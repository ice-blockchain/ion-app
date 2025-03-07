// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/nothing_is_found/nothing_is_found.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/follow_type.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_app_bar.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_list_item.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_list_loading.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_list_separator.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_search_bar.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/features/user/providers/search_following_users_data_source_provider.c.dart';

class FollowingList extends HookConsumerWidget {
  const FollowingList({required this.pubkey, super.key});

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pubkeys = ref.watch(followListProvider(pubkey)).valueOrNull?.pubkeys;
    final searchQuery = useState('');

    return CustomScrollView(
      slivers: [
        FollowAppBar(
          title: FollowType.following.getTitleWithCounter(context, pubkeys?.length ?? 0),
        ),
        FollowSearchBar(onTextChanged: (query) => searchQuery.value = query),
        if (searchQuery.value.isNotEmpty)
          _FollowingSearch(query: searchQuery.value)
        else if (pubkeys != null)
          SliverList.separated(
            separatorBuilder: (_, __) => const FollowListSeparator(),
            itemCount: pubkeys.length,
            itemBuilder: (context, index) => ScreenSideOffset.small(
              child: FollowListItem(pubkey: pubkeys[index]),
            ),
          )
        else
          const FollowListLoading(),
        SliverPadding(padding: EdgeInsets.only(bottom: 32.0.s)),
      ],
    );
  }
}

class _FollowingSearch extends HookConsumerWidget {
  const _FollowingSearch({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debouncedQuery = useDebounced(query, const Duration(milliseconds: 300)) ?? '';

    final dataSource = ref.watch(searchFollowingUsersDataSourceProvider(query: debouncedQuery));
    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
    final entities = entitiesPagedData?.data.items?.toList();
    final hasMore = entitiesPagedData?.hasMore ?? false;

    if (entities == null) {
      return const FollowListLoading();
    }

    if (entities.isEmpty && !hasMore) {
      return const NothingIsFound();
    }

    return LoadMoreBuilder(
      hasMore: hasMore,
      onLoadMore: ref.read(entitiesPagedDataProvider(dataSource).notifier).fetchEntities,
      slivers: [
        SliverList.separated(
          separatorBuilder: (_, __) => const FollowListSeparator(),
          itemCount: entities.length,
          itemBuilder: (context, index) => ScreenSideOffset.small(
            child: FollowListItem(pubkey: entities[index].masterPubkey),
          ),
        ),
      ],
      builder: (context, slivers) => SliverMainAxisGroup(slivers: slivers),
    );
  }
}
