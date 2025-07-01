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
import 'package:ion/app/features/user/model/follow_type.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_app_bar.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_list_item.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_list_loading.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_search_bar.dart';
import 'package:ion/app/features/user/providers/followers_count_provider.r.dart';
import 'package:ion/app/features/user/providers/followers_data_source_provider.r.dart';
import 'package:ion/app/features/user/providers/debounced_followers_provider.dart';
import 'package:ion/app/features/user/providers/followers_count_provider.c.dart';

class FollowersList extends HookConsumerWidget {
  const FollowersList({required this.pubkey, super.key});

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followersCount = ref.watch(followersCountProvider(pubkey)).valueOrNull;

    final searchQuery = useState('');
    final debouncedQuery = useDebounced(searchQuery.value, const Duration(milliseconds: 300)) ?? '';

    // Use the debounced followers provider
    final debouncedProvider = ref.watch(
      debouncedFollowersListStateProvider((pubkey: pubkey, query: debouncedQuery.isEmpty ? null : debouncedQuery))
    );
    final debouncedState = ref.watch(debouncedProvider);
    
    final entities = debouncedState?.entities;

    final slivers = [
      FollowAppBar(title: FollowType.followers.getTitleWithCounter(context, followersCount ?? 0)),
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
      hasMore: debouncedState?.hasMore ?? false,
      onLoadMore: () => ref.read(
        followersNotifierProvider(pubkey, query: debouncedQuery.isEmpty ? null : debouncedQuery)
      ).fetchEntities(),
    );
  }
}
