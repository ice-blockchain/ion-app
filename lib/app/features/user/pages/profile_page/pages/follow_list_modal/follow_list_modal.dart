// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/list_items_loading_state/list_items_loading_state.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.c.dart';
import 'package:ion/app/features/user/model/follow_type.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/follow_list_modal/components/follow_list_item.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/features/user/providers/followers_count_provider.c.dart';
import 'package:ion/app/features/user/providers/followers_data_source_provider.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class FollowListView extends ConsumerWidget {
  const FollowListView({
    required this.followType,
    required this.pubkey,
    super.key,
  });

  final FollowType followType;
  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SheetContent(
      body: switch (followType) {
        FollowType.following => _FollowingList(pubkey: pubkey),
        FollowType.followers => _FollowersList(pubkey: pubkey),
      },
    );
  }
}

class _FollowingList extends ConsumerWidget {
  const _FollowingList({required this.pubkey});

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pubkeys = ref.watch(followListProvider(pubkey)).valueOrNull?.pubkeys;

    return CustomScrollView(
      slivers: [
        _AppBar(title: FollowType.following.getTitleWithCounter(context, pubkeys?.length ?? 0)),
        const _SearchBar(),
        if (pubkeys != null)
          SliverList.separated(
            separatorBuilder: (_, __) => SizedBox(height: 16.0.s),
            itemCount: pubkeys.length,
            itemBuilder: (context, index) {
              return Consumer(
                builder: (_, ref, __) {
                  final userMetadata = ref.watch(userMetadataProvider(pubkeys[index])).valueOrNull;
                  return ScreenSideOffset.small(
                    child: FollowListItem(userMetadata: userMetadata),
                  );
                },
              );
            },
          )
        else
          const _Loading(),
        SliverPadding(padding: EdgeInsets.only(bottom: 32.0.s)),
      ],
    );
  }
}

class _FollowersList extends ConsumerWidget {
  const _FollowersList({required this.pubkey});

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followersCount = ref.watch(followersCountProvider(pubkey)).valueOrNull;
    final dataSource = ref.watch(followersDataSourceProvider(pubkey));
    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
    final entities = entitiesPagedData?.data.items?.toList();

    final slivers = [
      _AppBar(title: FollowType.followers.getTitleWithCounter(context, followersCount ?? 0)),
      const _SearchBar(),
      if (entities != null)
        SliverList.separated(
          separatorBuilder: (_, __) => SizedBox(height: 16.0.s),
          itemCount: entities.length,
          itemBuilder: (context, index) {
            return Consumer(
              builder: (_, ref, __) {
                final userMetadata = ref.watch(
                  nostrCacheProvider.select(
                    cacheSelector<UserMetadataEntity>(
                      UserMetadataEntity.cacheKeyBuilder(pubkey: entities[index].masterPubkey),
                    ),
                  ),
                );
                return ScreenSideOffset.small(
                  child: FollowListItem(userMetadata: userMetadata),
                );
              },
            );
          },
        )
      else
        const _Loading(),
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

class _AppBar extends StatelessWidget {
  const _AppBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      primary: false,
      flexibleSpace: NavigationAppBar.modal(
        actions: [NavigationCloseButton(onPressed: context.pop)],
        title: Text(title),
      ),
      automaticallyImplyLeading: false,
      toolbarHeight: NavigationAppBar.modalHeaderHeight,
      pinned: true,
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return PinnedHeaderSliver(
      child: ColoredBox(
        color: context.theme.appColors.onPrimaryAccent,
        child: Column(
          children: [
            SizedBox(height: 16.0.s),
            ScreenSideOffset.small(
              child: SearchInput(
                onTextChanged: (String value) {},
              ),
            ),
            SizedBox(height: 16.0.s),
          ],
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return ListItemsLoadingState(
      itemHeight: FollowListItem.itemHeight,
      padding: EdgeInsets.zero,
      listItemsLoadingStateType: ListItemsLoadingStateType.scrollView,
    );
  }
}
