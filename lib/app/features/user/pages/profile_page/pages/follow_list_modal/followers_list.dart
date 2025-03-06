// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/event_count_result_data.c.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/follow_type.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_app_bar.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_list_item.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_list_loading.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_search_bar.dart';
import 'package:ion/app/features/user/providers/followers_count_provider.c.dart';
import 'package:ion/app/features/user/providers/followers_data_source_provider.c.dart';
import 'package:ion/app/features/user/providers/relevant_followers_data_source_provider.c.dart';

class FollowersList extends ConsumerWidget {
  const FollowersList({
    required this.pubkey,
    this.isRelevantFollowers = false,
    super.key,
  });

  factory FollowersList.relevant({required String pubkey}) =>
      FollowersList(pubkey: pubkey, isRelevantFollowers: true);

  final String pubkey;
  final bool isRelevantFollowers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: clarify how to get relevant followers count
    final followersCount = ref
        .watch(followersCountProvider(pubkey: pubkey, type: EventCountResultType.followers))
        .valueOrNull;
    final dataSource = isRelevantFollowers
        ? ref.watch(relevantFollowersDataSourceProvider(pubkey, limit: 20))
        : ref.watch(followersDataSourceProvider(pubkey));
    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
    final entities = entitiesPagedData?.data.items?.toList();

    final slivers = [
      FollowAppBar(title: FollowType.followers.getTitleWithCounter(context, followersCount ?? 0)),
      const FollowSearchBar(),
      if (entities != null)
        SliverList.separated(
          separatorBuilder: (_, __) => SizedBox(height: 16.0.s),
          itemCount: entities.length,
          itemBuilder: (context, index) => ScreenSideOffset.small(
            child: FollowListItem(pubkey: entities[index].masterPubkey),
          ),
        )
      else
        const FollowListLoading(),
      SliverPadding(padding: EdgeInsets.only(bottom: 32.0.s)),
    ];

    return LoadMoreBuilder(
      slivers: slivers,
      hasMore: entitiesPagedData?.hasMore ?? false,
      onLoadMore: ref.read(entitiesPagedDataProvider(dataSource).notifier).fetchEntities,
    );
  }
}
