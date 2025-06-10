// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/nothing_is_found/nothing_is_found.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/data/models/follow_type.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_app_bar.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_list_item.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_list_loading.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_search_bar.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/features/user/providers/search_following_users_data_source_provider.c.dart';

class FollowingList extends HookConsumerWidget {
  const FollowingList({required this.pubkey, super.key});

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followeePubkeys = ref.watch(followListProvider(pubkey)).valueOrNull?.pubkeys;
    final searchQuery = useState('');
    final debouncedQuery = useDebounced(searchQuery.value, const Duration(milliseconds: 300)) ?? '';

    final searchDataSource =
        ref.watch(searchFollowingUsersDataSourceProvider(pubkey, query: debouncedQuery));
    final searchPagedData = ref.watch(entitiesPagedDataProvider(searchDataSource));
    final searchFollowees = searchPagedData?.data.items?.toList();

    return LoadMoreBuilder(
      hasMore: searchPagedData?.hasMore ?? false,
      onLoadMore: ref.read(entitiesPagedDataProvider(searchDataSource).notifier).fetchEntities,
      slivers: [
        FollowAppBar(
          title: FollowType.following.getTitleWithCounter(context, followeePubkeys?.length ?? 0),
        ),
        FollowSearchBar(onTextChanged: (query) => searchQuery.value = query),
        if (searchQuery.value.isNotEmpty)
          if (searchFollowees == null)
            const FollowListLoading()
          else if (searchFollowees.isEmpty)
            const NothingIsFound()
          else
            SliverList.builder(
              itemCount: searchFollowees.length,
              itemBuilder: (context, index) => ScreenSideOffset.small(
                child: FollowListItem(pubkey: searchFollowees[index].masterPubkey),
              ),
            )
        else if (followeePubkeys != null)
          SliverList.builder(
            itemCount: followeePubkeys.length,
            itemBuilder: (context, index) => ScreenSideOffset.small(
              child: FollowListItem(pubkey: followeePubkeys[index]),
            ),
          )
        else
          const FollowListLoading(),
        SliverPadding(padding: EdgeInsetsDirectional.only(bottom: 32.0.s)),
      ],
    );
  }
}
