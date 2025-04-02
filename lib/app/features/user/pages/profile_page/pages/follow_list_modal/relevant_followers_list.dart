// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/follow_type.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_app_bar.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_list_item.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_list_loading.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_search_bar.dart';
import 'package:ion/app/features/user/providers/relevant_followers_data_source_provider.c.dart';

class RelevantFollowersList extends ConsumerWidget {
  const RelevantFollowersList({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(relevantFollowersDataSourceProvider(pubkey, limit: 20));

    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
    final entities = entitiesPagedData?.data.items?.toList();

    // TODO: clarify how to get relevant followers count
    final followersCount = entities?.length ?? 0;

    final slivers = [
      FollowAppBar(title: FollowType.followers.getTitleWithCounter(context, followersCount)),
      const FollowSearchBar(),
      if (entities != null)
        SliverList.builder(
          itemCount: entities.length,
          itemBuilder: (context, index) => ScreenSideOffset.small(
            child: FollowListItem(pubkey: entities[index].masterPubkey),
          ),
        )
      else
        const FollowListLoading(),
      SliverPadding(padding: EdgeInsetsDirectional.only(bottom: 32.0.s)),
    ];

    return LoadMoreBuilder(
      slivers: slivers,
      hasMore: entitiesPagedData?.hasMore ?? false,
      onLoadMore: ref.read(entitiesPagedDataProvider(dataSource).notifier).fetchEntities,
    );
  }
}
