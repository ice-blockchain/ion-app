import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.c.dart';
import 'package:ion/app/features/user/model/follow_type.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_app_bar.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_list_item.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_list_loading.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_search_bar.dart';
import 'package:ion/app/features/user/providers/followers_count_provider.c.dart';
import 'package:ion/app/features/user/providers/followers_data_source_provider.c.dart';

class FollowersList extends ConsumerWidget {
  const FollowersList({required this.pubkey, super.key});

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followersCount = ref.watch(followersCountProvider(pubkey)).valueOrNull;
    final dataSource = ref.watch(followersDataSourceProvider(pubkey));
    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
    final entities = entitiesPagedData?.data.items?.toList();

    final slivers = [
      FollowAppBar(title: FollowType.followers.getTitleWithCounter(context, followersCount ?? 0)),
      const FollowSearchBar(),
      if (entities != null)
        SliverList.separated(
          separatorBuilder: (_, __) => SizedBox(height: 16.0.s),
          itemCount: entities.length,
          itemBuilder: (context, index) => _ListItem(pubkey: entities[index].masterPubkey),
        )
      else
        const FollowListLoading(),
      SliverPadding(padding: EdgeInsets.only(bottom: 32.0.s)),
    ];

    return LoadMoreBuilder(
      slivers: slivers,
      hasMore: entitiesPagedData?.hasMore ?? false,
      onLoadMore: ref.read(entitiesPagedDataProvider(dataSource).notifier).fetchEntities,
      builder: (context, slivers) => CustomScrollView(slivers: slivers),
    );
  }
}

class _ListItem extends ConsumerWidget {
  const _ListItem({required this.pubkey});

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadata = ref.watch(
      nostrCacheProvider.select(
        cacheSelector<UserMetadataEntity>(
          UserMetadataEntity.cacheKeyBuilder(pubkey: pubkey),
        ),
      ),
    );
    return ScreenSideOffset.small(
      child: FollowListItem(userMetadata: userMetadata),
    );
  }
}
